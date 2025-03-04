import 'package:sound_box/src/data/data_sources/remote_source.dart';

import 'package:sound_box/src/data/data.dart';

abstract class PaymentRemoteSource extends RemoteSource {
  Future<List<Payment>> getAll({
    String? fromDateTime,
    String? toDateTime,
    int? lastPid,
    int? offset,
    int? limit,
  });
}
