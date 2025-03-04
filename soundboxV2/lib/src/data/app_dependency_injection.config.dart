// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:sound_box/src/data/data.dart' as _i12;
import 'package:sound_box/src/data/data_sources/payment/implementation/payment_api_source.dart'
    as _i20;
import 'package:sound_box/src/data/data_sources/payment/implementation/payment_hive_source.dart'
    as _i9;
import 'package:sound_box/src/data/data_sources/payment/payment_local_source.dart'
    as _i8;
import 'package:sound_box/src/data/data_sources/payment/payment_remote_source.dart'
    as _i19;
import 'package:sound_box/src/data/data_sources/payment/payment_sources.dart'
    as _i29;
import 'package:sound_box/src/data/data_sources/payment_summary/implementation/payment_summary_api_source.dart'
    as _i22;
import 'package:sound_box/src/data/data_sources/payment_summary/implementation/payment_summary_hive_source.dart'
    as _i14;
import 'package:sound_box/src/data/data_sources/payment_summary/payment_summary_local_source.dart'
    as _i13;
import 'package:sound_box/src/data/data_sources/payment_summary/payment_summary_remote_source.dart'
    as _i21;
import 'package:sound_box/src/data/data_sources/payment_summary/payment_summary_sources.dart'
    as _i31;
import 'package:sound_box/src/data/data_sources/preferences/implementation/preferences_api_source.dart'
    as _i11;
import 'package:sound_box/src/data/data_sources/preferences/preferences_remote_source.dart'
    as _i10;
import 'package:sound_box/src/data/data_sources/subscription_data/implementation/subscription_data_hive_source.dart'
    as _i16;
import 'package:sound_box/src/data/data_sources/subscription_data/subscription_data_local_source.dart'
    as _i15;
import 'package:sound_box/src/data/data_sources/subscription_data/subscription_data_sources.dart'
    as _i26;
import 'package:sound_box/src/data/data_sources/terms_conditions/implementation/terms_conditions_api_source.dart'
    as _i18;
import 'package:sound_box/src/data/data_sources/terms_conditions/terms_conditions_remote_source.dart'
    as _i17;
import 'package:sound_box/src/data/data_sources/upi/implementation/upi_hive_source.dart'
    as _i7;
import 'package:sound_box/src/data/data_sources/upi/upi_local_source.dart'
    as _i6;
import 'package:sound_box/src/data/data_sources/user/implementation/user_hive_source.dart'
    as _i5;
import 'package:sound_box/src/data/data_sources/user/user_local_source.dart'
    as _i4;
import 'package:sound_box/src/data/data_sources/user_credential/implementation/user_credential_hive_source.dart'
    as _i24;
import 'package:sound_box/src/data/data_sources/user_credential/user_credential_local_source.dart'
    as _i23;
import 'package:sound_box/src/data/repositories/payment_repository.dart'
    as _i28;
import 'package:sound_box/src/data/repositories/payment_summary_repository.dart'
    as _i30;
import 'package:sound_box/src/data/repositories/subscription_data_repository.dart'
    as _i25;
import 'package:sound_box/src/data/repositories/terms_conditions_repository.dart'
    as _i35;
import 'package:sound_box/src/domain/bloc/payment_bloc/payment_bloc.dart'
    as _i34;
import 'package:sound_box/src/domain/bloc/preference/preference_controller.dart'
    as _i33;
import 'package:sound_box/src/domain/bloc/preference/preference_service.dart'
    as _i27;
import 'package:sound_box/src/notification_service/app_notification.dart'
    as _i3;
import 'package:sound_box/src/notification_service/notification_handler.dart'
    as _i32;

extension GetItInjectableX on _i1.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i1.GetIt init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.lazySingleton<_i3.AppNotification>(() => _i3.AppNotification());
    gh.lazySingleton<_i4.UserLocalSource>(
      () => _i5.UserHiveSource(),
      dispose: (i) => i.dispose(),
    );
    gh.lazySingleton<_i6.UpiLocalSource>(
      () => _i7.UpiHiveSource(),
      dispose: (i) => i.dispose(),
    );
    gh.lazySingleton<_i8.PaymentLocalSource>(
      () => _i9.PaymentHiveSource(),
      dispose: (i) => i.dispose(),
    );
    gh.lazySingleton<_i10.PreferencesRemoteSource>(
        () => _i11.PreferencesApiSource(gh<_i12.AuthorizationMemorySource>()));
    gh.lazySingleton<_i13.PaymentSummaryLocalSource>(
      () => _i14.PaymentSummaryHiveSource(),
      dispose: (i) => i.dispose(),
    );
    gh.lazySingleton<_i15.SubscriptionDataLocalSource>(
      () => _i16.SubscriptionDataHiveSource(),
      dispose: (i) => i.dispose(),
    );
    gh.lazySingleton<_i17.TermsConditionsRemoteSource>(() =>
        _i18.TermsConditionsApiSource(gh<_i12.AuthorizationMemorySource>()));
    gh.lazySingleton<_i19.PaymentRemoteSource>(
        () => _i20.PaymentApiSource(gh<_i12.AuthorizationMemorySource>()));
    gh.lazySingleton<_i21.PaymentSummaryRemoteSource>(() =>
        _i22.PaymentSummaryApiSource(gh<_i12.AuthorizationMemorySource>()));
    gh.lazySingleton<_i23.UserCredentialLocalSource>(
      () => _i24.UserCredentialHiveSource(),
      dispose: (i) => i.dispose(),
    );
    gh.lazySingleton<_i25.SubscriptionDataRepository>(() =>
        _i25.SubscriptionDataRepository(
            gh<_i26.SubscriptionDataLocalSource>()));
    gh.lazySingleton<_i27.PreferenceService>(() =>
        _i27.PreferenceService(userRepository: gh<_i12.UserRepository>()));
    gh.lazySingleton<_i28.PaymentRepository>(
      () => _i28.PaymentRepository(
        localSource: gh<_i29.PaymentLocalSource>(),
        remoteSource: gh<_i29.PaymentRemoteSource>(),
      ),
      dispose: (i) => i.dispose(),
    );
    gh.lazySingleton<_i30.PaymentSummaryRepository>(
        () => _i30.PaymentSummaryRepository(
              remoteSource: gh<_i31.PaymentSummaryRemoteSource>(),
              localSource: gh<_i31.PaymentSummaryLocalSource>(),
            ));
    gh.lazySingleton<_i32.NotificationHandler>(() => _i32.NotificationHandler(
          gh<_i28.PaymentRepository>(),
          gh<_i30.PaymentSummaryRepository>(),
        ));
    gh.lazySingleton<_i33.PreferenceController>(
        () => _i33.PreferenceController(gh<_i27.PreferenceService>()));
    gh.lazySingleton<_i34.PaymentBloc>(() => _i34.PaymentBloc(
          paymentSummaryRepository: gh<_i30.PaymentSummaryRepository>(),
          paymentRepository: gh<_i28.PaymentRepository>(),
        ));
    gh.lazySingleton<_i35.TermsConditionsRepository>(() =>
        _i35.TermsConditionsRepository(
            remoteSource: gh<_i17.TermsConditionsRemoteSource>()));
    return this;
  }
}
