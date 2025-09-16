import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lges_teacher_app/module/auth/cubit/forget_password_cubit/forget_password_cubit.dart';
import 'package:lges_teacher_app/module/auth/cubit/login_cubit/login_cubit.dart';
import 'package:lges_teacher_app/module/teacher_observation/cubit/observation_level_cubit/observation_level_cubit.dart';
import 'app.dart';
import 'config/flavors/flavors.dart';
import 'core/app_bloc_observer.dart';
import 'core/di/service_locator.dart';
import 'module/auth/cubit/auth_cubit/auth_cubit.dart';
import 'module/evaluation/cubit/add_evaluation_remarks_cubit/add_evaluation_remarks_cubit.dart';
import 'module/evaluation/cubit/evaluation_areas_cubit/evaluation_areas_cubit.dart';
import 'module/teacher_observation/cubit/add_update_delete_level_cubit/add_update_delete_level_cubit.dart';
import 'module/teacher_observation/cubit/employee_detail_cubit/employee_detail_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = AppBlocObserver();
  await initDependencies(AppEnv.dev);
  await sl.allReady();

  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(create: (_) => AuthCubit(sl())),
        BlocProvider<LoginCubit>(create: (_) => LoginCubit(sl())),
        BlocProvider<ForgetPasswordCubit>(
          create: (_) => ForgetPasswordCubit(sl()),
        ),
        BlocProvider<AddEvaluationRemarksCubit>(
          create: (_) => AddEvaluationRemarksCubit(sl()),
        ),
        BlocProvider<EvaluationAreasCubit>(
          create: (_) => EvaluationAreasCubit(sl()),
        ),
        BlocProvider<ObservationLevelCubit>(
          create: (_) => ObservationLevelCubit(sl()),
        ),
        BlocProvider<AddUpdateDeleteLevelCubit>(
          create: (_) => AddUpdateDeleteLevelCubit(sl()),
        ),
        BlocProvider<EmployeeDetailCubit>(
          create: (_) => EmployeeDetailCubit(sl()),
        ),
      ],
      child: const App(),
    ),
  );
}
