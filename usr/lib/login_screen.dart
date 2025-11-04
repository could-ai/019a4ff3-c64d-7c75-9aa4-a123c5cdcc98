import 'package:flutter/material.dart';
import 'package:couldai_user_app/protected_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _passwordController = TextEditingController();
  int _attempts = 3;
  String _message = '';
  bool _isLocked = false;

  void _verifyPassword() {
    if (_isLocked) return;

    // For demonstration, the password is "123"
    if (_passwordController.text == '123') {
      setState(() {
        _message = '✔ تم التحقق بنجاح — مرحباً بك!';
        _attempts = 3; // Reset attempts on success
      });
      // Navigate to protected screen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ProtectedScreen()),
      ).then((_) {
        // Reset state when returning from protected screen
        setState(() {
          _passwordController.clear();
          _message = '';
        });
      });
    } else {
      setState(() {
        _attempts--;
        if (_attempts > 0) {
          _message = '⚠ كلمة السر خاطئة. المتبقي: $_attempts محاولة(ات).';
        } else {
          _message = 'تم استنفاد عدد المحاولات. يتم إنهاء البرنامج.';
          _isLocked = true;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تطبيق محمي'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _isLocked
                  ? 'تم قفل الدخول'
                  : 'أدخل كلمة السر (لديك $_attempts محاولات)',
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              obscureText: true,
              enabled: !_isLocked,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'كلمة السر',
              ),
              textAlign: TextAlign.right,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLocked ? null : _verifyPassword,
              child: const Text('دخول'),
            ),
            const SizedBox(height: 20),
            Text(
              _message,
              style: TextStyle(
                color: _message.startsWith('⚠') ? Colors.red : Colors.green,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
