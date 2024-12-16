import 'dart:convert';
import 'dart:math' show max;

import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/core/utilities/snack_bar_helper.dart';
import 'package:pos_fe/features/dual_screen/data/models/dual_screen.dart';
import 'package:pos_fe/features/dual_screen/data/models/send_data.dart';
import 'package:pos_fe/features/dual_screen/services/create_window_service.dart';
import 'package:pos_fe/features/dual_screen/services/send_data_window_service.dart';
import 'package:pos_fe/features/login/presentation/pages/keyboard_widget.dart';
import 'package:pos_fe/features/sales/data/models/pos_parameter.dart';
import 'package:pos_fe/features/sales/domain/entities/pos_parameter.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_pos_parameter.dart';
import 'package:pos_fe/features/sales/presentation/widgets/confirmation_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomerDisplay extends StatefulWidget {
  const CustomerDisplay({super.key});

  @override
  State<CustomerDisplay> createState() => _CustomerDisplayState();
}

class _CustomerDisplayState extends State<CustomerDisplay> {
  List<DualScreenModel> largeBanners = [];
  List<DualScreenModel> smallBanners = [];
  bool isLoading = true;
  String dropdownValue = 'Yes';
  POSParameterModel? _posParameter;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final posParam = await GetIt.instance<AppDatabase>().posParameterDao.readAll();
      setState(() {
        _posParameter = posParam[0];
        dropdownValue = posParam[0].customerDisplayActive == 1 ? 'Yes' : 'No';
        isLoading = false;
      });
      await loadBanners();
    } catch (e) {
      if (mounted) {
        SnackBarHelper.presentErrorSnackBar(context, 'Failed to load POS parameters');
      }
    }
  }

  Future<void> loadBanners() async {
    try {
      setState(() => isLoading = true);

      // Get all banners from database
      final allBanners = await GetIt.instance<AppDatabase>().dualScreenDao.readAll();

      setState(() {
        // Split banners by type (1 for large, 2 for small)
        largeBanners = allBanners.where((banner) => banner.type == 1).toList()
          ..sort((a, b) => a.order.compareTo(b.order));
        smallBanners = allBanners.where((banner) => banner.type == 2).toList()
          ..sort((a, b) => a.order.compareTo(b.order));
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      if (mounted) {
        SnackBarHelper.presentErrorSnackBar(context, 'Error loading banners: ${e.toString()}');
      }
    }
  }

  Future<void> refreshBanners() async {
    await loadBanners();
  }

  // Future<void> saveChanges(Map<String, dynamic> data) async {
  //   try {
  //     setState(() => isLoading = true);
  //     final now = DateTime.now();
  //     List<DualScreenModel> allBanners = await GetIt.instance<AppDatabase>().dualScreenDao.readAll();
  //     final newId = DateTime.now().millisecondsSinceEpoch * -1;
  //     DualScreenModel newBanner = DualScreenModel(
  //       id: newId,
  //       description: data['description'] as String,
  //       type: data['type'] as int,
  //       order: data['order'] as int,
  //       path: data['path'] as String,
  //       duration: data['duration'] as int,
  //       createdAt: now,
  //       updatedAt: now,
  //     );
  //     setState(() {
  //       allBanners.add(newBanner);
  //     });
  //     print(allBanners);
  //     final lastId = allBanners.isEmpty ? 0 : allBanners.map((e) => e.id).reduce(max);
  //     final lastLargeOrder = allBanners.where((b) => b.type == 1).fold(0, (max, b) => b.order > max ? b.order : max);
  //     final lastSmallOrder = allBanners.where((b) => b.type == 2).fold(0, (max, b) => b.order > max ? b.order : max);
  //     var currentId = lastId;
  //     var currentLargeOrder = lastLargeOrder;
  //     var currentSmallOrder = lastSmallOrder;
  //     for (final banner in allBanners) {
  //       // Check if banner already exists in database
  //       final existingBanner = allBanners.firstWhere(
  //         (b) => b.id == banner.id,
  //         orElse: () => DualScreenModel(
  //           id: 0,
  //           description: '',
  //           type: 0,
  //           order: 0,
  //           path: '',
  //           duration: 0,
  //           createdAt: DateTime.now(),
  //           updatedAt: DateTime.now(),
  //         ),
  //       );

  //       if (existingBanner.id == 0) {
  //         currentId++;
  //         final order = banner.type == 1 ? ++currentLargeOrder : ++currentSmallOrder;

  //         final bannerToSave = DualScreenModel(
  //           id: currentId,
  //           description: banner.description,
  //           type: banner.type,
  //           order: order,
  //           path: banner.path,
  //           duration: banner.duration,
  //           createdAt: banner.createdAt,
  //           updatedAt: banner.updatedAt,
  //         );
  //         await GetIt.instance<AppDatabase>().dualScreenDao.create(data: bannerToSave);
  //       } else {
  //         // Update existing banner
  //         final updatedBanner = DualScreenModel(
  //           id: existingBanner.id,
  //           description: banner.description,
  //           type: banner.type,
  //           order: existingBanner.order,
  //           path: banner.path,
  //           duration: banner.duration,
  //           createdAt: existingBanner.createdAt,
  //           updatedAt: DateTime.now(),
  //         );
  //         await GetIt.instance<AppDatabase>()
  //             .dualScreenDao
  //             .updateById(id: existingBanner.id.toString(), data: updatedBanner);
  //       }
  //     }
  //     await _updateCustomerDisplayActive();
  //     await _updateCustomerDisplay();
  //     await refreshBanners();

  //     if (dropdownValue.toLowerCase() == 'yes') {
  //       await _sendToDisplay();
  //     }
  //     if (mounted) {
  //       SnackBarHelper.presentSuccessSnackBar(context, 'All changes saved successfully', 3);
  //     }
  //   } catch (e) {
  //     setState(() => isLoading = false);
  //     if (mounted) {
  //       SnackBarHelper.presentErrorSnackBar(context, 'Error saving changes: ${e.toString()}');
  //     }
  //   }
  // }

  Future<void> saveChanges(Map<String, dynamic> data) async {
    try {
      setState(() => isLoading = true);
      final now = DateTime.now();

      // Check if the banner already exists
      final existingBannerId = data['id'] as int?; // Assuming the ID is passed in the data
      DualScreenModel? existingBanner;

      if (existingBannerId != null) {
        // Fetch the existing banner from the database
        existingBanner = await GetIt.instance<AppDatabase>().dualScreenDao.findById(existingBannerId);
      }
      final allBanners = await GetIt.instance<AppDatabase>().dualScreenDao.readAll();
      final lastId = allBanners.isEmpty ? 0 : allBanners.map((e) => e.id).reduce(max);
      var currentId = lastId;

      if (existingBanner == null) {
        currentId++;
        DualScreenModel newBanner = DualScreenModel(
          id: currentId, // Unique negative ID for unsaved banners
          description: data['description'] as String,
          type: data['type'] as int,
          order: data['order'] as int,
          path: data['path'] as String,
          duration: data['duration'] as int,
          createdAt: now,
          updatedAt: now,
        );

        // Save the new banner to the database
        await GetIt.instance<AppDatabase>().dualScreenDao.create(data: newBanner);

        if (mounted) {
          SnackBarHelper.presentSuccessSnackBar(context, 'Banner added successfully', 3);
        }
      } else {
        // Update existing banner
        final updatedBanner = DualScreenModel(
          id: existingBanner.id,
          description: data['description'] as String,
          type: data['type'] as int,
          order: data['order'] as int,
          path: data['path'] as String,
          duration: data['duration'] as int,
          createdAt: existingBanner.createdAt,
          updatedAt: now, // Update the timestamp
        );

        await GetIt.instance<AppDatabase>()
            .dualScreenDao
            .updateById(id: existingBanner.id.toString(), data: updatedBanner);

        if (mounted) {
          SnackBarHelper.presentSuccessSnackBar(context, 'Banner updated successfully', 3);
        }
      }

      // Optionally refresh the banners list if needed
      await refreshBanners();

      // Additional logic if needed
      print(dropdownValue.toLowerCase());

      if (dropdownValue.toLowerCase() == 'yes') {
        await _sendToDisplay();
        print("masuk");
      }
    } catch (e) {
      setState(() => isLoading = false);
      if (mounted) {
        SnackBarHelper.presentErrorSnackBar(context, 'Error saving changes: ${e.toString()}');
      }
    } finally {
      setState(() => isLoading = false); // Ensure loading state is reset
    }
  }

  Future<void> _sendToDisplay() async {
    try {
      if (await GetIt.instance<GetPosParameterUseCase>().call() != null &&
          (await GetIt.instance<GetPosParameterUseCase>().call())!.customerDisplayActive == 0) {
        return;
      }
      final windows = await DesktopMultiWindow.getAllSubWindowIds();
      if (windows.isEmpty) {
        return;
      }
      final windowId = windows[0];
      final data = await GetIt.instance<AppDatabase>().dualScreenDao.readAll();
      final jsonData = jsonEncode(data);
      final sendingData = await sendData(windowId, jsonData, 'updateBannerData', 'checkout');
    } catch (e, stackTrace) {
      debugPrint('Error sending data to display: $e');
      debugPrint(stackTrace.toString());
      return;
    }
  }

  void onDropdownChanged(String? newValue) async {
    if (newValue != null) {
      setState(() {
        dropdownValue = newValue;
      });
      await _updateCustomerDisplayActive();
    }
  }

  Future<void> _updateCustomerDisplayActive() async {
    if (_posParameter == null) {
      SnackBarHelper.presentErrorSnackBar(context, 'POS parameters not loaded');
      return;
    }

    // Convert dropdown value to integer (1 for Yes, 0 for No)
    int dbValue = dropdownValue.toLowerCase() == 'yes' ? 1 : 0;

    final pos = POSParameterModel(
      docId: _posParameter!.docId,
      createDate: _posParameter!.createDate?.toLocal(),
      updateDate: _posParameter!.updateDate?.toLocal(),
      gtentId: _posParameter!.gtentId,
      tostrId: _posParameter!.tostrId,
      storeName: _posParameter!.storeName,
      tocsrId: _posParameter!.tocsrId,
      baseUrl: _posParameter!.baseUrl,
      usernameAdmin: _posParameter!.usernameAdmin,
      passwordAdmin: _posParameter!.passwordAdmin,
      lastSync: _posParameter!.lastSync,
      defaultShowKeyboard: _posParameter!.defaultShowKeyboard,
      customerDisplayActive: dbValue,
    );

    try {
      await GetIt.instance<AppDatabase>().posParameterDao.update(docId: _posParameter!.docId, data: pos);

      // Show success message
      if (mounted) {
        SnackBarHelper.presentSuccessSnackBar(context, 'Customer display setting updated successfully', 3);
        await _updateCustomerDisplay();
      }
    } catch (e) {
      // Show error message
      if (mounted) {
        SnackBarHelper.presentErrorSnackBar(context, 'Failed to update customer display setting');
      }
    }
  }

  Future<void> _updateCustomerDisplay() async {
    if (_posParameter == null) {
      SnackBarHelper.presentErrorSnackBar(context, 'POS parameters not loaded');
      return;
    }
    if (dropdownValue.toLowerCase() == 'yes') {
      SharedPreferences? prefs = await SharedPreferences.getInstance();
      try {
        await DesktopMultiWindow.getAllSubWindowIds();
        await prefs.setBool("isCustomerDisplayActive", true);
      } catch (e) {
        await prefs.setBool("isCustomerDisplayActive", false);
      }
      if (prefs.getBool("isCustomerDisplayActive") == false) {
        final cashier = await GetIt.instance<AppDatabase>().cashRegisterDao.readByDocId(
              _posParameter!.tocsrId!,
              null,
            );
        final store = await GetIt.instance<AppDatabase>().storeMasterDao.readByDocId(
              _posParameter!.tostrId!,
              null,
            );
        final allBanners = await GetIt.instance<AppDatabase>().dualScreenDao.readAll();
        SendBaseData dataWindow = SendBaseData(
            cashierName: prefs.getString('username').toString(),
            cashRegisterId: cashier!.idKassa,
            storeName: store!.storeName,
            windowId: 1,
            dualScreenModel: allBanners);
        initWindow(mounted, dataWindow);
      }
    } else {
      try {
        final windows = await DesktopMultiWindow.getAllSubWindowIds();
        SharedPreferences? prefs = await SharedPreferences.getInstance();

        await Future.forEach(windows, (windowId) async {
          final controller = WindowController.fromWindowId(windowId);

          await controller.close();
          await prefs.setBool("isCustomerDisplayActive", false);
        });
      } catch (e) {
        debugPrint('Error Closing Window: $e');
      }
    }
  }

  Widget buildBannerTable(String title, List<DualScreenModel> banners) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => BannerPopup(
                    title: 'Add $title',
                    type: title.toLowerCase().contains('large') ? 1 : 2,
                    order: banners.isEmpty ? 1 : banners.last.order + 1,
                    onSave: saveChanges,
                  ),
                );
              },
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text('Add', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: ProjectColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (isLoading)
          const Center(child: CircularProgressIndicator())
        else
          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color.fromARGB(255, 222, 220, 220),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Theme(
                  data: Theme.of(context).copyWith(
                    dividerTheme: DividerThemeData(
                      color: const Color.fromARGB(255, 222, 220, 220),
                      thickness: 1.0,
                    ),
                  ),
                  child: DataTable(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    headingRowHeight: 40,
                    headingTextStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                    headingRowColor: MaterialStateProperty.all(ProjectColors.primary),
                    dataRowColor: MaterialStateProperty.all(const Color.fromARGB(255, 240, 240, 240)),
                    columns: [
                      DataColumn(
                        label: Center(
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.03,
                            child: const Text(
                              'Order',
                              style: TextStyle(color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Center(
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.15,
                            child: const Text(
                              'Description',
                              style: TextStyle(color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Center(
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.28,
                            child: const Text(
                              'Path',
                              style: TextStyle(color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Center(
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.07,
                            child: const Text(
                              'Duration (s)',
                              style: TextStyle(color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Center(
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.15,
                            child: const Text(
                              'Actions',
                              style: TextStyle(color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ],
                    rows: banners.map((banner) {
                      return DataRow(
                        cells: [
                          DataCell(SizedBox(
                              width: MediaQuery.of(context).size.width * 0.03,
                              child: Center(child: Text(banner.order.toString())))),
                          DataCell(SizedBox(
                              width: MediaQuery.of(context).size.width * 0.15,
                              child: Center(child: Text(banner.description)))),
                          DataCell(SizedBox(
                              width: MediaQuery.of(context).size.width * 0.28,
                              child: Center(
                                child: Text(
                                  banner.path.length > 40
                                      ? '...${banner.path.substring(banner.path.length - 40)}'
                                      : banner.path,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ))),
                          DataCell(SizedBox(
                              width: MediaQuery.of(context).size.width * 0.07,
                              child: Center(child: Text(banner.duration.toString())))),
                          DataCell(
                            Center(
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.13,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) => BannerPopup(
                                            title: 'Edit Banner',
                                            type: banner.type,
                                            order: banner.order,
                                            description: banner.description,
                                            path: banner.path,
                                            duration: banner.duration.toString(),
                                            onSave: (updatedData) async {
                                              // Find the index of the banner in the appropriate list
                                              final List<DualScreenModel> targetList =
                                                  banner.type == 1 ? largeBanners : smallBanners;

                                              final index = targetList.indexWhere((b) => b.id == banner.id);

                                              if (index != -1) {
                                                // Create an updated banner model
                                                final updatedBanner = <String, dynamic>{
                                                  'id': banner.id,
                                                  'description': updatedData['description'],
                                                  'type': banner.type,
                                                  'order': banner.order,
                                                  'path': updatedData['path'],
                                                  'duration': updatedData['duration'],
                                                  'createdAt': banner.createdAt,
                                                  'updatedAt': DateTime.now(),
                                                };

                                                saveChanges(updatedBanner);

                                                // Show success message
                                                if (mounted) {
                                                  SnackBarHelper.presentSuccessSnackBar(
                                                      context, 'Customer display setting updated successfully', 3);
                                                }
                                              }
                                            },
                                          ),
                                        );
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () async {
                                        final confirm = await showDialog<bool>(
                                          context: context,
                                          builder: (context) => const ConfirmationDialog(
                                            primaryMsg: "Are you sure you want to delete this banner?",
                                            secondaryMsg: "",
                                            isProceedOnly: false,
                                          ),
                                        );

                                        if (confirm == true) {
                                          await GetIt.instance<AppDatabase>().dualScreenDao.delete(banner.id);
                                          await refreshBanners();
                                          await _sendToDisplay();
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 234, 234, 234),
      appBar: AppBar(
        backgroundColor: ProjectColors.primary,
        foregroundColor: Colors.white,
        title: const Text("Customer Display"),
      ),
      body: RefreshIndicator(
        onRefresh: refreshBanners,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Center(
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                    color: const Color.fromARGB(255, 240, 240, 240),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: dropdownValue,
                      isExpanded: true,
                      items: <String>['Yes', 'No'].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: onDropdownChanged,
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Column(
                    children: [
                      buildBannerTable('Large Banners', largeBanners),
                      const SizedBox(height: 16),
                      buildBannerTable('Small Banners', smallBanners),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BannerPopup extends StatefulWidget {
  final String title;
  final int? type;
  final int? order;
  final String? description;
  final String? path;
  final String? duration;
  final Future<void> Function(Map<String, dynamic>) onSave;

  const BannerPopup({
    super.key,
    required this.title,
    this.type,
    this.order,
    this.description,
    this.path,
    this.duration,
    required this.onSave,
  });

  @override
  State<BannerPopup> createState() => _BannerPopupState();
}

class _BannerPopupState extends State<BannerPopup> {
  late TextEditingController descriptionController;
  late TextEditingController pathController;
  late TextEditingController durationController;
  final _formKey = GlobalKey<FormState>();

  final FocusNode descriptionFocusNode = FocusNode();
  final FocusNode pathFocusNode = FocusNode();
  final FocusNode durationFocusNode = FocusNode();

  bool _showKeyboard = true;
  final FocusNode _keyboardFocusNode = FocusNode();
  bool currentNumericMode = false;
  TextEditingController _activeController = TextEditingController();
  FocusNode _activeFocusNode = FocusNode();

  @override
  void initState() {
    getDefaultKeyboardPOSParameter();
    super.initState();
    descriptionController = TextEditingController(text: widget.description ?? '');
    pathController = TextEditingController(text: widget.path ?? '');
    durationController = TextEditingController(text: widget.duration ?? '');

    descriptionFocusNode.addListener(() {
      if (descriptionFocusNode.hasFocus) {
        setState(() {
          _activeController = descriptionController;
          currentNumericMode = false;
          _activeFocusNode = descriptionFocusNode;
        });
      }
    });
    pathFocusNode.addListener(() {
      if (pathFocusNode.hasFocus) {
        setState(() {
          _activeController = pathController;
          currentNumericMode = false;
          _activeFocusNode = pathFocusNode;
        });
      }
    });
    durationFocusNode.addListener(() {
      if (durationFocusNode.hasFocus) {
        setState(() {
          _activeController = durationController;
          currentNumericMode = true;
          _activeFocusNode = durationFocusNode;
        });
      }
    });
  }

  @override
  void dispose() {
    descriptionController.dispose();
    pathController.dispose();
    durationController.dispose();
    descriptionFocusNode.dispose();
    pathFocusNode.dispose();
    durationFocusNode.dispose();
    // _activeController.dispose();
    super.dispose();
  }

  Future<void> getDefaultKeyboardPOSParameter() async {
    try {
      final POSParameterEntity? posParameterEntity = await GetIt.instance<GetPosParameterUseCase>().call();
      if (posParameterEntity == null) throw "Failed to retrieve POS Parameter";
      setState(() {
        _showKeyboard = (posParameterEntity.defaultShowKeyboard == 0) ? false : true;
      });
    } catch (e) {
      if (mounted) {
        SnackBarHelper.presentFailSnackBar(context, e.toString());
      }
    }
  }

  bool validateForm() {
    if (descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Description is required')),
      );
      return false;
    }
    if (pathController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an image file')),
      );
      return false;
    }
    if (durationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Duration is required')),
      );
      return false;
    }
    // Validate duration is a valid integer
    try {
      int.parse(durationController.text);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Duration must be a valid integer')),
      );
      return false;
    }
    return true;
  }

  void handleSave() async {
    if (validateForm()) {
      await widget.onSave({
        'description': descriptionController.text,
        'type': widget.type,
        'order': widget.order,
        'path': pathController.text,
        'duration': int.parse(durationController.text),
      });
      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  Future<void> pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'mp4'],
        allowMultiple: false,
      );

      if (result != null) {
        setState(() {
          pathController.text = result.files.single.path ?? '';
        });
      }
    } catch (e) {
      // Handle any errors that occur during file picking
      debugPrint('Error picking file: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      child: Builder(
        builder: (childContext) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.6,
                child: AlertDialog(
                  backgroundColor: Colors.white,
                  surfaceTintColor: Colors.transparent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  title: Container(
                    decoration: const BoxDecoration(
                      color: ProjectColors.primary,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(5.0)),
                    ),
                    padding: const EdgeInsets.fromLTRB(25, 5, 25, 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.title,
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: Colors.white),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: _showKeyboard ? const Color.fromARGB(255, 110, 0, 0) : ProjectColors.primary,
                            borderRadius: const BorderRadius.all(Radius.circular(360)),
                          ),
                          child: IconButton(
                            focusColor: const Color.fromARGB(255, 110, 0, 0),
                            focusNode: _keyboardFocusNode,
                            icon: Icon(
                              _showKeyboard ? Icons.keyboard_hide_outlined : Icons.keyboard_outlined,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              setState(() {
                                _showKeyboard = !_showKeyboard;
                              });
                            },
                            tooltip: 'Toggle Keyboard',
                          ),
                        ),
                      ],
                    ),
                  ),
                  titlePadding: const EdgeInsets.all(0),
                  contentPadding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  content: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Description Field
                          TextFormField(
                            controller: descriptionController,
                            focusNode: descriptionFocusNode,
                            decoration: const InputDecoration(
                              labelText: 'Description',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.none,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Description is required';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),

                          // Path Field with File Picker Icon
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: pathController,
                                  focusNode: pathFocusNode,
                                  decoration: const InputDecoration(
                                    labelText: 'Path',
                                    border: OutlineInputBorder(),
                                  ),
                                  keyboardType: TextInputType.none,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please select an image file';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                onPressed: pickFile,
                                icon: const Icon(Icons.folder, color: Colors.grey),
                                tooltip: 'Pick Image File',
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // Duration Field
                          TextFormField(
                            controller: durationController,
                            focusNode: durationFocusNode,
                            decoration: const InputDecoration(
                              labelText: 'Duration',
                              border: OutlineInputBorder(),
                              suffix: Text(
                                "seconds",
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),
                            ),
                            keyboardType: TextInputType.none,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Duration is required';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          (_showKeyboard)
                              ? SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.3,
                                  child: KeyboardWidget(
                                    controller: _activeController,
                                    isNumericMode: currentNumericMode,
                                    customLayoutKeys: true,
                                    focusNodeAndTextController: FocusNodeAndTextController(
                                      focusNode: _activeFocusNode,
                                      textEditingController: _activeController,
                                    ),
                                  ),
                                )
                              : const SizedBox.shrink(),
                          const SizedBox(height: 10),

                          // Action Buttons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  side: const BorderSide(width: 1, color: ProjectColors.primary),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.19,
                                  child: const Center(
                                    child: Text('Cancel', style: TextStyle(color: ProjectColors.primary)),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              ElevatedButton(
                                onPressed: handleSave,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: ProjectColors.primary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.19,
                                  child: Center(
                                    child: Text(
                                      widget.title.startsWith('Edit') ? 'Save Changes' : 'Add Banner',
                                      style: const TextStyle(color: Colors.white),
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
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
