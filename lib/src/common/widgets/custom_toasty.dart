import '../constants/common_imports.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class Toasty{
  OverlayState? _overlayState;
  static OverlayEntry? _uiLockOverlayEntry;
  static bool _isUiLocked = false;
  late BuildContext _context;

  // constructor
  Toasty.of(BuildContext context){
    try {
      _context = context;
      _overlayState = Overlay.of(context);
      _uiLockOverlayEntry ??= OverlayEntry(builder: _buildUiLockOverlayEntry);
    }catch(_){}
  }


  // public methods
  showSuccess(String message, {Duration duration = const Duration(milliseconds: 3000)}){
    _showToast(message,duration,"success");
  }
  showWarning(String message, {Duration duration = const Duration(milliseconds: 3000)}){
    _showToast(message,duration,"warning");
  }
  showError({String message="Couldn't connect to the server.", Duration duration = const Duration(milliseconds: 3000)}){
    _showToast(message,duration,"error");
  }
  _showToast(String message, Duration duration, String type){
    ToastOverlayEntry overlay = ToastOverlayEntry(
      message: message,
      duration: duration,
      type: type,
    );
    _overlayState?.insert(overlay.overlayEntry);
  }



  // block touch screens
  lockUI({bool blockBackPress=false}){
    if(!_isUiLocked) {
      showDialog(
          context: _context,
          barrierDismissible: false,
          builder: (context){
            return WillPopScope(
              onWillPop: ()async{return Future.value(!blockBackPress);},
              child: Scaffold(
                backgroundColor: Colors.transparent,
                body: Center(
                  child: Container(
                    padding: EdgeInsets.only(
                      left: 24.w,
                      right: 24.w,
                      top: 24.w,
                      bottom: 24.w,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18.w),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 42.w,
                          width: 42.w,
                          child: CircularProgressIndicator(
                            valueColor: const AlwaysStoppedAnimation(
                              Colors.indigo,
                            ),
                            strokeWidth: 2.w,
                          ),
                        ),
                        SizedBox(height: 16.w,),
                        Text(
                          "Please wait..",
                          style: TextStyle(
                            color: Colors.indigo,
                            fontSize: 20.sp,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
      ).whenComplete((){
        _isUiLocked = false;
      });
      _isUiLocked = true;
    }
  }
  Future releaseUI()async{
    if(_isUiLocked) {
      return Navigator.of(_context).pop();
    }else{
      return;
    }
  }
  Widget _buildUiLockOverlayEntry(BuildContext context) {
    var screen = MediaQuery.of(context);
    return WillPopScope(
      onWillPop: ()=> Future<bool>.value(false),
      child: Container(
        color: Colors.transparent,
        height: screen.size.height,
        width: screen.size.width,
      ),
    );
  }


}

class ToastOverlayEntry{
  late final String message;
  late final Duration duration;
  late final String type;

  // constructor
  ToastOverlayEntry({
    required this.message,
    required this.duration,
    required this.type,
  });


  // overlay entry getter
  OverlayEntry? _overlayEntry;
  OverlayEntry get overlayEntry {
    _overlayEntry = OverlayEntry(
        builder: (x)=> _Toast(
          context: x,
          message: message,
          duration: duration,
          type: type,
          onRemove:_onRemove,
        )
    );
    return _overlayEntry!;
  }

  void _onRemove() {
    if(_overlayEntry != null)
    {
      try{
        _overlayEntry?.remove();
      }
      catch (e)
      {
        debugPrint(e.toString());
      }
    }
  }
}
class _Toast extends StatefulWidget {
  final BuildContext context;
  final String message;
  final Duration duration;
  final String type;
  final VoidCallback onRemove;

  const _Toast({
    Key? key,
    required this.context,
    required this.message,
    required this.duration,
    required this.type,
    required this.onRemove,
  }) : super(key: key);

  @override
  __ToastState createState() => __ToastState();
}

class __ToastState extends State<_Toast> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _offsetAnimation;

  late Color _backgroundColor;
  late Color _iconColor;
  late IconData _icon;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _offsetAnimation = Tween(begin: -1.0, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInCubic),
    );

    _setupToastStyle();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      _handleAnimation();
    });
  }

  void _setupToastStyle() {
    switch (widget.type) {
      case "success":
        _backgroundColor = const Color(0xFFE6F4EA);
        _iconColor = const Color(0xFF0F9D58);
        _icon = Icons.check_circle;
        break;
      case "warning":
        _backgroundColor = const Color(0xFFFFF4E5);
        _iconColor = const Color(0xFFFFA000);
        _icon = Icons.warning;
        break;
      case "error":
        _backgroundColor = const Color(0xFFFFEBEE);
        _iconColor = const Color(0xFFD32F2F);
        _icon = Icons.error;
        break;
      case "info":
      default:
        _backgroundColor = const Color(0xFFE3F2FD);
        _iconColor = const Color(0xFF1976D2);
        _icon = Icons.info_outline;
        break;
    }
  }

  void _handleAnimation() {
    _animationController.forward().then((_) {
      return Future.delayed(widget.duration);
    }).then((_) {
      _animationController.reverse().then((_) {
        widget.onRemove();
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screen = MediaQuery.of(context);
    return Positioned(
      top: MediaQuery.of(context).padding.top + 16,
      left: 16,
      right: 16,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return FractionalTranslation(
            translation: Offset(0, _offsetAnimation.value),
            child: child,
          );
        },
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: screen.size.width,
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            decoration: BoxDecoration(
              color: _backgroundColor,
              borderRadius: BorderRadius.circular(12),
              border: Border(
                left: BorderSide(
                  color: _iconColor,
                  width: 12,
                ),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(
                  _icon,
                  color: _iconColor,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.message,
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: StringData.fontFamilyPoppins,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
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

