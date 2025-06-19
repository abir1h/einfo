import 'package:flutter/material.dart';

import '../config/app.dart';
import '../constants/app_theme.dart';
import '../models/user_entity.dart';

class AppScaffold extends StatefulWidget {
  final Widget child;
  final String title;
  final int maxLine;
  final VoidCallback? onReload;
  final WillPopCallback? onBack;
  final Widget? actionChild;
  final Widget? searchChild;
  final Color? bgColor;
  final Color? leadingIconColor;
  final bool? hasAppBar;
  final Widget? floatingActionButton;
  final bool resizeToAvoidBottomInset;
  final TextStyle? textStyle;
  final Widget? leading;
  const AppScaffold({
    super.key,
    required this.child,
    required this.title,
    this.onReload,
    this.onBack,
    this.actionChild,
    this.searchChild,
    this.maxLine = 2,
    this.bgColor,
    this.floatingActionButton,
    this.hasAppBar = true,
    this.resizeToAvoidBottomInset = false,
    this.textStyle,
    this.leadingIconColor,this.leading
  });

  @override
  State<AppScaffold> createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> with AppTheme {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        backgroundColor: clr.backgroundColor,
        resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: widget.floatingActionButton,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: MediaQuery.of(context).padding.top),

            ///Title bar
            widget.hasAppBar == false
                ? Offstage()
                : Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: size.s16,
                    vertical: size.s12,
                  ),
                  decoration: BoxDecoration(
                    color: clr.appPrimaryColor,
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0,4),
                        blurRadius: 20,
                        color: clr.appBarShadowColor.withOpacity(.02)
                      )
                    ],
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(size.s16),bottomRight: Radius.circular(size.s16))
                    // border: Border(
                    //   bottom: BorderSide(
                    //     color: clr.appBarStrokeColor,
                    //     width: size.s1,
                    //   ),
                    // ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                     widget.leading?? GestureDetector(
                        onTap: () {
                          _onBackPressed().then((value) {
                            if (value) {
                              Navigator.of(context).pop();
                            }
                          });
                        },
                        child: Container(
                          color: Colors.transparent,
                          child: Icon(
                            Icons.arrow_back,
                            color:
                                widget.leadingIconColor ?? clr.appPrimaryColor,
                            size: size.s24,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: size.s8),
                          child: Text(
                            widget.title,
                            style:
                                widget.textStyle ??
                                TextStyle(
                                  color: clr.appPrimaryColor,
                                  fontSize: size.textXMedium,
                                  fontWeight: FontWeight.w500,
                                  overflow: TextOverflow.ellipsis,
                                ),
                            maxLines: widget.maxLine,
                          ),
                        ),
                      ),

                      ///Action child
                      if (widget.actionChild != null)
                        GestureDetector(child: widget.actionChild),

                      ///Reload button
                      if (widget.onReload != null)
                        GestureDetector(
                          onTap: widget.onReload,
                          child: Container(
                            color: Colors.transparent,
                            child: Icon(
                              Icons.refresh,
                              color: clr.whiteColor,
                              size: size.s24,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

            ///Search box area
            if (widget.searchChild != null)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.s20),
                child: widget.searchChild!,
              ),

            ///Body section
            Expanded(
              child: Container(
                width: double.maxFinite,
                height: double.maxFinite,
                decoration: BoxDecoration(
                  color: widget.bgColor ?? clr.backgroundColor,
                ),
                child: ClipRRect(
                  ///Body
                  child: SizedBox(
                    width: double.maxFinite,
                    height: double.maxFinite,
                    child: Padding(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).padding.bottom,
                      ),
                      child: widget.child,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _onBackPressed() async {
    if (widget.onBack != null) {
      return widget.onBack!();
    } else {
      return Future.value(true);
    }
  }
}
