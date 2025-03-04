part of 'payment_bloc.dart';

abstract class PaymentState extends Equatable {
  const PaymentState();
}

class PaymentInitialState extends PaymentState {
  @override
  List<Object?> get props => [];
}

class PaymentLoadInProgress extends PaymentState {
  const PaymentLoadInProgress({this.paymentSummary});

  final PaymentSummary? paymentSummary;

  @override
  List<Object?> get props => [paymentSummary];
}

class PaymentLoadedSuccess extends PaymentState {
  const PaymentLoadedSuccess({
    required this.paymentSummary,
    required this.payments,
    this.offset,
    this.limit,
    this.isLastPage,
    this.resetOffset = false,
  });

  final List<Payment> payments;
  final PaymentSummary paymentSummary;

  final int? offset;
  final int? limit;
  final bool? isLastPage;
  final bool resetOffset;

  @override
  List<Object?> get props =>
      [payments, paymentSummary, offset, limit, isLastPage];
}

class PaymentLoadedFailure extends PaymentState {
  const PaymentLoadedFailure(this.exception);

  final UnexpectedServerResponseException exception;

  @override
  List<Object?> get props => [exception];
}

class AuthenticationTokenFailure extends PaymentState {
  @override
  List<Object?> get props => [];
}
