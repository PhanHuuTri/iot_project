// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:web_iot/config/app_color.dart';
import '../../main.dart';
import 'src/side_bar.dart';
export 'src/menu_item.dart';
export 'src/side_bar.dart';

class AdminScaffold extends StatefulWidget {
  const AdminScaffold({
    Key? key,
    this.appBar,
    this.sideBar,
    required this.body,
    this.backgroundColor,
  }) : super(key: key);

  final AppBar? appBar;
  final SideBar? sideBar;
  final Widget body;
  final Color? backgroundColor;

  @override
  _AdminScaffoldState createState() => _AdminScaffoldState();
}

class _AdminScaffoldState extends State<AdminScaffold>
    with SingleTickerProviderStateMixin {
  static const _mobileThreshold = 880.0;

  late AnimationController _animationController;
  late Animation _animation;
  bool _isMobile = false;
  bool _isOpenSidebar = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutQuad,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final mediaQuery = MediaQuery.of(context);
    setState(() {
      _isMobile = mediaQuery.size.width < _mobileThreshold;
      _isOpenSidebar = !_isMobile;
      _animationController.value = _isMobile ? 0 : 1;
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleSidebar() {
    setState(() {
      _isOpenSidebar = !_isOpenSidebar;
      if (_isOpenSidebar) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.backgroundColor,
      appBar: _buildAppBar(widget.appBar, widget.sideBar),
      drawer: _isMobile
          ? SizedBox(
              width: widget.sideBar!.width,
              child: Drawer(
                child: Column(
                  children: [
                    Container(
                      color:
                          Theme.of(context).buttonTheme.colorScheme!.background,
                      height: 56,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        // ignore: prefer_const_literals_to_create_immutables
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.asset(
                              "assets/images/logo.png",
                              width: 35,
                              height: 35,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              'C.P GROUP',
                              style: GoogleFonts.montserrat(
                                textStyle: TextStyle(
                                  color: AppColor.primary,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          widget.sideBar != null
                              ? ClipRect(
                                  child: SizedOverflowBox(
                                    size: Size(
                                      widget.sideBar!.width,
                                      double.infinity,
                                    ),
                                    child: widget.sideBar,
                                  ),
                                )
                              : const SizedBox(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          : null,
      body: AnimatedBuilder(
        animation: _animation,
        builder: (_, __) => widget.sideBar == null
            ? Row(
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: widget.body,
                    ),
                  ),
                ],
              )
            : Row(
                children: [
                  widget.sideBar != null
                      ? ClipRect(
                          child: SizedOverflowBox(
                            size: Size(widget.sideBar!.width * _animation.value,
                                double.infinity),
                            child: widget.sideBar,
                          ),
                        )
                      : const SizedBox(),
                  Expanded(
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: widget.body,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  AppBar? _buildAppBar(AppBar? appBar, SideBar? sideBar) {
    if (appBar == null) {
      return null;
    }
    final leading = sideBar != null
        ? Row(
            children: [
              Container(
                width: !_isMobile ? widget.sideBar!.width : 60,
                color: Theme.of(context).buttonTheme.colorScheme!.background,
                height: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.asset(
                        "assets/images/logo.png",
                        width: 35,
                        height: 35,
                      ),
                    ),
                    !_isMobile
                        ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              'C.P GROUP',
                              style: GoogleFonts.montserrat(
                                textStyle: TextStyle(
                                  color: AppColor.primary,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          )
                        : const SizedBox(),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.menu_rounded),
                onPressed: _toggleSidebar,
              ),
            ],
          )
        : appBar.leading;
    const centerTitle = false;

    return AppBar(
      leading: !_isMobile ? leading : null,
      automaticallyImplyLeading: appBar.automaticallyImplyLeading,
      title: appBar.title,
      actions: appBar.actions,
      flexibleSpace: appBar.flexibleSpace,
      bottom: appBar.bottom,
      elevation: appBar.elevation,
      shadowColor: appBar.shadowColor,
      shape: appBar.shape,
      backgroundColor: appBar.backgroundColor,
      brightness: appBar.brightness,
      iconTheme: appBar.iconTheme,
      actionsIconTheme: appBar.actionsIconTheme,
      textTheme: appBar.textTheme,
      primary: appBar.primary,
      centerTitle: centerTitle,
      excludeHeaderSemantics: appBar.excludeHeaderSemantics,
      titleSpacing: appBar.titleSpacing,
      toolbarOpacity: appBar.toolbarOpacity,
      bottomOpacity: appBar.bottomOpacity,
      toolbarHeight: appBar.toolbarHeight,
      leadingWidth: !_isMobile
          ? sideBar != null
              ? widget.sideBar!.width + 50
              : appBar.leadingWidth
          : null,
    );
  }
}
