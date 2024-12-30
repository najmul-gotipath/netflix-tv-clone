import 'package:flutter/material.dart';
import 'package:tv_app/screens/custom_rail.dart';
import 'package:tv_app/screens/movies_page.dart';
import 'package:tv_app/screens/series_page.dart';

void main() => runApp(
      MyApp(),
    );

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final FocusNode focusNode;
  late final PageController pageController;
  bool _isSidebarExpanded = false;

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();
    pageController = PageController();
  }

  @override
  void dispose() {
    focusNode.dispose();
    pageController.dispose();
    super.dispose();
  }

  void _handleBackPress() {
    if (pageController.page == 1) { // Movies page is the 2nd page, index 1
      setState(() {
        _isSidebarExpanded = true; // Expand the sidebar
      });
      focusNode.requestFocus(); // Focus back on the sidebar
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WillPopScope(
        onWillPop: () async {
          _handleBackPress();
          return false; // Prevent default back action
        },
        child: Scaffold(
          body: Row(
            children: [
              CustomNavigationRail(
                focusNode: focusNode,
                pageController: pageController,
                isSidebarExpanded: _isSidebarExpanded,
                onSidebarExpandedChanged: (expanded) {
                  setState(() {
                    _isSidebarExpanded = expanded;
                  });
                },
              ),
              Expanded(
                child: PageView(
                  controller: pageController,
                  children: [
                    Center(child: Text("Home Page")),
                    MoviesPage(onBackPress: _handleBackPress),
                    SeriesPage(),
                    Center(child: Text("My List Page")),
                    Center(child: Text("Settings Page")),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
