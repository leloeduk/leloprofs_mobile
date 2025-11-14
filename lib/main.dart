import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leloprofs/api/teacher_repository.dart';
import 'package:leloprofs/blocs/auth/auth_state.dart';
import 'package:leloprofs/blocs/job/job_bloc.dart';
import 'package:leloprofs/blocs/teacher/teacher_bloc.dart';
import 'package:leloprofs/blocs/teacher/teacher_event.dart';
import 'package:leloprofs/screens/main_navigation.dart';
import 'package:leloprofs/screens/teachers_screen.dart';
import 'api/api_service.dart';
import 'blocs/auth/auth_bloc.dart';
import 'screens/login_screen.dart';
import 'screens/jobs_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final ApiService apiService = ApiService();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              TeacherBloc(TeacherRepository())..add(LoadTeachers()),
          child: TeachersScreen(),
        ),
        BlocProvider<JobBloc>(
          create: (_) => JobBloc(apiService), // 👈 AJOUTER ÇA ICI
        ),
        BlocProvider<AuthBloc>(create: (_) => AuthBloc(apiService)),
      ],
      child: MaterialApp(
        title: 'Jobs App',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: AuthGate(),
      ),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthAuthenticated) {
          return MainNavigation();
        } else if (state is AuthLoading) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        } else {
          return LoginScreen();
        }
      },
    );
  }
}
