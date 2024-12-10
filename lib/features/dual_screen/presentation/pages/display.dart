import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:pos_fe/core/utilities/helpers.dart';
import 'package:pos_fe/core/utilities/snack_bar_helper.dart';
import 'package:pos_fe/features/dual_screen/data/models/dual_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import 'package:carousel_slider/carousel_slider.dart';

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
  List<DualScreenModel> largeBannersUrl = [];
  List<DualScreenModel> smallBannersUrl = [];
  List<DualScreenModel> largeBannersLocal = [];
  List<DualScreenModel> smallBannersLocal = [];
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
  VideoPlayerController? _videoControllerLarge;
  VideoPlayerController? _videoControllerSmall;
  bool _isLargeVideoInitialized = false;
  bool _isSmallVideoInitialized = false;

  final dio = Dio();
  SharedPreferences? _prefs;
  late Map<String, dynamic> dataMap;

  // Add sales data state
  late Map<String, dynamic> currentSalesData;

  VideoPlayerController? _videoController;

  Future<void> _loadBanners() async {
    try {
      setState(() => isLoading = true);

      final allBanners = (dataMap['dualScreenModel'] as List<dynamic>)
          .map((banner) =>
              DualScreenModel.fromMap(banner as Map<String, dynamic>))
          .toList();

      setState(() {
        largeBannersUrl = allBanners
            .where((banner) => banner.type == 1 && banner.path.contains('http'))
            .toList()
          ..sort((a, b) => a.order.compareTo(b.order));
        smallBannersUrl = allBanners
            .where((banner) => banner.type == 2 && banner.path.contains('http'))
            .toList()
          ..sort((a, b) => a.order.compareTo(b.order));

        largeBannersLocal = allBanners
            .where(
                (banner) => banner.type == 1 && !banner.path.contains('http'))
            .toList()
          ..sort((a, b) => a.order.compareTo(b.order));
        smallBannersLocal = allBanners
            .where(
                (banner) => banner.type == 2 && !banner.path.contains('http'))
            .toList()
          ..sort((a, b) => a.order.compareTo(b.order));

        isLoading = false;
      });
    } catch (e, stackTrace) {
      print('Error: $e');
      print('Stacktrace: $stackTrace');

      setState(() => isLoading = false);

      if (mounted) {
        // More informative error message
        SnackBarHelper.presentErrorSnackBar(context,
            'Failed to load banners. Please check your connection and try again. Error: ${e.toString()}');
      }
    }
    _downloadAllBanners();
  }

  @override
  void initState() {
    super.initState();

    // Initialize currentSalesData with default values
    currentSalesData = {
      'customerName': '-',
      'items': [],
      'totalDiscount': '-',
      'grandTotal': '-',
      'totalPayment': '-',
      'changed': '-'
    };

    // Setup window listener before processing data
    _setupWindowListener();

    if (widget.args.containsKey('data')) {
      dataMap = jsonDecode(widget.args['data']);
      setState(() {
        dataMap = jsonDecode(widget.args['data']);
        currentSalesData = dataMap;
      });
    }
    _loadBanners();
  }

  void _setupWindowListener() {
    DesktopMultiWindow.setMethodHandler((call, fromWindowId) async {
      switch (call.method) {
        case 'updateSalesData':
          try {
            final String jsonString = call.arguments as String;
            final data = jsonDecode(jsonString);
            setState(() {
              currentSalesData = data;
            });
            return true;
          } catch (e, stackTrace) {
            debugPrint('Error processing sales data: $e');
            debugPrint(stackTrace.toString());
            return false;
          }
        case 'updateBannerData':
          try {
            final String jsonString = call.arguments as String;
            final data = jsonDecode(jsonString);

            setState(() {
              // Update the entire dualScreenModel
              dataMap['dualScreenModel'] = data;

              // Immediately update banner-specific fields
              if (data is Map) {
                // Update large banner if present
                if (data.containsKey('largeBannersUrl') &&
                    data['largeBannersUrl'] is List &&
                    data['largeBannersUrl'].isNotEmpty) {}

                // Update small banner if present
                if (data.containsKey('smallBannersUrl') &&
                    data['smallBannersUrl'] is List &&
                    data['smallBannersUrl'].isNotEmpty) {}
              }
            });
          } catch (e, stackTrace) {
            debugPrint('Error processing banner data: $e');
            debugPrint(stackTrace.toString());
            return false;
          }
        default:
          return null;
      }
    });
  }

  final ScrollController _scrollController = ScrollController();

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Widget _buildSalesDisplay() {
    return Expanded(
      child: SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: Axis.vertical,
        child: DataTable(
          headingRowColor: MaterialStateProperty.all(ProjectColors.primary),
          dataRowMaxHeight: double.infinity,
          headingTextStyle: TextStyle(
            fontSize: 14,
          ),
          dataTextStyle: TextStyle(
            fontSize: 10,
          ),
          border: TableBorder.symmetric(outside: BorderSide(width: 1)),
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
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _scrollToBottom();
                    });
                    return DataRow(
                      cells: [
                        DataCell(Text('${index + 1}')),
                        DataCell(Text('${item['name']}')),
                        DataCell(Text('${item['quantity']}')),
                        DataCell(Text('${item['discount'] ?? '-'}')),
                        DataCell(Text(Helpers.parseMoney(item['total']))),
                      ],
                    );
                  },
                ),
        ),
      ),
    );
  }

  Future<void> _downloadAllBanners() async {
    try {
      // Initialize Dio for downloads with detailed logging
      final dio = Dio(BaseOptions(
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
      ));

      // Add interceptor for detailed logging
      dio.interceptors.add(InterceptorsWrapper(
        onRequest: (options, handler) {
          return handler.next(options);
        },
        onError: (DioException e, handler) {
          debugPrint('❌ Download Error: ${e.message}');
          debugPrint('❌ Error Details: ${e.toString()}');
          return handler.next(e);
        },
      ));

      // Get the application documents directory
      final Directory appDocDir = await getApplicationDocumentsDirectory();
      final largeBannnerStorage =
          Directory('${appDocDir.path}/POS/largeBanner/');
      final smallBannnerStorage =
          Directory('${appDocDir.path}/POS/smallBanner/');

      // Create banners directory if it doesn't exist
      if (!await largeBannnerStorage.exists()) {
        await largeBannnerStorage.create(recursive: true);
      } else {
        final List<FileSystemEntity> files =
            await largeBannnerStorage.list().toList();
        for (var file in files) {
          if (file is File) {
            await file.delete();
          }
        }
      }

      if (!await smallBannnerStorage.exists()) {
        await smallBannnerStorage.create(recursive: true);
      } else {
        final List<FileSystemEntity> files =
            await smallBannnerStorage.list().toList();
        for (var file in files) {
          if (file is File) {
            await file.delete();
          }
        }
      }

      // Download and categorize banners
      final List<DualScreenModel> downloadedLargeBanners = [];
      final List<DualScreenModel> downloadedSmallBanners = [];

      // Download large banners
      for (var banner in largeBannersUrl) {
        if (banner.path.isNotEmpty) {
          try {
            // Generate a more readable filename using banner ID or order'
            String filename;
            if (_isVideoFile(banner.path)) {
              filename =
                  'large_banner_${DateTime.now().millisecondsSinceEpoch}_${banner.id ?? banner.order}.mp4';
            } else {
              filename =
                  'large_banner_${DateTime.now().millisecondsSinceEpoch}_${banner.id ?? banner.order}.jpg';
            }

            final File localFile =
                File('${largeBannnerStorage.path}/$filename');

            // Clean up old file if it exists
            if (await localFile.exists()) {
              await localFile.delete();
            }

            // Download with Dio
            await dio.download(
              banner.path,
              localFile.path,
              options: Options(
                receiveTimeout: const Duration(seconds: 30),
                sendTimeout: const Duration(seconds: 30),
              ),
              onReceiveProgress: (received, total) {
                if (total != -1) {
                  final progress = (received / total * 100).toStringAsFixed(2);
                }
              },
            );

            // Verify file was downloaded successfully
            if (await localFile.exists() && await localFile.length() > 0) {
              // Create a new banner model with local file path
              final downloadedBanner = DualScreenModel(
                id: banner.id,
                description: banner.description,
                type: banner.type,
                order: banner.order,
                path: localFile.path,
                duration: banner.duration,
                createdAt: banner.createdAt,
                updatedAt: DateTime.now(),
              );

              downloadedLargeBanners.add(downloadedBanner);
            } else {
              debugPrint('❌ Failed to download large banner: ${banner.path}');
            }
          } catch (e) {
            debugPrint('❌ Error downloading large banner ${banner.path}: $e');
          }
        }
      }

      // Download small banners
      for (var banner in smallBannersUrl) {
        if (banner.path.isNotEmpty) {
          try {
            // Generate a unique filename
            String filename;
            if (_isVideoFile(banner.path)) {
              filename =
                  'small_banner_${DateTime.now().millisecondsSinceEpoch}_${banner.id ?? banner.order}.mp4';
            } else {
              filename =
                  'small_banner_${DateTime.now().millisecondsSinceEpoch}_${banner.id ?? banner.order}.jpg';
            }

            final File localFile =
                File('${smallBannnerStorage.path}/$filename');

            // Download with Dio
            await dio.download(
              banner.path,
              localFile.path,
              options: Options(
                receiveTimeout: const Duration(seconds: 30),
                sendTimeout: const Duration(seconds: 30),
              ),
              onReceiveProgress: (received, total) {
                if (total != -1) {
                  final progress = (received / total * 100).toStringAsFixed(2);
                }
              },
            );

            // Verify file was downloaded successfully
            if (await localFile.exists() && await localFile.length() > 0) {
              // Create a new banner model with local file path
              final downloadedBanner = DualScreenModel(
                id: banner.id,
                description: banner.description,
                type: banner.type,
                order: banner.order,
                path: localFile.path,
                duration: banner.duration,
                createdAt: banner.createdAt,
                updatedAt: DateTime.now(),
              );

              downloadedSmallBanners.add(downloadedBanner);
            } else {
              debugPrint('❌ Failed to download small banner: ${banner.path}');
            }
          } catch (e) {
            debugPrint('❌ Error downloading small banner ${banner.path}: $e');
          }
        }
      }

      // Update state with downloaded banners
      setState(() {
        downloadedLargeBanners
          ..addAll(largeBannersLocal)
          ..sort((a, b) => a.order.compareTo(b.order));
        downloadedSmallBanners
          ..addAll(smallBannersLocal)
          ..sort((a, b) => a.order.compareTo(b.order));
        this.largeBanners = downloadedLargeBanners;
        this.smallBanners = downloadedSmallBanners;
      });
      _startTimers();
    } catch (e) {
      debugPrint('❌ Critical Error in _downloadAllBanners: $e');
    }
  }

  // Helper method to extract file extension
  String _getFileExtension(String url) {
    final uri = Uri.parse(url);
    final path = uri.path;
    return path.split('.').last;
  }

  // Helper method to check if a file is an image
  bool _isImageFile(String path) {
    final imageExtensions = ['.jpg', '.jpeg', '.png', '.gif', '.bmp', '.webp'];
    return imageExtensions.any((ext) => path.toLowerCase().endsWith(ext));
  }

  // Helper method to check if a file is a video
  bool _isVideoFile(String path) {
    final videoExtensions = ['.mp4', '.avi', '.mov', '.mkv', '.wmv'];
    return videoExtensions.any((ext) => path.toLowerCase().endsWith(ext));
  }

  // Helper method to safely get string value
  String _getSafeStringValue(Map<String, dynamic> data, String key) {
    return data[key] != null ? data[key].toString() : '-';
  }

  // Validate if file exists and is downloadable
  bool _isValidMediaFile(String path) {
    if (path.isEmpty) return false;

    final file = File(path);
    bool exists = file.existsSync();
    bool isReadable = exists && file.statSync().size > 0;
    return isReadable;
  }

  void _startTimers() {
    // Cancel existing timers if they exist
    _timer1?.cancel();
    _timer2?.cancel();
    if (largeBanners.isNotEmpty) {
      // Only start timer if current banner is not a video
      if (!_isVideoFile(largeBanners[_currentIndex].path)) {
        _timer1 = Timer.periodic(
            Duration(seconds: largeBanners[_currentIndex].duration), (timer) {
          if (!mounted) return;
          _moveToNextItem();
        });
      }
    }

    if (smallBanners.isNotEmpty) {
      // Only start timer if current banner is not a video
      if (!_isVideoFile(smallBanners[_currentIndex2].path)) {
        _timer2 = Timer.periodic(
            Duration(seconds: smallBanners[_currentIndex2].duration), (timer) {
          if (!mounted) return;
          _moveToNextItem2();
        });
      }
    }
  }

  void _moveToNextItem() {
    if (!mounted || largeBanners.isEmpty) return;
    setState(() {
      _currentIndex = (_currentIndex + 1) % largeBanners.length;
    });
  }

  void _moveToNextItem2() {
    if (!mounted || smallBanners.isEmpty) return;
    setState(() {
      _currentIndex2 = (_currentIndex2 + 1) % smallBanners.length;
    });
  }

  Future<void> _initializeVideoController(String path, bool isLarge) async {
    try {
      final pathNormalized = path.replaceAll('\\', '\\\\');
      final controller = VideoPlayerController.file(File(pathNormalized));
      if (isLarge) {
        if (_videoControllerLarge != null) {
          await _videoControllerLarge!.dispose();
        }
        _videoControllerLarge = controller;
      } else {
        if (_videoControllerSmall != null) {
          await _videoControllerSmall!.dispose();
        }
        _videoControllerSmall = controller;
      }

      await controller.initialize();
      controller.play();

      // Add video completion listener
      controller.addListener(() {
        if (controller.value.position >= controller.value.duration) {
          if (isLarge) {
            _timer1?.cancel(); // Cancel the timer for large banner
            _moveToNextItem();
          } else {
            _timer2?.cancel(); // Cancel the timer for small banner
            _moveToNextItem2();
          }
        }
      });

      setState(() {
        if (isLarge) {
          _isLargeVideoInitialized = true;
        } else {
          _isSmallVideoInitialized = true;
        }
      });
    } catch (e) {
      log("Error initializing video controller: $e");
      if (isLarge) {
        _isLargeVideoInitialized = false;
        _timer1?.cancel();
        // Move to next large banner
        setState(() {
          _currentIndex = (_currentIndex + 1) % largeBanners.length;
        });
      } else {
        _isSmallVideoInitialized = false;
        _timer2?.cancel();
        // Move to next small banner
        setState(() {
          _currentIndex2 = (_currentIndex2 + 1) % smallBanners.length;
        });
      }
    }
  }

  Future<Widget> _buildLargeBannerMedia(DualScreenModel banner) async {
    if (_isVideoFile(banner.path)) {
      await _initializeVideoController(banner.path, true);

      if (_isLargeVideoInitialized && _videoControllerLarge != null) {
        return AspectRatio(
          aspectRatio: _videoControllerLarge!.value.aspectRatio,
          child: VideoPlayer(_videoControllerLarge!),
        );
      } else {
        // Move to next banner if video failed to initialize
        _moveToNextItem();
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
    } else {
      return Image.file(
        File(banner.path),
        fit: BoxFit.cover,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
      );
    }
  }

  Widget _buildSmallBannerMedia(DualScreenModel banner) {
    if (_isVideoFile(banner.path)) {
      // Initialize video if not already done
      if (!_isSmallVideoInitialized) {
        _initializeVideoController(banner.path, false);
      }

      if (_isSmallVideoInitialized && _videoControllerSmall != null) {
        return AspectRatio(
          aspectRatio: _videoControllerSmall!.value.aspectRatio,
          child: VideoPlayer(_videoControllerSmall!),
        );
      } else {
        // Move to next banner if video failed to initialize
        _moveToNextItem2();
        return const Center(child: CircularProgressIndicator());
      }
    } else {
      return Image.file(
        File(banner.path),
        fit: BoxFit.fill,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
      );
    }
  }

  @override
  void dispose() {
    _timer1?.cancel();
    _timer2?.cancel();

    if (_videoControllerLarge != null) {
      _videoControllerLarge!.dispose();
      _videoControllerLarge = null;
      _isLargeVideoInitialized = false;
    }

    if (_videoControllerSmall != null) {
      _videoControllerSmall!.dispose();
      _videoControllerSmall = null;
      _isSmallVideoInitialized = false;
    }

    localVideoPaths.forEach((path, filePath) {
      final file = File(filePath);
      if (file.existsSync()) {
        file.deleteSync();
      }
    });

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cashier = _prefs?.getString('username');
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Row(
            children: [
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 20, bottom: 40, right: 12),
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
                                  dataMap['cashRegisterId'] ??
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
                              Text(
                                dataMap['storeName'] ?? '',
                                style: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                dataMap['cashierName'] ?? '',
                                style: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
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
                              padding:
                                  const EdgeInsets.only(top: 8.0, right: 8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 1,
                                      color: Colors.grey,
                                    ),
                                    borderRadius: BorderRadius.circular(8)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      decoration: const BoxDecoration(
                                          color: ProjectColors.primary,
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(8),
                                              topRight: Radius.circular(8))),
                                      child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text('Customer',
                                                style: TextStyle(
                                                    color: Colors.white)),
                                            Text(
                                                _getSafeStringValue(
                                                    currentSalesData,
                                                    'customerName'),
                                                style: const TextStyle(
                                                    color: Colors.white)),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text('Total Discount'),
                                              Text(
                                                  'Rp ${_getSafeStringValue(currentSalesData, 'totalDiscount')}'),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text('Grand Total'),
                                              Text(
                                                  'Rp ${_getSafeStringValue(currentSalesData, 'grandTotal')}'),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('Total Payment'),
                                              Text(
                                                  'Rp ${_getSafeStringValue(currentSalesData, 'totalPayment')}'),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('Changed'),
                                              Text(
                                                  'Rp ${_getSafeStringValue(currentSalesData, 'changed')}'),
                                            ],
                                          ),
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
                                  color: currentSalesData['items'] != null &&
                                          currentSalesData['items'].length > 0
                                      ? Colors.green
                                          .shade700 // Darker green when items added
                                      : Colors.green,
                                ),
                                padding: const EdgeInsets.all(25.0),
                                child: LayoutBuilder(
                                  builder: (context, constraints) {
                                    final fontSize = constraints.maxWidth > 800
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
                                          'IDR ${_getSafeStringValue(currentSalesData, 'grandTotal')}',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: fontSize),
                                        ),
                                        if (currentSalesData['items'] != null &&
                                            currentSalesData['items'].length >
                                                0)
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 8.0),
                                            child: Text(
                                              'Items: ${currentSalesData['items'].length}',
                                              style: TextStyle(
                                                color: Colors.white70,
                                                fontSize: fontSize * 0.5,
                                              ),
                                            ),
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
              // Right side: Images with fixed width
              Container(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height * 0.5,
                  minWidth: MediaQuery.of(context).size.width * 0.5,
                  maxHeight: MediaQuery.of(context).size.height * 1,
                  maxWidth: MediaQuery.of(context).size.width * 0.6,
                ),
                width: 1264, // Fixed width for the right side
                child: Column(
                  children: [
                    Expanded(
                      flex: 7,
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 1000),
                        transitionBuilder:
                            (Widget child, Animation<double> animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                        child: FutureBuilder<Widget>(
                          future: largeBanners.isNotEmpty
                              ? _buildLargeBannerMedia(
                                  largeBanners[_currentIndex],
                                )
                              : Future.value(const Center(
                                  child: CircularProgressIndicator(),
                                )),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return snapshot.data!;
                            }
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      flex: 3,
                      child: CarouselSlider(
                        options: CarouselOptions(
                          height: double.infinity,
                          viewportFraction: 1.0,
                          autoPlay: true,
                          autoPlayInterval: const Duration(seconds: 3),
                          autoPlayAnimationDuration:
                              const Duration(milliseconds: 800),
                          autoPlayCurve: Curves.fastOutSlowIn,
                          pauseAutoPlayOnTouch: true,
                        ),
                        items: smallBanners
                            .map((banner) => _buildSmallBannerMedia(banner))
                            .toList(),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
