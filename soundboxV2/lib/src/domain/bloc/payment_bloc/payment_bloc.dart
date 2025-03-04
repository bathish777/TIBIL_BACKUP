import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:sound_box/src/data/repositories/payment_repository.dart';
import 'package:sound_box/src/data/repositories/payment_summary_repository.dart';

import 'package:sound_box/src/data/data.dart';

import '../../../config/config.dart';
import '../../../data/exceptions/error_codes.dart';
import '../../../data/exceptions/unexpected_server_response_exception.dart';

part 'payment_event.dart';

part 'payment_state.dart';

@lazySingleton
class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  PaymentBloc({
    required PaymentSummaryRepository paymentSummaryRepository,
    required PaymentRepository paymentRepository,
  })  : _paymentRepository = paymentRepository,
        _paymentSummaryRepository = paymentSummaryRepository,
        super(PaymentInitialState()) {
    _paymentSubscription =
        _paymentRepository.events.listen(_paymentEventListener);

    on<PaymentLoaded>(_mapPaymentLoadedState);
  }

  final PaymentSummaryRepository _paymentSummaryRepository;
  final PaymentRepository _paymentRepository;

  StreamSubscription<dynamic>? _paymentSubscription;

  _paymentEventListener(event) {
    add(
      PaymentLoaded(
        offset: Config.transactionOffset,
        limit: Config.transactionLimitation,
        resetOffset: true,
      ),
    );
  }

  _mapPaymentLoadedState(
    PaymentLoaded event,
    Emitter<PaymentState> emit,
  ) async {
    emit(
      PaymentLoadInProgress(
        paymentSummary: (state is PaymentLoadedSuccess)
            ? (state as PaymentLoadedSuccess).paymentSummary
            : null,
      ),
    );
    try {
      PaymentSummary? paymentSummary =
          await _paymentSummaryRepository.fetchAndSaveLocal(refresh: true);

      List<Payment> payments = [];

      final int? limit = event.limit;
      final int? offset = event.offset;

      bool isLastPage = false;

      if (offset != null && limit != null) {
        payments = await _paymentRepository.getAll(
          refresh: true,
          offset: offset,
          limit: limit,
        );

        isLastPage = payments.length < limit;
      } else {
        payments = await _paymentRepository.getAll(refresh: true);
      }

      if (paymentSummary != null) {
        emit(
          PaymentLoadedSuccess(
            paymentSummary: paymentSummary,
            payments: payments,
            offset: offset,
            limit: limit,
            isLastPage: isLastPage,
            resetOffset: event.resetOffset,
          ),
        );
      } else {
        emit(
          const PaymentLoadedFailure(
            UnexpectedServerResponseException(
              statusCode: ErrorCodes.noRecordFoundError,
            ),
          ),
        );
      }
    } on UnexpectedServerResponseException catch (e) {
      emit(
        e.statusCode == 401
            ? AuthenticationTokenFailure()
            : const PaymentLoadedFailure(
                UnexpectedServerResponseException(
                  statusCode: ErrorCodes.unableToFetchPayments,
                ),
              ),
      );
    } catch (e) {
      emit(
        const PaymentLoadedFailure(
          UnexpectedServerResponseException(
            statusCode: ErrorCodes.unableToFetchPayments,
          ),
        ),
      );
    }
  }

  @override
  Future<void> close() {
    _paymentSubscription?.cancel();

    return super.close();
  }
}
