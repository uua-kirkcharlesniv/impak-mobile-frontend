import 'package:chopper/chopper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:impak_mobile/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:impak_mobile/blocs/login_bloc/bloc/login_bloc.dart';
import 'package:impak_mobile/blocs/profile_bloc/profile_bloc.dart';
import 'package:impak_mobile/chopper/api_service.dart';
import 'package:impak_mobile/navigation_service.dart';
import 'package:impak_mobile/pages/main_home.dart';

import 'package:impak_mobile/pages/sign_in_page.dart';
import 'package:impak_mobile/repository/authentication_repository.dart';
import 'package:impak_mobile/token_interceptor.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  final locator = GetIt.instance;
  locator.registerSingleton<ChopperClient>(
    ChopperClient(
      baseUrl: Uri.parse('http://acme.impak.test/api'),
      services: [
        ApiService.create(),
      ],
      interceptors: <dynamic>[
        HttpLoggingInterceptor(),
        const HeadersInterceptor({
          'Accept': 'application/json',
        }),
        (Request request) async {
          final instance = await SharedPreferences.getInstance();

          if (instance.containsKey('baseUrl')) {
            return request.copyWith(
              baseUri: Uri.parse(
                '${instance.getString('baseUrl')}/api',
              ),
            );
          } else {
            return request;
          }
        },
        TokenInterceptor(),
      ],
      converter: const JsonConverter(),
    ),
  );

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: await getTemporaryDirectory(),
  );

  NavigationService().setupLocator();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthenticationRepository authenticationBloc =
      AuthenticationRepository();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: authenticationBloc,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (_) => ProfileBloc(
                    authenticationRepository: authenticationBloc,
                  )),
          BlocProvider(
            create: (_) => AuthenticationBloc(
              authenticationRepository: authenticationBloc,
            ),
          ),
          BlocProvider(
            create: (context) => LoginBloc(
              authenticationRepository: authenticationBloc,
            ),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Impak Mobile',
          navigatorKey: locator<NavigationService>().navigatorKey,
          onGenerateRoute: (_) => SplashPage.route(),
          theme: ThemeData(
            textTheme: GoogleFonts.interTextTheme(),
          ),
          builder: (context, child) {
            return BlocListener<AuthenticationBloc, AuthenticationState>(
              listener: (context, state) {
                switch (state.status) {
                  case AuthenticationStatus.authenticated:
                    context.read<ProfileBloc>().add(ProfileStore(state.user!));
                    locator<NavigationService>()
                        .navigatorKey
                        .currentState!
                        .pushAndRemoveUntil<MaterialPageRoute>(
                          MaterialPageRoute(
                            builder: (BuildContext context) => const MainHome(),
                          ),
                          (route) => false,
                        );

                    break;
                  case AuthenticationStatus.unknown:
                  case AuthenticationStatus.unauthenticated:
                    locator<NavigationService>()
                        .navigatorKey
                        .currentState!
                        .pushAndRemoveUntil<MaterialPageRoute>(
                          MaterialPageRoute(
                            builder: (BuildContext context) => const SignIn(),
                          ),
                          (route) => false,
                        );

                    break;
                  case AuthenticationStatus.isLogin:
                    locator<NavigationService>()
                        .navigatorKey
                        .currentState!
                        .pushAndRemoveUntil<MaterialPageRoute>(
                          MaterialPageRoute(
                            builder: (BuildContext context) => const MainHome(),
                          ),
                          (route) => false,
                        );

                    break;
                }
              },
              child: child,
            );
          },
          // home: const SignIn(),
        ),
      ),
    );
  }
}

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const SplashPage());
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox();
  }
}
