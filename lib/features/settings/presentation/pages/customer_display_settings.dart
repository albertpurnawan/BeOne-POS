import 'dart:convert';
import 'dart:math' show max;
import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/core/utilities/snack_bar_helper.dart';
import 'package:pos_fe/features/dual_screen/data/models/dual_screen.dart';
import 'package:file_picker/file_picker.dart';
import 'package:pos_fe/features/dual_screen/services/send_data_window_service.dart';
import 'package:pos_fe/features/sales/data/models/pos_parameter.dart';
import 'package:pos_fe/features/sales/presentation/widgets/confirmation_dialog.dart';

class CustomerDisplay extends StatefulWidget {
  const CustomerDisplay({super.key});

  @override
  State<CustomerDisplay> createState() => _CustomerDisplayState();
}

class _CustomerDisplayState extends State<CustomerDisplay> {
  List<DualScreenModel> largeBanners = [];
  List<DualScreenModel> smallBanners = [];
  List<DualScreenModel> unsavedBanners = [];
  bool isLoading = true;
  bool _hasUnsavedChanges = false;
  String dropdownValue = 'Yes';
  POSParameterModel? _posParameter;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final posParam =
          await GetIt.instance<AppDatabase>().posParameterDao.readAll();
      setState(() {
        _posParameter = posParam[0];
        dropdownValue = posParam[0].customerDisplayActive == 1 ? 'Yes' : 'No';
        isLoading = false;
      });
      await loadBanners();
    } catch (e) {
      if (mounted) {
        SnackBarHelper.presentErrorSnackBar(
            context, 'Failed to load POS parameters');
      }
    }
  }

  Future<void> loadBanners() async {
    try {
      setState(() => isLoading = true);

      // Get all banners from database
      final allBanners =
          await GetIt.instance<AppDatabase>().dualScreenDao.readAll();
      print('All banners: $allBanners');

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
        SnackBarHelper.presentErrorSnackBar(
            context, 'Error loading banners: ${e.toString()}');
      }
    }
  }

  Future<void> refreshBanners() async {
    await loadBanners();
  }

  Future<void> addUnsavedBanner(Map<String, dynamic> data) async {
    try {
      final now = DateTime.now();
      final model = DualScreenModel(
        id: DateTime.now().millisecondsSinceEpoch *
            -1, // Unique negative ID for unsaved banners
        description: data['description'] as String,
        type: data['type'] as int,
        order: data['order'] as int,
        path: data['path'] as String,
        duration: data['duration'] as int,
        createdAt: now,
        updatedAt: now,
      );

      setState(() {
        unsavedBanners.add(model);
        if (model.type == 1) {
          largeBanners = [...largeBanners, model]
            ..sort((a, b) => a.order.compareTo(b.order));
        } else {
          smallBanners = [...smallBanners, model]
            ..sort((a, b) => a.order.compareTo(b.order));
        }
        _hasUnsavedChanges = true;
      });

      if (mounted) {
        SnackBarHelper.presentSuccessSnackBar(
            context, 'Banner added. Click Save to persist changes.', 3);
      }
    } catch (e) {
      if (mounted) {
        SnackBarHelper.presentErrorSnackBar(
            context, 'Error adding banner: ${e.toString()}');
      }
    }
  }

  Future<void> saveChanges() async {
    if (!_hasUnsavedChanges) return;

    try {
      setState(() => isLoading = true);

      // If no unsaved banners, use all large and small banners
      if (unsavedBanners.isEmpty) {
        unsavedBanners.addAll(largeBanners);
        unsavedBanners.addAll(smallBanners);
      }

      // Get all existing banners to find the last ID
      final allBanners =
          await GetIt.instance<AppDatabase>().dualScreenDao.readAll();
      final lastId =
          allBanners.isEmpty ? 0 : allBanners.map((e) => e.id).reduce(max);

      // Get the last order for each type
      final lastLargeOrder = allBanners
          .where((b) => b.type == 1)
          .fold(0, (max, b) => b.order > max ? b.order : max);
      final lastSmallOrder = allBanners
          .where((b) => b.type == 2)
          .fold(0, (max, b) => b.order > max ? b.order : max);

      // Save all unsaved banners to database with incremented IDs and orders
      var currentId = lastId;
      var currentLargeOrder = lastLargeOrder;
      var currentSmallOrder = lastSmallOrder;
      for (final banner in unsavedBanners) {
        // Check if banner already exists in database
        final existingBanner = allBanners.firstWhere(
          (b) => b.id == banner.id,
          orElse: () => DualScreenModel(
            id: 0,
            description: '',
            type: 0,
            order: 0,
            path: '',
            duration: 0,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        );

        // If banner doesn't exist in database, increment ID and order
        if (existingBanner.id == 0) {
          currentId++;
          final order =
              banner.type == 1 ? ++currentLargeOrder : ++currentSmallOrder;

          final bannerToSave = DualScreenModel(
            id: currentId,
            description: banner.description,
            type: banner.type,
            order: order,
            path: banner.path,
            duration: banner.duration,
            createdAt: banner.createdAt,
            updatedAt: banner.updatedAt,
          );
          await GetIt.instance<AppDatabase>()
              .dualScreenDao
              .create(data: bannerToSave);
        } else {
          // Update existing banner
          final updatedBanner = DualScreenModel(
            id: existingBanner.id,
            description: banner.description,
            type: banner.type,
            order: existingBanner.order,
            path: banner.path,
            duration: banner.duration,
            createdAt: existingBanner.createdAt,
            updatedAt: DateTime.now(),
          );
          await GetIt.instance<AppDatabase>().dualScreenDao.updateById(
              id: existingBanner.id.toString(), data: updatedBanner);
        }
      }
      await _updateCustomerDisplayActive();

      // Clear unsaved changes
      setState(() {
        unsavedBanners.clear();
        _hasUnsavedChanges = false;
      });

      // Refresh banners to get the updated list with proper IDs
      await refreshBanners();

      await _sendToDisplay();
      if (mounted) {
        SnackBarHelper.presentSuccessSnackBar(
            context, 'All changes saved successfully', 3);
      }
    } catch (e) {
      setState(() => isLoading = false);
      if (mounted) {
        SnackBarHelper.presentErrorSnackBar(
            context, 'Error saving changes: ${e.toString()}');
      }
    }
  }

  Future<void> _sendToDisplay() async {
    final data = await GetIt.instance<AppDatabase>().dualScreenDao.readAll();
    final windows = await DesktopMultiWindow.getAllSubWindowIds();
    if (windows.isEmpty) {
      debugPrint('No display window found');
      return;
    }
    final windowId = windows[0];
    final jsonData = jsonEncode(data);
    debugPrint("Sending data to display: $jsonData");
    final sendingData =
        await sendData(windowId, jsonData, 'updateSalesData', 'Sales');
  }

  void onDropdownChanged(String? newValue) {
    if (newValue != null) {
      setState(() {
        dropdownValue = newValue;
        _hasUnsavedChanges = true;
      });
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
      customerDisplayActive: dbValue,
    );

    try {
      await GetIt.instance<AppDatabase>()
          .posParameterDao
          .update(docId: _posParameter!.docId, data: pos);

      setState(() {
        _hasUnsavedChanges = false;
      });

      // Show success message
      if (mounted) {
        SnackBarHelper.presentSuccessSnackBar(
            context, 'Customer display setting updated successfully', 3);
      }
    } catch (e) {
      // Show error message
      if (mounted) {
        SnackBarHelper.presentErrorSnackBar(
            context, 'Failed to update customer display setting');
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
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => BannerPopup(
                        title: 'Add $title',
                        type: title.toLowerCase().contains('large') ? 1 : 2,
                        order: banners.isEmpty ? 1 : banners.last.order + 1,
                        onSave: addUnsavedBanner,
                      ),
                    );
                  },
                  icon: const Icon(Icons.add, color: Colors.white),
                  label:
                      const Text('Add', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ProjectColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (isLoading)
          const Center(child: CircularProgressIndicator())
        else
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: Colors.black,
              ),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowColor:
                    MaterialStateProperty.all(ProjectColors.primary),
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
                                  ? '...${banner.path.substring(40, banner.path.length)}'
                                  : banner.path,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ))),
                      DataCell(SizedBox(
                          width: MediaQuery.of(context).size.width * 0.07,
                          child:
                              Center(child: Text(banner.duration.toString())))),
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
                                          final List<DualScreenModel>
                                              targetList = banner.type == 1
                                                  ? largeBanners
                                                  : smallBanners;

                                          final index = targetList.indexWhere(
                                              (b) => b.id == banner.id);

                                          if (index != -1) {
                                            // Create an updated banner model
                                            final updatedBanner =
                                                DualScreenModel(
                                              id: banner.id,
                                              description:
                                                  updatedData['description'],
                                              type: banner.type,
                                              order: banner.order,
                                              path: updatedData['path'],
                                              duration: updatedData['duration'],
                                              createdAt: banner.createdAt,
                                              updatedAt: DateTime.now(),
                                            );
                                            print(
                                                '========================================== $updatedBanner');
                                            // Update the banner in the unsaved list if it exists
                                            final unsavedIndex =
                                                unsavedBanners.indexWhere(
                                                    (b) => b.id == banner.id);
                                            if (unsavedIndex != -1) {
                                              setState(() {
                                                unsavedBanners[unsavedIndex] =
                                                    updatedBanner;
                                              });
                                            }

                                            // Update the banner in the appropriate list
                                            setState(() {
                                              if (banner.type == 1) {
                                                largeBanners[index] =
                                                    updatedBanner;
                                              } else {
                                                smallBanners[index] =
                                                    updatedBanner;
                                              }
                                              _hasUnsavedChanges = true;
                                            });

                                            // Show success message
                                            if (mounted) {
                                              SnackBarHelper.presentSuccessSnackBar(
                                                  context,
                                                  'Banner updated. Click Save to persist changes.',
                                                  3);
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
                                      builder: (context) =>
                                          const ConfirmationDialog(
                                        primaryMsg:
                                            "Are you sure you want to delete this banner?",
                                        secondaryMsg: "",
                                        isProceedOnly: false,
                                      ),
                                    );

                                    if (confirm == true) {
                                      await GetIt.instance<AppDatabase>()
                                          .dualScreenDao
                                          .delete(banner.id);
                                      await refreshBanners();
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
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(
          color: Colors.white,
        ),
        title: const Text(
          "Customer Display",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: ProjectColors.primary,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton.icon(
              onPressed: () {
                // Save action
                saveChanges();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              icon: const Icon(Icons.save, color: Colors.white),
              label: const Text(
                'Save',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
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
                    color: Colors.white,
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: dropdownValue,
                      isExpanded: true,
                      items: <String>['Yes', 'No']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: onDropdownChanged,
                    ),
                  ),
                ),
                Container(
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
    Key? key,
    required this.title,
    this.type,
    this.order,
    this.description,
    this.path,
    this.duration,
    required this.onSave,
  }) : super(key: key);

  @override
  State<BannerPopup> createState() => _BannerPopupState();
}

class _BannerPopupState extends State<BannerPopup> {
  late TextEditingController descriptionController;
  late TextEditingController pathController;
  late TextEditingController durationController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    descriptionController =
        TextEditingController(text: widget.description ?? '');
    pathController = TextEditingController(text: widget.path ?? '');
    durationController = TextEditingController(text: widget.duration ?? '');
  }

  @override
  void dispose() {
    descriptionController.dispose();
    pathController.dispose();
    durationController.dispose();
    super.dispose();
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
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.5,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Title
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: ProjectColors.primary,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 16),

                // Description Field
                TextFormField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
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
                        decoration: const InputDecoration(
                          labelText: 'Path',
                          border: OutlineInputBorder(),
                        ),
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
                  decoration: const InputDecoration(
                    labelText: 'Duration',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Duration is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

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
                        side:
                            BorderSide(width: 2, color: ProjectColors.primary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.19,
                        child: const Center(
                          child: Text('Cancel',
                              style: TextStyle(color: ProjectColors.primary)),
                        ),
                      ),
                    ),
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
                            widget.title.startsWith('Edit')
                                ? 'Save Changes'
                                : 'Add Banner',
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
    );
  }
}
