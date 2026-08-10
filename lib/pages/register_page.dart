
import 'package:flutter/material.dart';
import 'api_service.dart';

class RegisterPage extends StatefulWidget {
const RegisterPage({super.key});

@override
State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
final _formKey = GlobalKey<FormState>();

final _usernameController = TextEditingController();
final _emailController = TextEditingController();
final _passwordController = TextEditingController();
final _nameController = TextEditingController();

bool _isLoading = false;
bool _obscurePassword = true;

@override
void dispose() {
_usernameController.dispose();
_emailController.dispose();
_passwordController.dispose();
_nameController.dispose();
super.dispose();
}

Future<void> _register() async {
if (!_formKey.currentState!.validate()) {
return;
}

setState(() {
_isLoading = true;
});

try {
final result = await ApiService.register(
data: {
'username': _usernameController.text.trim(),
'email': _emailController.text.trim(),
'password': _passwordController.text,
'name': _nameController.text.trim(),
},
);

if (!mounted) return;

final success =
result is Map<String, dynamic> &&
(result['status'] == true ||
result['success'] == true ||
result['user'] != null);

if (success) {
ScaffoldMessenger.of(context).showSnackBar(
const SnackBar(
content: Text(
'ثبت‌نام با موفقیت انجام شد',
),
),
);

Navigator.pop(context);
} else {
String message = 'ثبت‌نام انجام نشد';

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
} catch (_) {
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

InputDecoration _decoration({
required String label,
required IconData icon,
}) {
return InputDecoration(
labelText: label,
prefixIcon: Icon(icon),
border: OutlineInputBorder(
borderRadius: BorderRadius.circular(16),
),
);
}

@override
Widget build(BuildContext context) {
return Directionality(
textDirection: TextDirection.rtl,
child: Scaffold(
appBar: AppBar(
title: const Text(
'ثبت‌نام',
style: TextStyle(
fontWeight: FontWeight.bold,
),
),
centerTitle: true,
),
body: SafeArea(
child: SingleChildScrollView(
padding: const EdgeInsets.all(24),
child: Form(
key: _formKey,
child: Column(
crossAxisAlignment: CrossAxisAlignment.stretch,
children: [
Container(
height: 90,
decoration: BoxDecoration(
borderRadius: BorderRadius.circular(25),
color: Theme.of(context)
    .colorScheme
    .primary
    .withValues(alpha: 0.1),
),
child: Icon(
Icons.person_add_alt_1_outlined,
size: 48,
color: Theme.of(context).colorScheme.primary,
),
),

const SizedBox(height: 24),

const Text(
'ایجاد حساب کاربری',
textAlign: TextAlign.center,
style: TextStyle(
fontSize: 25,
fontWeight: FontWeight.bold,
),
),

const SizedBox(height: 8),

Text(
'برای استفاده از امکانات آنلاین، حساب خود را ایجاد کنید.',
textAlign: TextAlign.center,
style: TextStyle(
color: Colors.grey.shade600,
),
),

const SizedBox(height: 30),

TextFormField(
controller: _nameController,
decoration: _decoration(
label: 'نام و نام خانوادگی',
icon: Icons.badge_outlined,
),
validator: (value) {
if (value == null ||
value.trim().isEmpty) {
return 'نام و نام خانوادگی را وارد کنید';
}

return null;
},
),

const SizedBox(height: 16),

TextFormField(
controller: _usernameController,
textDirection: TextDirection.ltr,
decoration: _decoration(
label: 'نام کاربری',
icon: Icons.person_outline,
),
validator: (value) {
if (value == null ||
value.trim().isEmpty) {
return 'نام کاربری را وارد کنید';
}

if (value.trim().length < 3) {
return 'نام کاربری حداقل ۳ کاراکتر باشد';
}

return null;
},
),

const SizedBox(height: 16),

TextFormField(
controller: _emailController,
keyboardType: TextInputType.emailAddress,
textDirection: TextDirection.ltr,
decoration: _decoration(
label: 'ایمیل',
icon: Icons.email_outlined,
),
validator: (value) {
if (value == null ||
value.trim().isEmpty) {
return 'ایمیل را وارد کنید';
}

if (!value.contains('@')) {
return 'ایمیل معتبر وارد کنید';
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
if (value == null || value.isEmpty) {
return 'رمز عبور را وارد کنید';
}

if (value.length < 6) {
return 'رمز عبور حداقل ۶ کاراکتر باشد';
}

return null;
},
),

const SizedBox(height: 24),

SizedBox(
height: 54,
child: FilledButton.icon(
onPressed:
_isLoading ? null : _register,
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
Icons.person_add_outlined,
),
label: Text(
_isLoading
? 'در حال ثبت‌نام...'
    : 'ایجاد حساب',
),
),
),
],
),
),
),
),
),
);
}
}
