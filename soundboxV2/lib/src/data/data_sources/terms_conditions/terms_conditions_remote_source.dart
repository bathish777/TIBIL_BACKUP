import 'package:sound_box/src/data/data_sources/remote_source.dart';

abstract class TermsConditionsRemoteSource extends RemoteSource {
  Future<String?> get();
}
