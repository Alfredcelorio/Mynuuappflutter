import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project1/authentication/blocs/authentication_bloc.dart';
import 'package:project1/authentication/components/authentication_button.dart';
import 'package:project1/authentication/components/custom_textfield.dart';
import 'package:project1/authentication/components/footer.dart';
import 'package:project1/authentication/pages/forgot_password_screen.dart';
import 'package:project1/authentication/pages/register_screen.dart';
import 'package:project1/common/components/custom_dialog.dart';
import 'package:project1/common/services/apple_sign_in_available.dart';
import 'package:project1/common/style/mynuu_colors.dart';
import 'package:project1/common/utils/utils.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late AuthenticationBLoc bloc = context.read<AuthenticationBLoc>();
  final GlobalKey<FormState> loginForm = GlobalKey<FormState>();

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  late final appleSignInAvailable = context.read<AppleSignInAvailable>();

  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    final mediaSize = MediaQuery.of(context).size;
    const value = 400;
    print(mediaSize.width);
    // TamaÃ±os ajustables de widgets
    final isIpad = (mediaSize.width < value);
    final valuePadding = mediaSize.width < value ? 0.0 : 70.0;
    return Scaffold(
        backgroundColor: mynuuBackground,
        bottomNavigationBar: SizedBox(
          height: isIpad ? 100 : 0,
          child: isIpad ? const Footer() : Container(),
        ),
        body: Padding(
          padding: EdgeInsets.all(valuePadding),
          child: Center(
            child: Form(
              key: loginForm,
              child: ListView(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 30),
                children: [
                  const SizedBox(
                    height: 36,
                  ),
                  const Center(
                      child: Text(
                    'Welcome Back!',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  )),
                  const SizedBox(
                    height: 36,
                  ),
                  if (!isIpad)
                    const Center(
                        child: Text(
                      'Lets get started',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                        color: Colors.grey,
                      ),
                    )),
                  if (!isIpad)
                    const SizedBox(
                      height: 36,
                    ),
                  if (!isIpad)
                    Container(
                      constraints: const BoxConstraints(maxWidth: 500),
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 150),
                      child: CustomTextField(
                        controller: email,
                        hintText: 'Username or Email',
                        prefixIcon: const Icon(
                          Icons.person_outline,
                          color: Colors.white,
                        ),
                        validator: (value) {
                          return validateEmail(value ?? '');
                        },
                      ),
                    ),
                  if (!isIpad)
                    Container(
                      constraints: const BoxConstraints(maxWidth: 500),
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 150),
                      child: CustomTextField(
                        controller: password,
                        hintText: 'Password',
                        prefixIcon: const Icon(
                          Icons.lock,
                          color: Colors.white,
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          },
                          icon: Icon(
                            _passwordVisible
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.white,
                          ),
                        ),
                        obscureText: !_passwordVisible,
                        validator: (value) {
                          if (value!.isEmpty) return 'Field is required';
                          return null;
                        },
                      ),
                    ),
                  if (isIpad)
                    CustomTextField(
                      controller: email,
                      hintText: 'Username or Email',
                      prefixIcon: const Icon(
                        Icons.person_outline,
                        color: Colors.white,
                      ),
                      validator: (value) {
                        return validateEmail(value ?? '');
                      },
                    ),
                  const SizedBox(
                    height: 30,
                  ),
                  if (isIpad)
                    CustomTextField(
                      controller: password,
                      hintText: 'Password',
                      prefixIcon: const Icon(
                        Icons.lock,
                        color: Colors.white,
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        },
                        icon: Icon(
                          _passwordVisible
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.white,
                        ),
                      ),
                      obscureText: !_passwordVisible,
                      validator: (value) {
                        if (value!.isEmpty) return 'Field is required';
                        return null;
                      },
                    ),
                  const SizedBox(
                    height: 15,
                  ),
                  if (isIpad)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Provider.value(
                                  value: bloc,
                                  child: const RegisterScreen(),
                                ),
                              ),
                            );
                          },
                          child: const Text(
                            'Register',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Provider.value(
                                  value: bloc,
                                  child: const ForgotPasswordScreen(),
                                ),
                              ),
                            );
                          },
                          child: const Text(
                            'Forgot password?',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        )
                      ],
                    ),
                  const SizedBox(height: 55),
                  Row(
                    mainAxisAlignment: isIpad
                        ? MainAxisAlignment.spaceBetween
                        : MainAxisAlignment.spaceEvenly,
                    children: [
                      const Text(
                        'Sign in',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      AuthenticationButton(
                        loadingListenable: bloc.loading,
                        action: () {
                          if (loginForm.currentState!.validate()) {
                            _signInWithEmailAndPassword(context);
                          }
                        },
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  if (isIpad)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            const Text(
                              'Sign in with',
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () => _signInWithGoogle(context),
                                  child: Image.asset(
                                    'assets/google_round_sign_in.png',
                                    width: 50,
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                if (appleSignInAvailable.isAvailable)
                                  GestureDetector(
                                    onTap: () => _signInWithApple(context),
                                    child: Image.asset(
                                      'assets/apple.png',
                                      width: 50,
                                    ),
                                  ),
                              ],
                            )
                          ],
                        ),
                      ],
                    )
                ],
              ),
            ),
          ),
        ));
  }

  Future<void> _signInWithEmailAndPassword(BuildContext context) async {
    try {
      await bloc.signInWithEmailAndPassword(email.text, password.text);
    } on PlatformException catch (e) {
      await _showSignInError(context, e.message);
    } catch (e) {
      await _showSignInError(
        context,
        e.toString(),
      );
    }
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      await bloc.signInWithGoogle();
      Navigator.pop(context);
    } on PlatformException catch (e) {
      await _showSignInError(context, e.message);
    } catch (e) {
      await _showSignInError(
        context,
        e.toString(),
      );
    }
  }

  Future<void> _signInWithApple(BuildContext context) async {
    try {
      await bloc.signInWithApple();
      Navigator.pop(context);
    } on PlatformException catch (e) {
      await _showSignInError(context, e.message);
    } catch (e) {
      await _showSignInError(
        context,
        e.toString(),
      );
    }
  }

  Future<void> _showSignInError(BuildContext context, String? message) async {
    await PlatformAlertDialog(
            content: message?.replaceAll('firebase_auth/', '') ??
                'There was an error, try it later!',
            title: 'Login failed',
            defaultActionText: 'Ok')
        .show(context);
  }
}
