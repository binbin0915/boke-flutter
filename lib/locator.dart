import 'package:boke/services/net/web_repository.dart';
import 'package:get_it/get_it.dart';
import 'config/config.dart';

import 'services/services.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => ServiceNavigation());
  locator.registerLazySingleton(() => WebRepository());
  locator.registerLazySingleton(() => SpiderRepository());
  locator.registerLazySingleton(() => Config());
}
