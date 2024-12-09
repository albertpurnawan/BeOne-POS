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
              dataMap['dualScreenModel'] = data;
              if (data is Map) {
                if (data.containsKey('largeBannersUrl') &&
                    data['largeBannersUrl'] is List &&
                    data['largeBannersUrl'].isNotEmpty) {}
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
        case 'updateCheckoutData':
          try {
            final String jsonString = call.arguments as String;
            final data = jsonDecode(jsonString);
            debugPrint('INI DATA DARI CHECKOUT$data');
            setState(() {
              currentSalesData['grandTotal'] = data['grandTotal'];
              currentSalesData['changed'] = data['changed'];
            });
            return true;
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

  double _getResponsiveFontSize(BuildContext context, {bool isHeader = false}) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Calculate base size based on screen dimensions
    final baseSize =
        (screenWidth * screenHeight) / (1920 * 1080); // normalized to 1080p

    // Scale font size proportionally
    final scaleFactor = isHeader ? 1.2 : 1.0;
    final fontSize = (baseSize * 16 * scaleFactor).clamp(
        isHeader ? 10.0 : 8.0, // minimum size
        isHeader ? 20.0 : 18.0 // maximum size
        );

    return fontSize;
  }

  double _getColumnWidth(BuildContext context, String columnType) {
    final screenWidth = MediaQuery.of(context).size.width;
    print('screenwidth $screenWidth');
    final totalWidth =
        screenWidth * 0.4; // Since container width is 40% of screen

    // Dynamic ratios based on available width
    final Map<String, double> columnRatios = {
      'no': 0.05,
      'name': 0.30,
      'qty': 0.07,
      'discount': 0.17,
      'total': 0.18,
    };

    return totalWidth * (columnRatios[columnType] ?? 0.1);
  }

  double _getHeaderHeight(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    // Make header height responsive but with min/max bounds
    return (screenHeight * 0.06).clamp(40.0, 60.0);
  }

  double _getHeaderPadding(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return (screenHeight * 0.01).clamp(4.0, 12.0);
  }

  Widget _buildTableCell({
    required BuildContext context,
    required String text,
    required bool isHeader,
  }) {
    final fontSize = _getResponsiveFontSize(context, isHeader: isHeader);
    final verticalPadding = isHeader ? _getHeaderPadding(context) : 8.0;

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: verticalPadding,
        horizontal: 4,
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: isHeader ? Colors.white : Colors.black87,
            fontSize: fontSize,
            fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
          ),
          textAlign: TextAlign.center,
          overflow: TextOverflow.visible,
          softWrap: true,
        ),
      ),
    );
  }

  Widget _buildSalesDisplay() {
    // Ensure scroll to bottom whenever data changes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });

    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: Colors.black.withOpacity(0.5),
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        width: double.infinity,
        child: Column(
          children: [
            // Sticky Header
            Container(
              height: _getHeaderHeight(context),
              decoration: BoxDecoration(
                color: ProjectColors.primary,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    flex: 5,
                    child: _buildTableCell(
                      context: context,
                      text: 'No',
                      isHeader: true,
                    ),
                  ),
                  Expanded(
                    flex: 30,
                    child: _buildTableCell(
                      context: context,
                      text: 'Item Name',
                      isHeader: true,
                    ),
                  ),
                  Expanded(
                    flex: 7,
                    child: _buildTableCell(
                      context: context,
                      text: 'Qty',
                      isHeader: true,
                    ),
                  ),
                  Expanded(
                    flex: 17,
                    child: _buildTableCell(
                      context: context,
                      text: 'Discount',
                      isHeader: true,
                    ),
                  ),
                  Expanded(
                    flex: 18,
                    child: _buildTableCell(
                      context: context,
                      text: 'Total',
                      isHeader: true,
                    ),
                  ),
                ],
              ),
            ),
            // List items with auto-scroll
            Expanded(
              child: NotificationListener<ScrollNotification>(
                onNotification: (scrollInfo) {
                  if (scrollInfo is ScrollEndNotification) {
                    // Store the current scroll position
                    final currentPosition = _scrollController.position.pixels;
                    final maxScroll =
                        _scrollController.position.maxScrollExtent;
                    // If we're near the bottom, keep scrolling to bottom for new items
                    if (currentPosition >= maxScroll - 50) {
                      _scrollToBottom();
                    }
                  }
                  return true;
                },
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    children: [
                      if (currentSalesData['items'] != null)
                        ...List.generate(
                          currentSalesData['items']!.length,
                          (index) {
                            final item = currentSalesData['items']![index];
                            return Container(
                              constraints: BoxConstraints(
                                minHeight: 40,
                              ),
                              decoration: BoxDecoration(
                                color: index % 2 == 0
                                    ? Colors.white
                                    : Colors.grey.shade50,
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.grey.shade300,
                                    width: 1,
                                  ),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 5,
                                    child: _buildTableCell(
                                      context: context,
                                      text: '${index + 1}',
                                      isHeader: false,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 30,
                                    child: _buildTableCell(
                                      context: context,
                                      text: '${item['name']}',
                                      isHeader: false,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 7,
                                    child: _buildTableCell(
                                      context: context,
                                      text: '${item['quantity']}',
                                      isHeader: false,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 17,
                                    child: _buildTableCell(
                                      context: context,
                                      text: '${item['discount'] ?? '-'}',
                                      isHeader: false,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 18,
                                    child: _buildTableCell(
                                      context: context,
                                      text: Helpers.parseMoney(item['total']),
                                      isHeader: false,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
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

  Widget _buildInfoRow(String label, String value, double fontSize) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: fontSize,
              color: Colors.black87,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerSection(
      BuildContext context, Map<String, dynamic> data) {
    return Expanded(
      flex: 2,
      child: Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).size.height * 0.01,
          right: MediaQuery.of(context).size.width * 0.01,
        ),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              width: 0.5,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              print('constrains $constraints');
              final baseSize =
                  (constraints.maxWidth * constraints.maxHeight) / (800 * 600);
              final fontSize = (baseSize * 14).clamp(10.0, 16.0);
              final headerFontSize = (fontSize * 1.2).clamp(12.0, 18.0);
              final padding = (baseSize * 12).clamp(6.0, 10.0);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: ProjectColors.primary,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                      ),
                    ),
                    padding: EdgeInsets.all(padding),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Customer',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: headerFontSize,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          _getSafeStringValue(data, 'customerName'),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: headerFontSize,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(padding),
                    child: Column(
                      children: [
                        _buildInfoRow(
                          'Total Discount',
                          'Rp ${_getSafeStringValue(data, 'totalDiscount')}',
                          fontSize,
                        ),
                        _buildInfoRow(
                          'Grand Total',
                          'Rp ${_getSafeStringValue(data, 'grandTotal')}',
                          fontSize,
                        ),
                        SizedBox(height: padding),
                        _buildInfoRow(
                          'Total Payment',
                          'Rp ${_getSafeStringValue(data, 'totalPayment')}',
                          fontSize,
                        ),
                        _buildInfoRow(
                          'Changed',
                          'Rp ${_getSafeStringValue(data, 'changed')}',
                          fontSize,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildGrandTotalSection(
      BuildContext context, Map<String, dynamic> data) {
    final hasItems = data['items'] != null && data['items'].length > 0;

    return Expanded(
      flex: 2,
      child: Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).size.height * 0.01,
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: hasItems ? Colors.green.shade700 : Colors.green,
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final baseSize =
                  (constraints.maxWidth * constraints.maxHeight) / (800 * 600);
              final fontSize = (baseSize * 20).clamp(14.0, 24.0);
              final padding = (baseSize * 16).clamp(8.0, 42.0);

              return Padding(
                padding: EdgeInsets.all(padding),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Grand Total',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: fontSize * 0.8,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: padding * 0.5),
                    Text(
                      'IDR ${_getSafeStringValue(data, 'grandTotal')}',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: fontSize * 0.8,
                      ),
                    ),
                    SizedBox(height: padding * 0.5),
                    Text(
                      'Items: ${data['items'] != null ? data['items'].length : 0}',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: fontSize * 0.6,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
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
                padding: const EdgeInsets.only(left: 20, bottom: 40, right: 12),
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
                                dataMap['cashRegisterId'] ?? 'Unknown Register',
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
                        _buildCustomerSection(context, currentSalesData),
                        _buildGrandTotalSection(context, currentSalesData),
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
      ),
    );
  }
}
