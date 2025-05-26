import 'package:get_it/get_it.dart';
import '.../.../networking/api_services.dart';
import '.../.../networking/dio_factory.dart';
import '.../.../features/auth/data/repositories/auth_repository.dart';
import '.../.../features/vacation/data/repo/vacation_repo.dart';
import '.../.../features/exuses/data/repo/exeuces_repo.dart';
import '.../.../features/home/data/repo/home_repo.dart';
import '.../.../features/profile/data/repo/profile_repo.dart';

final getIt = GetIt.instance;

Future<void> setupGetIt() async {
  getIt.registerLazySingleton<ApiServices>(() => ApiServices(DioFactory()));
  getIt.registerLazySingleton<AuthRepository>(() => AuthRepository(getIt()));
  getIt.registerLazySingleton<HomeRepo>(() => HomeRepo(getIt()));
  getIt.registerLazySingleton<ProfileRepository>(
      () => ProfileRepository(getIt()));
  getIt.registerLazySingleton<ExeucesRepo>(() => ExeucesRepo(getIt()));
  getIt.registerLazySingleton<VacationRepo>(() => VacationRepo(getIt()));
}
