import 'package:chopper/chopper.dart';

part 'api_service.chopper.dart';

@ChopperApi(baseUrl: '/')
abstract class ApiService extends ChopperService {
  static ApiService create([ChopperClient? client]) => _$ApiService(client);

  @Post(path: 'register')
  Future<Response> register(@Body() Map<String, dynamic> body);

  @Post(path: 'login')
  Future<Response> login(@Body() Map<String, dynamic> body);

  @Post(path: 'profile/change-password')
  Future<Response> changePassword(@Body() Map<String, dynamic> body);

  @Post(path: 'profile/update')
  Future<Response> updateProfile(@Body() Map<String, dynamic> body);

  @Get(path: 'notifications')
  Future<Response> notifications();

  @Get(path: 'categories')
  Future<Response> categories();

  @Get(path: 'messages')
  Future<Response> messages();

  @Get(path: 'transactions/merchant')
  Future<Response> merchantTransactions();

  @Get(path: 'claim')
  Future<Response> getClaimedRewards();

  @Post(path: 'claim')
  Future<Response> claimReward(@Body() Map<String, dynamic> body);

  @Post(path: 'claim-voucher')
  Future<Response> claimVoucher(@Body() Map<String, dynamic> body);

  @Get(path: 'merchants/all')
  Future<Response> allMerchants();

  @Get(path: 'merchants/subscribed')
  Future<Response> subscribedMerchants();

  @Get(path: 'merchants/available')
  Future<Response> availableMerchants();

  @Get(path: 'merchants/{id}/details')
  Future<Response> getMerchant(@Path() String id);

  @Get(path: 'merchants/{id}/messages')
  Future<Response> getMerchantMessages(@Path() String id);

  @Get(path: 'merchants/{id}/rewards')
  Future<Response> getMerchantRewards(@Path() String id);

  @Get(path: 'merchants/{id}/vouchers')
  Future<Response> getMerchantVouchers(@Path() String id);

  @Get(path: 'rewards')
  Future<Response> rewardsReady();

  @Get(path: 'public-rewards')
  Future<Response> publicRewards();

  @Get(path: 'public-vouchers')
  Future<Response> publicVouchers();

  @Get(path: 'banner')
  Future<Response> getBanner();

  @Delete(path: 'delete')
  Future<Response> deleteAccount();

  @Post(path: 'forgot-password')
  Future<Response> requestForgotPassword(@Body() Map<String, dynamic> body);
}
