import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:dietic_mobil/config/config.dart';
import 'package:dietic_mobil/screen/exercise/exercises_screen.dart';
import 'package:dietic_mobil/screen/login/login.dart';
import 'package:dietic_mobil/screen/message/AuthGate.dart';
import 'package:dietic_mobil/screen/message/message_screen.dart';
import 'package:dietic_mobil/screen/screen.dart';
import '../../message/authScreen.dart';
import '../exercise/new_exercises.dart';
import '../profile/profile_screen.dart';
import '../search/search_screen.dart';

class NavScreen extends StatefulWidget {
  static const String routeName = '/nav';
  const NavScreen({
    Key ? key
  }): super(key: key);


  static Route route() {
    return MaterialPageRoute(
        builder: (_) => NavScreen(),
        settings: const RouteSettings(name: routeName));
  }

  @override
  _NavScreenState createState() => _NavScreenState();



}



class _NavScreenState extends State <NavScreen> {

  int _currentIndex = 0;

  void changePage(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
  final pages = [HomeScreen(), SearchScreen(), AuthScreen(), NewExercises(), ProfilesScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: DotNavigationBar(
        currentIndex: _currentIndex,
        onTap: changePage,
        dotIndicatorColor: _currentIndex == 2 ? Colors.transparent : AppColors.colorPrimary,
        borderRadius: 0,
        backgroundColor: Colors.white,
        enablePaddingAnimation: false,
        marginR: EdgeInsets.zero,
        paddingR: EdgeInsets.zero,
        items: [
          DotNavigationBarItem(
            icon: FaIcon(
              FontAwesomeIcons.house,
              size: 20. sp,
            ),
            selectedColor: AppColors.colorAccent,
            unselectedColor: AppColors.colorTint400
          ),
          DotNavigationBarItem(
            icon: FaIcon(
              FontAwesomeIcons.search,
              size: 20. sp,
            ),
            selectedColor: AppColors.colorAccent,
            unselectedColor: AppColors.colorTint400
          ),
          DotNavigationBarItem(
            icon: Container(
              height: 48. w,
              width: 48. w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColors.colorAccent,
              ),
              child: Center(
                child: FaIcon(
                  FontAwesomeIcons.rocketchat,
                  size: 20. sp,
                ),
              ),
            ),
            selectedColor: Colors.white,
            unselectedColor: Colors.white,
          ),
          DotNavigationBarItem(
            icon: FaIcon(
              FontAwesomeIcons.stopwatch,
              size: 20. sp,
            ),
            selectedColor: AppColors.colorAccent,
            unselectedColor: AppColors.colorTint400
          ),
          DotNavigationBarItem(
            icon: FaIcon(
              FontAwesomeIcons.user,
              size: 20. sp,
            ),
            selectedColor: AppColors.colorAccent,
            unselectedColor: AppColors.colorTint400
          ),
        ],
      ),
    );
  }
}