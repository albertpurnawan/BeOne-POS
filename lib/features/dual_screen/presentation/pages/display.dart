import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/core/utilities/helpers.dart';
import 'package:pos_fe/core/utilities/snack_bar_helper.dart';
import 'package:pos_fe/features/dual_screen/data/models/dual_screen.dart';
import 'package:pos_fe/features/sales/data/models/cashier_balance_transaction.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:pos_fe/features/sales/domain/repository/cash_register_repository.dart';

class DisplayPage extends StatefulWidget {
  const DisplayPage({
    super.key,
    required this.windowController,
    required this.args,
  });

  final WindowController windowController;
  final Map<String, dynamic> args;

  @override
  State<DisplayPage> createState() => _DisplayPageState();
}

class _DisplayPageState extends State<DisplayPage> {
  List<DualScreenModel> largeBanners = [];
  List<DualScreenModel> smallBanners = [];
  Map<String, VideoPlayerController?> videoControllers = {};
  Map<String, bool> videoDownloading = {};
  Map<String, String> localVideoPaths = {};
  bool isLoading = true;
  bool _isVideoPlaying = false;
  Timer? _timer1;
  Timer? _timer2;
  int _currentIndex = 0;
  int _currentIndex2 = 0;
  bool tabSales = true;
  bool tabStock = true;
  bool isVideoTop = true;
  bool isVideoBot = true;
  final dio = Dio();
  SharedPreferences? _prefs;
  CashierBalanceTransactionModel? _activeShift;

  // Add sales data state
  Map<String, dynamic> currentSalesData = {};
  String? cashRegisterId;
  String? username;

  Future<void> _loadBanners() async {
    try {
      setState(() => isLoading = true);
      print('Debug - Starting to load banners');

      // Ensure database is initialized
      final allBanners =
          await GetIt.instance<AppDatabase>().dualScreenDao.readAll();
      print('All banners: $allBanners');
      // if (appDatabase == null) {
      //   print('Debug - AppDatabase is not initialized');

      //   // Attempt to initialize the database if not already registered
      //   final newDatabase = await AppDatabase.init();
      //   GetIt.instance.registerSingleton<AppDatabase>(newDatabase);
      // }

      // // Get all banners from database
      // final allBanners =
      //     await GetIt.instance<AppDatabase>().dualScreenDao.readAll();

      // // Additional debug information
      // print('Debug - Total banners fetched: ${allBanners.length}');
      // allBanners.forEach((banner) {
      //   print(
      //       'Debug - Banner: type=${banner.type}, path=${banner.path}, order=${banner.order}');
      // });

      // if (allBanners.isEmpty) {
      //   print('Debug - No banners found in the database');
      // }

      // setState(() {
      //   // Split banners by type (1 for large, 2 for small)
      //   largeBanners = allBanners.where((banner) => banner.type == 1).toList()
      //     ..sort((a, b) => a.order.compareTo(b.order));
      //   smallBanners = allBanners.where((banner) => banner.type == 2).toList()
      //     ..sort((a, b) => a.order.compareTo(b.order));

      //   print('Debug - Large banners count: ${largeBanners.length}');
      //   print('Debug - Small banners count: ${smallBanners.length}');

      //   isLoading = false;
      // });
    } catch (e, stackTrace) {
      print('Debug - Detailed error loading banners:');
      print('Error: $e');
      print('Stacktrace: $stackTrace');

      setState(() => isLoading = false);

      if (mounted) {
        // More informative error message
        SnackBarHelper.presentErrorSnackBar(context,
            'Failed to load banners. Please check your connection and try again. Error: ${e.toString()}');
      }
    }
  }

  Future<void> _getCashRegisterData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final tocsrId = prefs.getString('tocsr_id');

      if (tocsrId != null) {
        final cashRegisterRepository = GetIt.instance<CashRegisterRepository>();
        final cashRegister =
            await cashRegisterRepository.getCashRegisterByDocId(tocsrId);

        if (cashRegister != null) {
          setState(() {
            cashRegisterId = cashRegister.idKassa;
          });
          debugPrint('Cash Register ID: $cashRegisterId');
        }
      }
    } catch (e) {
      debugPrint('Error getting cash register data: $e');
    }
  }

  Future<void> _initializeShiftData() async {
    try {
      final db = GetIt.instance<AppDatabase>();
      final shift = await db.cashierBalanceTransactionDao.readLastValue();
      if (mounted && shift != null) {
        setState(() {
          _activeShift = shift;
          cashRegisterId = shift.tocsrId;
        });
        print('Debug - Loaded shift data: ${shift.tocsrId}');
      }
    } catch (e) {
      print('Debug - Error loading shift data: $e');
    }
  }

  Future<void> _initializePrefs() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      if (mounted) {
        setState(() {
          username = _prefs?.getString('username') ?? 'Unknown User';
        });
        print('Debug - Username from prefs: $username');
      }
    } catch (e) {
      print('Debug - Error initializing SharedPreferences: $e');
    }
  }

  Future<void> _initializeUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        username = prefs.getString('username') ?? '...';
      });
    } catch (e) {
      debugPrint('Error getting username: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeVideos();
    _startTimers();
    _setupWindowListener();
    _initializePrefs();
    _initializeShiftData();
    _loadBanners();

    // Initialize data from window arguments
    final args = widget.args;
    print('Debug - Received window arguments: $args');

    if (args != null) {
      final receivedUsername = args['username'];
      final receivedCashRegisterId = args['cashRegisterId'];
      print('Debug - Received username: $receivedUsername');
      print('Debug - Received cash register ID: $receivedCashRegisterId');

      setState(() {
        username = receivedUsername ?? username ?? 'Unknown User';
        cashRegisterId = receivedCashRegisterId ??
            _activeShift?.tocsrId ??
            'Unknown Register';
      });
    } else {
      print('Debug - No arguments received from main window');
    }
  }

  void _setupWindowListener() {
    DesktopMultiWindow.setMethodHandler((call, fromWindowId) async {
      debugPrint('Received message from window $fromWindowId: ${call.method}');

      switch (call.method) {
        case 'updateSalesData':
          try {
            final String jsonString = call.arguments as String;
            debugPrint('Received data: $jsonString');
            final data = jsonDecode(jsonString);
            setState(() {
              currentSalesData = data;
              tabSales = true;
            });
            return true;
          } catch (e, stackTrace) {
            debugPrint('Error processing sales data: $e');
            debugPrint(stackTrace.toString());
            return false;
          }
        default:
          return null;
      }
    });
  }

  Widget _buildSalesDisplay() {
    return Expanded(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: Colors.grey,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: DataTable(
            headingRowColor: MaterialStateProperty.all(ProjectColors.primary),
            columns: const [
              DataColumn(
                label: Center(
                  child: Text(
                    'No',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              DataColumn(
                label: Center(
                  child: Text(
                    'Item Name',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              DataColumn(
                label: Center(
                  child: Text(
                    'Qty.',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              DataColumn(
                label: Center(
                  child: Text(
                    'Discount',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              DataColumn(
                label: Center(
                  child: Text(
                    'Total',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
            rows: currentSalesData['items'] == null
                ? []
                : List<DataRow>.generate(
                    currentSalesData['items']!.length,
                    (index) {
                      final item = currentSalesData['items']![index];
                      return DataRow(
                        cells: [
                          DataCell(Text('${index + 1}')),
                          DataCell(Text('${item['name']}')),
                          DataCell(Text('${item['quantity']}')),
                          DataCell(Text('${item['promos'] ?? '-'}')),
                          DataCell(Text(Helpers.parseMoney(item['total']))),
                        ],
                      );
                    },
                  ),
          ),
        ),
      ),
    );
  }

  Future<void> _initializeVideos() async {
    final videos = largeBanners.where((media) => media.type == 2);
    for (var video in videos) {
      final url = video.path;
      _downloadAndInitVideo(url);
    }
    final videos2 = smallBanners.where((media) => media.type == 2);
    for (var video in videos2) {
      final url = video.path;
      _downloadAndInitVideo(url);
    }
  }

  Future<void> _downloadAndInitVideo(String url) async {
    try {
      setState(() {
        videoDownloading[url] = true;
      });

      // Create videos directory in assets
      final appDir = await getApplicationDocumentsDirectory();
      final videoDir = Directory(path.join(appDir.path, 'assets', 'videos'));
      await videoDir.create(recursive: true);

      final fileName = path.basename(url);
      final localPath = path.join(videoDir.path, fileName);
      final file = File(localPath);

      if (!await file.exists()) {
        print('Downloading video from: $url');
        print('Saving to: $localPath');
        await dio.download(url, localPath);
      }

      if (videoControllers[url]?.value.isInitialized ?? false) {
        await videoControllers[url]?.dispose();
        videoControllers[url] = null;
      }

      print('Initializing video controller for: $localPath');
      final controller = VideoPlayerController.file(file);

      try {
        await controller.initialize();
        print('Video initialized successfully');
        print('Video duration: ${controller.value.duration}');
        print('Video size: ${controller.value.size}');

        controller.addListener(() {
          if (controller.value.position >= controller.value.duration) {
            setState(() {
              _isVideoPlaying = false;
              if (largeBanners.any((m) => m.path == url)) {
                _moveToNextItem();
              } else {
                _moveToNextItem2();
              }
            });
          }
        });

        setState(() {
          videoControllers[url] = controller;
          videoDownloading[url] = false;
          localVideoPaths[url] = localPath;
        });
      } catch (initError) {
        print('Error initializing video controller: $initError');
        await controller.dispose();
        setState(() {
          videoDownloading[url] = false;
          videoControllers.remove(url);
        });
      }
    } catch (e) {
      print('Error downloading/initializing video: $e');
      setState(() {
        videoDownloading[url] = false;
        videoControllers.remove(url);
      });
    }
  }

  void _startTimers() {
    _timer1 = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (!mounted || _isVideoPlaying) return;
      _moveToNextItem();
    });
    _timer2 = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (!mounted || _isVideoPlaying) return;
      _moveToNextItem2();
    });
  }

  void _moveToNextItem() {
    if (!mounted || largeBanners.isEmpty) return;
    setState(() {
      // Sort largeBanners by order
      largeBanners.sort((a, b) => a.order.compareTo(b.order));
      final currentIndex =
          largeBanners.indexWhere((banner) => banner.order == _currentIndex);
      final nextIndex = (currentIndex + 1) % largeBanners.length;
      _currentIndex = largeBanners[nextIndex].order;

      final currentMedia = largeBanners[nextIndex];
      if (currentMedia.type == 2) {
        final controller = videoControllers[currentMedia.path];
        if (controller != null) {
          controller.play();
          _isVideoPlaying = true;
        }
      }
    });
  }

  void _moveToNextItem2() {
    if (!mounted || smallBanners.isEmpty) return;
    setState(() {
      // Sort smallBanners by order
      smallBanners.sort((a, b) => a.order.compareTo(b.order));
      final currentIndex =
          smallBanners.indexWhere((banner) => banner.order == _currentIndex2);
      final nextIndex = (currentIndex + 1) % smallBanners.length;
      _currentIndex2 = smallBanners[nextIndex].order;

      final currentMedia = smallBanners[nextIndex];
      if (currentMedia.type == 2) {
        final controller = videoControllers[currentMedia.path];
        if (controller != null) {
          controller.play();
          _isVideoPlaying = true;
        }
      }
    });
  }

  Widget _buildMediaWidget(DualScreenModel banner) {
    if (banner.type == 1) {
      // Large banners
      return CachedNetworkImage(
        imageUrl: banner.path,
        placeholder: (context, url) => CircularProgressIndicator(),
        errorWidget: (context, url, error) => Icon(Icons.error),
      );
    } else if (banner.type == 2) {
      // Video banners
      _downloadAndPlayVideo(banner);
      final controller = videoControllers[banner.path];
      return controller != null && controller.value.isInitialized
          ? AspectRatio(
              aspectRatio: controller.value.aspectRatio,
              child: VideoPlayer(controller),
            )
          : CircularProgressIndicator();
    } else {
      return Container();
    }
  }

  Widget _buildBanner(DualScreenModel banner) {
    print('Debug - Building banner of type: ${banner.type}');
    if (banner.type == 1) {
      // Large banners
      return CachedNetworkImage(
        imageUrl: banner.path,
        placeholder: (context, url) => CircularProgressIndicator(),
        errorWidget: (context, url, error) => Icon(Icons.error),
      );
    } else if (banner.type == 2) {
      // Small banners
      return CachedNetworkImage(
        imageUrl: banner.path,
        placeholder: (context, url) => CircularProgressIndicator(),
        errorWidget: (context, url, error) => Icon(Icons.error),
      );
    } else {
      return Container();
    }
  }

  Future<void> _downloadAndPlayVideo(DualScreenModel banner) async {
    try {
      if (videoDownloading[banner.path] == true) return;
      videoDownloading[banner.path] = true;

      final dir = await getApplicationDocumentsDirectory();
      final filePath = path.join(dir.path, path.basename(banner.path));

      if (!File(filePath).existsSync()) {
        await dio.download(banner.path, filePath);
      }

      final controller = VideoPlayerController.file(File(filePath));
      await controller.initialize();

      setState(() {
        videoControllers[banner.path] = controller;
        localVideoPaths[banner.path] = filePath;
      });
    } catch (e) {
      SnackBarHelper.presentErrorSnackBar(
          context, 'Error downloading video: ${e.toString()}');
    } finally {
      videoDownloading[banner.path] = false;
    }
  }

  @override
  void dispose() {
    // Dispose video controllers
    for (var controller in videoControllers.values) {
      controller?.dispose();
    }

    // Clear cached files
    localVideoPaths.forEach((path, filePath) {
      final file = File(filePath);
      if (file.existsSync()) {
        file.deleteSync();
      }
    });

    // Clear other caches if necessary

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cashier = _prefs?.getString('username');
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Stack(children: [
            Row(
              children: [
                if (tabSales) ...[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 20, bottom: 40, right: 12),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Image.asset(
                                "assets/logo/ruby_pos_sesa_icon.png",
                                fit: BoxFit.contain,
                                height: 110,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 1,
                                    color: Colors.grey,
                                  ),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: const BoxDecoration(
                                        color: ProjectColors.primary,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(4),
                                          topRight: Radius.circular(4),
                                        ),
                                      ),
                                      child: const Text(
                                        'Cash Register',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 8,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      _activeShift?.tocsrId ??
                                          cashRegisterId ??
                                          'Unknown Register',
                                      style: const TextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    DateFormat('EEEE, dd MMM yyyy')
                                        .format(DateTime.now()),
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  const Text(
                                    'SESA Store SCDB',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    username ?? '',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          _buildSalesDisplay(),
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 8.0, right: 8.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                          width: 1,
                                          color: Colors.grey,
                                        ),
                                        borderRadius: BorderRadius.circular(8)),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          decoration: const BoxDecoration(
                                              color: ProjectColors.primary,
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(8),
                                                  topRight:
                                                      Radius.circular(8))),
                                          child: const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text('Customer',
                                                    style: TextStyle(
                                                        color: Colors.white)),
                                                Text('NON MEMBER',
                                                    style: TextStyle(
                                                        color: Colors.white)),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text('Total Discount'),
                                              Text('Grand Total'),
                                            ],
                                          ),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text('Total Payment'),
                                              Text('Changed'),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              // Grand Total Section
                              Expanded(
                                flex: 2,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      color: Colors.green,
                                    ),
                                    padding: const EdgeInsets.all(40.0),
                                    child: LayoutBuilder(
                                      builder: (context, constraints) {
                                        final fontSize =
                                            constraints.maxWidth > 800
                                                ? 32.0
                                                : 24.0;
                                        return Column(
                                          children: [
                                            Text(
                                              'Grand Total',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: fontSize),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              'IDR 2,439,000',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: fontSize),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                // Right side: Images with fixed width
                Container(
                  width: 1264, // Fixed width for the right side
                  child: Column(
                    children: [
                      if (isVideoTop) ...[
                        Expanded(
                          flex: 7,
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 10),
                            child: largeBanners.isNotEmpty &&
                                    _currentIndex < largeBanners.length
                                ? _buildMediaWidget(largeBanners.firstWhere(
                                    (banner) => banner.order == _currentIndex))
                                : Container(), // Fallback for empty or out-of-range index
                          ),
                        ),
                      ],
                      const SizedBox(height: 8),
                      if (isVideoBot) ...[
                        Expanded(
                          flex: 3,
                          child: CarouselSlider(
                            options: CarouselOptions(autoPlay: true),
                            items: smallBanners.map((banner) {
                              if (banner.type == 1) {
                                return _buildBanner(banner);
                              } else if (banner.type == 2) {
                                _downloadAndPlayVideo(banner);
                                final controller =
                                    videoControllers[banner.path];
                                return controller != null &&
                                        controller.value.isInitialized
                                    ? AspectRatio(
                                        aspectRatio:
                                            controller.value.aspectRatio,
                                        child: VideoPlayer(controller),
                                      )
                                    : CircularProgressIndicator();
                              } else {
                                return Container();
                              }
                            }).toList(),
                          ),
                        )
                      ]
                    ],
                  ),
                )
              ],
            ),
          ]),
        ));
  }
}
