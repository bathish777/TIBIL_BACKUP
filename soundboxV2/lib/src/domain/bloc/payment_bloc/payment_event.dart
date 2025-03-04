part of 'payment_bloc.dart';

abstract class PaymentEvent extends Equatable {
  const PaymentEvent();
}

class PaymentLoaded extends PaymentEvent {
  const PaymentLoaded({
    this.offset,
    this.limit,
    this.resetOffset = false,
  });

  final int? offset;
  final int? limit;
  final bool resetOffset;

  @override
  List<Object?> get props => [offset, limit];
}
