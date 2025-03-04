import 'package:injectable/injectable.dart';
import 'package:sound_box/src/data/data_sources/terms_conditions/terms_conditions_remote_source.dart';
import 'package:sound_box/src/data/data_sources/terms_conditions/terms_conditions_sources.dart';

@lazySingleton
class TermsConditionsRepository {
  TermsConditionsRepository({required TermsConditionsRemoteSource remoteSource})
      : _remoteSource = remoteSource;

  final TermsConditionsRemoteSource _remoteSource;

  Future<String?> get() async {
    return await _remoteSource.get();
  }
}
