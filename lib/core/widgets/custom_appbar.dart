import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:pos_fe/core/resources/custom_appbar_style.dart';
import 'package:pos_fe/core/widgets/clickable_ripple.dart';
import 'package:pos_fe/core/widgets/custom_input.dart';
import 'package:pos_fe/core/utilities/helpers.dart';

class CustomAppBar extends StatefulWidget {
  const CustomAppBar({
    Key? key,
    required this.title,
    this.elementColor,
    this.decoration,
    this.suffix,
    this.style = CustomAppBarStyle.red,
    this.height,
    this.onBackPressed,
    this.showSearchButton = true,
    this.onSearch,
  }) : super(key: key);

  final String title;
  final Color? elementColor;
  final BoxDecoration? decoration;
  final Widget? suffix;
  final CustomAppBarStyle style;
  final double? height;
  final void Function()? onBackPressed;
  final void Function(String query)? onSearch;
  final bool showSearchButton;

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  bool isSearchVisible = false;
  late TextEditingController searchController;

  @override
  void initState() {
    super.initState();

    searchController = TextEditingController();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var isRed = widget.style == CustomAppBarStyle.red;
    var color =
        widget.elementColor ?? (isRed ? Colors.white : ProjectColors.primary);

    Helpers.setStatusbarIconBrightness(
        isRed ? Brightness.light : Brightness.dark);

    return Container(
        height: (widget.height ?? 90) + MediaQuery.of(context).viewPadding.top,
        decoration: widget.decoration ??
            BoxDecoration(
                color: isRed ? ProjectColors.primary : Colors.white,
                boxShadow: widget.title == "Trading"
                    ? null
                    : [
                        BoxShadow(
                            blurRadius: 3.0,
                            color: Colors.black.withOpacity(.3))
                      ]),
        child: isSearchVisible
            ? Container(
                color: Colors.white,
                alignment: Alignment.center,
                padding: const EdgeInsets.all(15),
                child: SafeArea(
                  bottom: false,
                  child: Row(
                    children: [
                      ClickableRipple(
                          onTap: () {
                            setState(() {
                              isSearchVisible = false;
                            });
                          },
                          child: const Icon(Icons.arrow_back_ios_new)),
                      const SizedBox(width: 10),
                      Expanded(
                          child: CustomInput(
                        controller: searchController,
                        textInputAction: TextInputAction.search,
                        suffixIcon: ClickableRipple(
                          onTap: () => searchController.clear(),
                          child: const Icon(Icons.clear),
                        ),
                        onEditingComplete: widget.onSearch == null
                            ? null
                            : () => widget.onSearch!(searchController.text),
                        autofocus: true,
                        hint: "Search",
                      )),
                    ],
                  ),
                ))
            : Stack(
                fit: StackFit.loose,
                children: [
                  SvgPicture.asset("assets/img/decoration/wave.svg",
                      width: double.infinity, fit: BoxFit.fitHeight),
                  SizedBox(
                    height: double.infinity,
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: 15,
                          bottom: 15,
                          right: 15,
                          top: MediaQuery.of(context).viewPadding.top + 15),
                      child: Row(
                        children: [
                          ClickableRipple(
                              shape: BoxShape.circle,
                              onTap: widget.onBackPressed ??
                                  () => Navigator.pop(context),
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Center(
                                  child:
                                      Icon(Icons.arrow_back_ios, color: color),
                                ),
                              )),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(widget.title,
                                    style:
                                        TextStyle(fontSize: 16, color: color)),
                                const SizedBox(height: 3),
                                Text("1.0.0+test13",
                                    style: TextStyle(
                                        color: (widget.style ==
                                                    CustomAppBarStyle.red
                                                ? Colors.white
                                                : ProjectColors.primary)
                                            .withOpacity(.7),
                                        fontSize: 12)),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          if (widget.showSearchButton)
                            Padding(
                              padding: const EdgeInsets.only(right: 15.0),
                              child: ClickableRipple(
                                  onTap: () => setState(() {
                                        isSearchVisible = true;
                                      }),
                                  child: Icon(Icons.search,
                                      color:
                                          widget.style == CustomAppBarStyle.red
                                              ? Colors.white
                                              : const Color.fromRGBO(
                                                  80, 80, 80, 1))),
                            ),
                          widget.suffix ?? const SizedBox()
                        ],
                      ),
                    ),
                  ),
                ],
              ));
  }
}
