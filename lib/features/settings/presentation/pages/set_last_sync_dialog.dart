import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/core/utilities/helpers.dart';
import 'package:pos_fe/core/utilities/snack_bar_helper.dart';
import 'package:pos_fe/features/sales/data/models/pos_parameter.dart';
import 'package:pos_fe/features/sales/domain/entities/pos_parameter.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_pos_parameter.dart';

class SetLastSyncDateDialog extends StatefulWidget {
  final DateTime lastSyncDate;
  const SetLastSyncDateDialog({
    Key? key,
    required this.lastSyncDate,
  }) : super(key: key);

  @override
  State<SetLastSyncDateDialog> createState() => _SetLastSyncDateDialogState();
}

class _SetLastSyncDateDialogState extends State<SetLastSyncDateDialog> {
  @override
  initState() {
    super.initState();
  }

  Future<void> updateTopos() async {
    final POSParameterEntity? topos =
        await GetIt.instance<GetPosParameterUseCase>().call();
    String formattedLocalTime = "${widget.lastSyncDate.toIso8601String()}Z";

    if (topos == null) throw "POS Parameter not found";

    POSParameterEntity updateTopos =
        topos.copyWith(lastSync: formattedLocalTime);
    POSParameterModel posModel = POSParameterModel.fromEntity(updateTopos);
    await GetIt.instance<AppDatabase>()
        .posParameterDao
        .update(docId: posModel.docId, data: posModel);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0))),
      title: Container(
        decoration: const BoxDecoration(
          color: ProjectColors.primary,
          borderRadius: BorderRadius.vertical(top: Radius.circular(5.0)),
        ),
        padding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
        child: const Text(
          'Set Date',
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.w500, color: Colors.white),
        ),
      ),
      titlePadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      contentPadding: const EdgeInsets.fromLTRB(40, 20, 30, 10),
      content: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            "assets/images/caution.png",
            width: 80,
          ),
          const SizedBox(
            width: 30,
          ),
          SizedBox(
            width: 400,
            child: RichText(
              text: TextSpan(
                children: [
                  const TextSpan(
                    text: "Set Last Sync Date to  ",
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  TextSpan(
                    text: Helpers.dateEEddMMMMyyy(widget.lastSyncDate),
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: ProjectColors.green,
                    ),
                  ),
                  const TextSpan(
                    text: "  ?",
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const TextSpan(
                    text: "\n\nPlease proceed to save the date",
                  ),
                ],
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                ),
              ),
              overflow: TextOverflow.clip,
            ),
          )
        ],
      ),
      actions: <Widget>[
        Row(
          children: [
            Expanded(
                flex: 1,
                child: TextButton(
                  style: ButtonStyle(
                      shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                          side:
                              const BorderSide(color: ProjectColors.primary))),
                      backgroundColor: WidgetStateColor.resolveWith(
                          (states) => Colors.white),
                      overlayColor: WidgetStateColor.resolveWith(
                          (states) => Colors.black.withOpacity(.2))),
                  onPressed: () {
                    context.pop(false);
                  },
                  child: const Center(
                      child: Text(
                    "Cancel",
                    style: TextStyle(color: ProjectColors.primary),
                  )),
                )),
            const SizedBox(
              width: 10,
            ),
            Expanded(
                child: TextButton(
              style: ButtonStyle(
                  shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5))),
                  backgroundColor: WidgetStateColor.resolveWith(
                      (states) => ProjectColors.primary),
                  overlayColor: WidgetStateColor.resolveWith(
                      (states) => Colors.white.withOpacity(.2))),
              onPressed: () async {
                await updateTopos();
                context.pop();
                SnackBarHelper.presentSuccessSnackBar(
                    context,
                    "Last Sync set to ${Helpers.dateEEddMMMMyyy(widget.lastSyncDate)}",
                    3);
              },
              child: const Center(
                  child: Text(
                "Proceed",
                style: TextStyle(color: Colors.white),
              )),
            )),
          ],
        ),
      ],
      actionsPadding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
    );
  }
}
