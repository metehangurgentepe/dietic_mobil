import 'package:Dietic/dietician-screen/appointment/appointment.dart';
import 'package:Dietic/dietician-screen/appointment/choose_patient.dart';
import 'package:Dietic/dietician-screen/diet_plan/diet_plan_detail/diet_plan_detail.dart';
import 'package:Dietic/dietician-screen/nav/nav_dietician.dart';
import 'package:Dietic/dietician-screen/notes/notes.dart';
import 'package:Dietic/dietician-screen/show-appointment/appointment_detail.dart';
import 'package:Dietic/message/authScreen.dart';
import 'package:Dietic/model/get_appointment.dart';
import 'package:Dietic/screen/appointment/appointment.dart';
import 'package:Dietic/screen/appointment/success_booking.dart';
import 'package:Dietic/screen/exercise/exercises_screen.dart';
import 'package:Dietic/screen/exercise/health_app.dart';
import 'package:Dietic/screen/login/login.dart';
import 'package:Dietic/screen/meals_detail/meals_detail.dart';
import 'package:Dietic/screen/my_diary/home-fitness-app.dart';
import 'package:Dietic/screen/register/register.dart';
import 'package:Dietic/screen/show-appointment/show_appointment.dart';
import 'package:Dietic/screen/training/training_screen.dart';
import 'package:Dietic/screen/update_profile/update_profile_page.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:Dietic/screen/screen.dart';

import '../../dietician-screen/show-appointment/show_appointment.dart';
import '../../model/patient_detail.dart';
import '../../model/user_model.dart';
import '../../screen/profile/profile_screen.dart';
import '../../screen/splash/splash_screen.dart';

class AppRouter {
  static Route onGenerateRoute(RouteSettings settings) {
    final arguments = settings.arguments;
    ('The Router is: ${settings.name}');

    switch (settings.name) {
      case NavScreen.routeName:
        return NavScreen.route();
      case LoginScreen.routeName:
        return LoginScreen.route();
      case SignUpScreen.routeName:
        return SignUpScreen.route();
      /*case ProfilesScreen.routeName:
        return ProfilesScreen.route();*/
      case HomeScreen.routeName:
        return HomeScreen.route();
      case ExerciseScreen.routeName:
        return ExerciseScreen.route();
      case Appointment.routeName:
        return Appointment.route(
          date: settings.arguments as String);
      case NavDieticianScreen.routeName:
        return NavDieticianScreen.route();
      case TrainingScreen.routeName:
        return TrainingScreen.route();
      case FitnessAppHomeScreen.routeName:
        return FitnessAppHomeScreen.route();
      case AuthScreen.routeName:
        return AuthScreen.route();
      case MealsDetailScreen.routeName:
        return MealsDetailScreen.route();
      case SplashScreen.routeName:
        return SplashScreen.route();
      case AppointmentBooked.routeName:
        return AppointmentBooked.route();
      case ShowAppointment.routeName:
        return ShowAppointment.route();
      case AppointmentDetailScreen.routeName:
        return AppointmentDetailScreen.route(
            randevu: settings.arguments as GetAppointmentModel);
      case ShowPatientAppointment.routeName:
        return ShowPatientAppointment.route();
      case HealthApp.routeName:
        return HealthApp.route();
      case DietPlanDetail.routeName:
        return DietPlanDetail.route(
            patients: settings.arguments as PatientModel);
      case ChoosePatientScreen.routeName:
        return ChoosePatientScreen.route();
      case DytAppointment.routeName:
        return DytAppointment.route(patientId: settings.arguments as int);
      case UpdateProfileScreen.routeName:
        return UpdateProfileScreen.route(user: settings.arguments as UserModel);
      case NoteScreen.routeName:
        return NoteScreen.route();  

      default:
        return _errorRoute();
    }
  }

  static Route _errorRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: Text('error')),
      ),
      settings: RouteSettings(name: '/error'),
    );
  }
}
