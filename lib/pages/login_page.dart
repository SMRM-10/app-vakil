import 'package:flutter/material.dart';
import 'api_service.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
const LoginPage({super.key});

@override
State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
final _formKey = GlobalKey<FormState>();

final TextEditingController _usernameController =
TextEditingController();

final TextEditingController _passwordController =
TextEditingController();

bool _isLoading = false;
bool _obscurePassword = true;

@override
void dispose() {
_usernameController.dispose();
_passwordController.dispose();
super.dispose();
}

Future<void> _login() async {
if (!_formKey.currentState!.validate()) {
return;
}

setState(() {
_isLoading = true;
});

try {
final result = await ApiService.login(
data: {
'username': _usernameController.text.trim(),
'password': _passwordController.text,
},
);

if (!mounted) return;

final success =
result is Map<String, dynamic> &&
(result['status'] == true ||
result['success'] == true ||
result['token'] != null ||
result['access_token'] != null);

if (success) {
ScaffoldMessenger.of(context).showSnackBar(
const SnackBar(
content: Text('ورود با موفقیت انجام شد'),
),
);

Navigator.pushAndRemoveUntil(
context,
MaterialPageRoute(
builder: (_) => const HomePage(),
),
(route) => false,
);
} else {
String message = 'ورود ناموفق بود';

if (result is Map<String, dynamic>) {
final serverMessage =
result['message'] ??
result['error'] ??
result['msg'];

if (serverMessage != null &&
serverMessage.toString().trim().isNotEmpty) {
message = serverMessage.toString();
}
}

ScaffoldMessenger.of(context).showSnackBar(
SnackBar(
content: Text(message),
),
);
}
} catch (e) {
if (!mounted) return;

ScaffoldMessenger.of(context).showSnackBar(
const SnackBar(
content: Text(
'خطا در ارتباط با سرور. لطفاً دوباره تلاش کنید.',
),
),
);
} finally {
if (mounted) {
setState(() {
_isLoading = false;
});
}
}
}

@override
Widget build(BuildContext context) {
return Directionality(
textDirection: TextDirection.rtl,
child: Scaffold(
appBar: AppBar(
title: const Text(
'ورود به حساب',
style: TextStyle(
fontWeight: FontWeight.bold,
),
),
centerTitle: true,
),
body: SafeArea(
child: Center(
child: SingleChildScrollView(
padding: const EdgeInsets.all(24),
child: Form(
key: _formKey,
child: Column(
crossAxisAlignment: CrossAxisAlignment.stretch,
children: [
Container(
width: 90,
height: 90,
decoration: BoxDecoration(
borderRadius: BorderRadius.circular(25),
color: Theme.of(context)
    .colorScheme
    .primary
    .withValues(alpha: 0.1),
),
child: Icon(
Icons.account_balance_outlined,
size: 48,
color: Theme.of(context).colorScheme.primary,
),
),

const SizedBox(height: 24),

const Text(
'خوش آمدید',
textAlign: TextAlign.center,
style: TextStyle(
fontSize: 25,
fontWeight: FontWeight.bold,
),
),

const SizedBox(height: 8),

Text(
'برای ورود به حساب کاربری اطلاعات خود را وارد کنید.',
textAlign: TextAlign.center,
style: TextStyle(
color: Colors.grey.shade600,
),
),

const SizedBox(height: 30),

TextFormField(
controller: _usernameController,
textDirection: TextDirection.ltr,
decoration: InputDecoration(
labelText: 'نام کاربری',
hintText: 'نام کاربری خود را وارد کنید',
prefixIcon: const Icon(
Icons.person_outline,
),
border: OutlineInputBorder(
borderRadius: BorderRadius.circular(16),
),
),
validator: (value) {
if (value == null ||
value.trim().isEmpty) {
return 'نام کاربری را وارد کنید';
}

return null;
},
),

const SizedBox(height: 16),

TextFormField(
controller: _passwordController,
obscureText: _obscurePassword,
decoration: InputDecoration(
labelText: 'رمز عبور',
hintText: 'رمز عبور خود را وارد کنید',
prefixIcon: const Icon(
Icons.lock_outline,
),
suffixIcon: IconButton(
onPressed: () {
setState(() {
_obscurePassword =
!_obscurePassword;
});
},
icon: Icon(
_obscurePassword
? Icons.visibility_outlined
    : Icons.visibility_off_outlined,
),
),
border: OutlineInputBorder(
borderRadius: BorderRadius.circular(16),
),
),
validator: (value) {
if (value == null ||
value.isEmpty) {
return 'رمز عبور را وارد کنید';
}

return null;
},
),

const SizedBox(height: 24),

SizedBox(
height: 54,
child: FilledButton.icon(
onPressed: _isLoading ? null : _login,
icon: _isLoading
? const SizedBox(
width: 20,
height: 20,
child:
CircularProgressIndicator(
strokeWidth: 2,
color: Colors.white,
),
)
    : const Icon(
Icons.login,
),
label: Text(
_isLoading
? 'در حال ورود...'
    : 'ورود به حساب',
),
),
),
],
),
),
),
),
),
),
);
}
}
