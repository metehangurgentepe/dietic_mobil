import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dietic_mobil/config/config.dart';
import 'package:table_calendar/table_calendar.dart';

class HomeScreenAppBar extends StatefulWidget {
  const HomeScreenAppBar({
    Key ? key
  }): super(key: key);

  @override
  State<HomeScreenAppBar> createState() => _HomeScreenAppBarState();
}

class _HomeScreenAppBarState extends State<HomeScreenAppBar> {
  @override
  Widget build(BuildContext context) {
    DateTime _selectedTime = DateTime.now();
    CalendarFormat _calendarFormat = CalendarFormat.month;
    DateTime? _selectedDay;

    var day = DateTime.now().day;
    var month = DateTime.now().month;
    String monthName = '';

    switch (month) {
      case 1:
        monthName = 'January';
        break;
      case 2:
        monthName = 'February';
        break;
      case 3:
        monthName = 'March';
        break;
      case 4:
        monthName = 'April';
        break;
      case 5:
        monthName = 'May';
        break;
      case 6:
        monthName = 'June';
        break;
      case 7:
        monthName = 'July';
        break;
      case 8:
        monthName = 'August';
        break;
      case 9:
        monthName = 'September';
        break;
      case 10:
        monthName = 'October';
        break;
      case 11:
        monthName = 'November';
        break;
      case 12:
        monthName = 'December';
        break;
      default:
        monthName = 'Invalid month';
    }
    void _showDatePicker() {
      showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2021),
          lastDate: DateTime(2025))
          .then((value) => {
        setState(() {
          _selectedTime = value!;
        })
      });
    }
    return Container(
      height: 100. w,
      color: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Today',
                style: TextStyle(
                  color: AppColors.colorTint500,
                  fontSize: 14. sp,
                  fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(height: 7. w),
              Text(
                '$day'+' $monthName',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16. sp,
                  fontWeight: FontWeight.bold
                ),
              )
            ]
          ),
          Container(
            height: 45. w,
            width: 45. w,
            decoration: BoxDecoration(
              color: AppColors.colorTint200,
              borderRadius: BorderRadius.circular(15)
            ),
            child: TextButton(
              onPressed:_showDatePicker,
              child: SvgPicture.asset(
                'assets/icons/calendar.svg',
                color: AppColors.colorAccent,
                width: 25. w,
                height: 25. w
              ),
            )
          ),
        ],
      ),
    );
  }
}