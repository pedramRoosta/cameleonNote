import 'package:cameleon_note/helpers/dialog.dart';
import 'package:cameleon_note/services/auth/auth_service.dart';
import 'package:cameleon_note/services/auth/auth_exceptions.dart';
import 'package:cameleon_note/services/router/nav_service.dart';
import 'package:cameleon_note/services/router/routes.dart';
import 'package:cameleon_note/setup.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

@injectable
class LoginScreen extends StatefulWidget {
  const LoginScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController _emailCtrl;
  late TextEditingController _passwordCtrl;
  late INavService _navService;
  late IAuthService _authService;
  @override
  void initState() {
    super.initState();
    _emailCtrl = TextEditingController();
    _passwordCtrl = TextEditingController();
    _navService = locateService<INavService>();
    _authService = locateService<IAuthService>();
  }

  @override
  Widget build(BuildContext context) {
    _emailCtrl.text = 'pedram.post@gmail.com';
    _passwordCtrl.text = 'wwwwww';
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login to your account'),
      ),
      body: Container(
        padding: const EdgeInsets.all(50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.all(5),
              child: TextField(
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                  hintText: "Your email",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                controller: _emailCtrl,
              ),
            ),
            Container(
              margin: const EdgeInsets.all(5),
              child: TextField(
                obscureText: true,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                  hintText: "Your password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                controller: _passwordCtrl,
              ),
            ),
            TextButton(
              onPressed: () async {
                final email = _emailCtrl.text;
                final password = _passwordCtrl.text;
                if (email.isNotEmpty && password.isNotEmpty) {
                  try {
                    await _authService.loginWithEmailandPassword(
                      email: email,
                      password: password,
                    );
                    if (_authService.currentUser != null) {
                      _navService.pushAndPopUntil(route: HomeRoute());
                    }
                  } on InvalidEmailAuthException catch (_) {
                    showAppDialog(message: 'Invalid email is provided!');
                  } on UserNotFoundAuthException catch (_) {
                    showAppDialog(message: 'User not found!');
                  } on GeneralAuthException catch (_) {
                    showAppDialog(
                        message:
                            'Network error occurs, please try again later.');
                  } catch (e) {
                    showAppDialog(message: e.toString());
                  }
                }
              },
              child: const Text('log in'),
            ),
            TextButton(
              onPressed: () async {
                _navService.push(route: const RegisterRoute());
              },
              child: const Text('Not yet registered? Register here.'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
  }
}
