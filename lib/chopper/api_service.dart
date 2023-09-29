import 'package:chopper/chopper.dart';

part 'api_service.chopper.dart';

@ChopperApi(baseUrl: '/')
abstract class ApiService extends ChopperService {
  static ApiService create([ChopperClient? client]) => _$ApiService(client);

  @Post(path: 'login')
  Future<Response> login(@Body() Map<String, dynamic> body);

  @Get(path: 'user')
  Future<Response> user();

  @Get(path: 'tenant')
  Future<Response> tenant();

  @Post(path: 'community')
  Future<Response> getCommunity(@Body() Map<String, dynamic> body);

  @Get(path: 'survey/available')
  Future<Response> availableSurveys();

  @Get(path: 'survey/completed')
  Future<Response> completedSurveys();

  @Get(path: 'survey/{id}')
  Future<Response> getSurveyDetails(@Path() String id);

  @Post(path: 'survey/{id}')
  Future<Response> submitSurvey(
      @Path() String id, @Body() Map<String, dynamic> body);
}
