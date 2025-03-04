import 'package:sound_box/src/data/data.dart';
import 'package:sound_box/src/data/data_sources/remote_source.dart';
import 'package:sound_box/src/data/server_responses/mobile_number_response.dart';
import 'package:sound_box/src/data/server_responses/request_otp_server_response.dart';
import 'package:sound_box/src/data/server_responses/verify_otp_server_response.dart';

abstract class AuthenticationRemoteSource extends RemoteSource {
  Future<VerifyOtpServerResponse> verifyOtp(String otp, String mobileNumber, String deviceId, String identification);
  Future<RequestOtpServerResponse> requestOtp({String? mobileNumber});
  Future<UserSecrets> getUserSecrets(String mobileNumber, String mpin);
  Future<List<Account>> getAccounts(String mobileNumber);
  Future<List<Upi>> getUpis({required String mobileNumber, String? accountId});
  Future<GuestTokenConfig> getGuestTokenConfig();
  Future<bool?> sendSbVpa(Upi upi);
  Future<RequestMobileNumberResponse> requestMobileNumber(String vmnCode);
}
