import 'package:sound_box/src/data/data_sources/remote_source.dart';

import 'package:sound_box/src/data/data.dart';

abstract class PaymentSummaryRemoteSource extends RemoteSource {
  Future<PaymentSummary?> get();
}