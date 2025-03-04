import '../data.dart';

class SimLocalData extends Model {
  const SimLocalData({this.number, this.carrier});

  final String? number;

  final String? carrier;

  @override
  List<Object?> get props => [number, carrier];
}
