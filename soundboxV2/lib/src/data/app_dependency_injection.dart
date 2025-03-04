import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'app_dependency_injection.config.dart';

final GetIt getIt = GetIt.instance;

@InjectableInit()
void configureDependencies() => getIt.init();

Future<void> resetDependencies() async {
  await getIt.resetScope();
  configureDependencies();
}
