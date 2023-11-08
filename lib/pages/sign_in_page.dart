import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:http/http.dart' as http;
import 'package:impak_mobile/blocs/login_bloc/bloc/login_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool _isFindingCompany = true;

  final _controller = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _validate() {
    if (_isFindingCompany) {
      _validateUrl();
    } else {
      context.read<LoginBloc>().add(SubmitLogin());
    }
  }

  Future<void> _validateUrl() async {
    try {
      final url = kDebugMode
          ? 'http://${_controller.text}.impak.test'
          : 'https://${_controller.text}.impak.app';
      final uri = Uri.parse(url);

      final client = http.Client();
      final response = await client.get(uri);

      if (response.statusCode == 200) {
        final spInstance = await SharedPreferences.getInstance();
        await spInstance.setString('baseUrl', url);

        setState(() {
          _isFindingCompany = false;
        });
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(
                content: Text(
                  'We cannot find your company. Try again.',
                ),
              ),
            );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            const SnackBar(
              content: Text(
                'Something wen\'t wrong processing your request. Try again later.',
              ),
            ),
          );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(29),
        child: BlocListener<LoginBloc, LoginState>(
          listener: (context, state) {
            // no-op
          },
          listenWhen: (previous, current) {
            if (!previous.submissionStatus.isSubmissionFailure &&
                current.submissionStatus.isSubmissionFailure) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text(
                      current.message,
                    ),
                  ),
                );
            }
            return true;
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/logo.png',
                height: 60,
              ),
              const SizedBox(height: 80),
              Builder(builder: (context) {
                if (_isFindingCompany) {
                  return Column(
                    children: [
                      const Align(
                        child: Text(
                          'Let\'s find your company',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 24,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Enter your company URL',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _controller,
                              decoration: InputDecoration(
                                hintText: 'trainstation',
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Color(0xffEEEEEE)),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                fillColor: Colors.white,
                                filled: true,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            '.impak.app',
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                        ],
                      ),
                    ],
                  );
                }

                return Column(
                  children: [
                    const Align(
                      child: Text(
                        'Welcome back!',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 24,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Please enter your login details',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 24),
                    TextField(
                      controller: _emailController,
                      onEditingComplete: () =>
                          FocusScope.of(context).nextFocus(),
                      onChanged: (email) =>
                          context.read<LoginBloc>().add(EmailChanged(email)),
                      autofillHints: const [
                        AutofillHints.email,
                        AutofillHints.telephoneNumber,
                      ],
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: 'Your work email',
                        border: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Color(0xffEEEEEE)),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        fillColor: Colors.white,
                        filled: true,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      onEditingComplete: () =>
                          FocusScope.of(context).nextFocus(),
                      onChanged: (password) => context
                          .read<LoginBloc>()
                          .add(PasswordChanged(password)),
                      autofillHints: const [
                        AutofillHints.password,
                      ],
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        border: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Color(0xffEEEEEE)),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        fillColor: Colors.white,
                        filled: true,
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                );
              }),
              const SizedBox(height: 24),
              GestureDetector(
                onTap: _validate,
                child: Container(
                  width: double.infinity,
                  height: 62.5,
                  decoration: BoxDecoration(
                    color: const Color(0xff6366F1),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: const Center(
                    child: Text(
                      'Continue',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
              // const SizedBox(height: 24),
              // RichText(
              //   textAlign: TextAlign.center,
              //   text: TextSpan(
              //     text: 'Don\'t know how to find your company?\n',
              //     style: Theme.of(context).textTheme.bodyLarge,
              //     children: const [
              //       TextSpan(
              //         text: 'Send a magic login link',
              //         style: TextStyle(
              //           color: Color(0xff818CF8),
              //           fontWeight: FontWeight.w600,
              //           decoration: TextDecoration.underline,
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
