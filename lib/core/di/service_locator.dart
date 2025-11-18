import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:lges_teacher_app/module/auth/repo/user_schools_repo.dart';
import 'package:lges_teacher_app/module/daily_diary/repo/diary_repo.dart';
import 'package:lges_teacher_app/module/evaluation/repo/evaluation_repo.dart';
import 'package:lges_teacher_app/module/events/repo/events_repository.dart';
import 'package:lges_teacher_app/module/exam_result/repo/exam_result_repo.dart';
import 'package:lges_teacher_app/module/home/repo/home_repo.dart';
import 'package:lges_teacher_app/module/students_attendance/repo/attendance_repo.dart';
import 'package:lges_teacher_app/module/teacher_observation/repo/observation_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../config/flavors/flavors.dart';
import '../../module/auth/repo/auth_repository.dart';
import '../../module/chat/repo/chat_repository.dart';
import '../../module/class_section/repo/classes_sections_repo.dart';
import '../../module/leaves/repo/leaves_repo.dart';
import '../core.dart';
import '../notifications/cloud_messaging_service.dart';
import '../notifications/local_notification_service.dart';

final sl = GetIt.instance;

Future<void> initDependencies(AppEnv appEnv) async {
  sl.registerSingleton(Flavors()..initConfig(appEnv));
  sl.registerSingletonAsync<SharedPreferences>(
    () => SharedPreferences.getInstance(),
  );

  // modules
  sl.registerSingletonWithDependencies<StorageService>(
    () => StorageService(sl()),
    dependsOn: [SharedPreferences],
  );
  sl.registerLazySingleton<NetworkService>(
    () => NetworkService(sl(), dio: Dio()),
  );

  // notifications
  sl.registerLazySingleton<CloudMessagingService>(
    () => CloudMessagingService(),
  );
  sl.registerLazySingleton<LocalNotificationsService>(
    () => LocalNotificationsService(),
  );

  sl.registerLazySingleton<AuthRepository>(() => AuthRepository(sl(), sl()));
  sl.registerLazySingleton<UserSchoolsRepository>(
    () => UserSchoolsRepository(),
  );
  sl.registerLazySingleton<ClassesSectionsRepository>(
    () => ClassesSectionsRepository(),
  );
  sl.registerLazySingleton<AttendanceRepository>(() => AttendanceRepository());
  sl.registerLazySingleton<DiaryRepository>(() => DiaryRepository());
  sl.registerLazySingleton<HomeRepository>(() => HomeRepository());
  sl.registerLazySingleton<EvaluationRepository>(() => EvaluationRepository());
  sl.registerLazySingleton<ExamResultRepository>(() => ExamResultRepository());
  sl.registerLazySingleton<ObservationRepository>(
    () => ObservationRepository(),
  );
  sl.registerLazySingleton<LeavesRepository>(() => LeavesRepository());
  sl.registerLazySingleton<EventsRepository>(() => EventsRepository());
  sl.registerLazySingleton<ChatRepository>(() => ChatRepository());
}
