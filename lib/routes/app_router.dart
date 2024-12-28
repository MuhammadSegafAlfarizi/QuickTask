import 'package:flutter/material.dart';
import 'package:task_manager_app/routes/pages.dart';
import 'package:task_manager_app/splash_screen.dart';
import 'package:task_manager_app/tasks/presentation/pages/new_task_screen.dart';
import 'package:task_manager_app/tasks/presentation/pages/tasks_screen.dart';

import '../page_not_found.dart';

Route onGenerateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case Pages.initial:
      return MaterialPageRoute(
        builder: (context) => const SplashScreen(),
      );
    case Pages.home:
      return MaterialPageRoute(
        builder: (context) => const TasksScreen(),
      );
    case Pages.createNewTask:
      return MaterialPageRoute(
        builder: (context) => const NewTaskScreen(),
      );
    default:
      return MaterialPageRoute(
        builder: (context) => const PageNotFound(),
      );
  }
}
