import 'package:flutter/material.dart';
import 'api_service.dart';
import 'login_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isLoading = true;
  bool _isUpdating = false;

  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _usernameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final result = await ApiService.getProfile();

      if (!mounted) return;

      if (result is Map<String, dynamic>) {
        dynamic profileData =
            result['user'] ??
                result['profile'] ??
                result['data'] ??
                result;

        if (profileData is Map<String, dynamic>) {
          _nameController.text =
              (profileData['name'] ??
                  profileData['display_name'] ??
                  '')
                  .toString();

          _emailController.text =
              (profileData['email'] ?? '').toString();

          _usernameController.text =
              (profileData['username'] ??
                  profileData['user_login'] ??
                  '')
                  .toString();

          _phoneController.text =
              (profileData['phone'] ??
                  profileData['mobile'] ??
                  '')
                  .toString();
        }
      }
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'خطا در دریافت اطلاعات پروفایل',
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

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isUpdating = true;
    });

    try {
      final result = await ApiService.updateProfile(
        data: {
          'name': _nameController.text.trim(),
          'email': _emailController.text.trim(),
          'phone': _phoneController.text.trim(),
        },
      );

      if (!mounted) return;

      final success =
          result is Map<String, dynamic> &&
              (result['status'] == true ||
                  result['success'] == true);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'اطلاعات پروفایل با موفقیت بروزرسانی شد',
            ),
          ),
        );

        await _loadProfile();
      } else {
        String message = 'بروزرسانی اطلاعات انجام نشد';

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
            'خطا در ارتباط با سرور',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isUpdating = false;
        });
      }
    }
  }

  Future<void> _logout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: const Text('خروج از حساب'),
            content: const Text(
              'آیا مطمئن هستید که می‌خواهید از حساب خود خارج شوید؟',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: const Text('انصراف'),
              ),
              FilledButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child: const Text('خروج'),
              ),
            ],
          ),
        );
      },
    );

    if (shouldLogout != true) {
      return;
    }

    try {
      await ApiService.logout();
    } catch (_) {
      ApiService.clearToken();
    }

    ApiService.clearToken();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const LoginPage(),
      ),
          (route) => false,
    );
  }

  Future<void> _deleteAccount() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: const Text('حذف حساب کاربری'),
            content: const Text(
              'این عملیات قابل بازگشت نیست. آیا از حذف حساب خود مطمئن هستید؟',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: const Text('انصراف'),
              ),
              FilledButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child: const Text('حذف حساب'),
              ),
            ],
          ),
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    try {
      final result = await ApiService.deleteAccount();

      if (!mounted) return;

      final success =
          result is Map<String, dynamic> &&
              (result['status'] == true ||
                  result['success'] == true);

      if (success) {
        ApiService.clearToken();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'حساب کاربری حذف شد',
            ),
          ),
        );

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => const LoginPage(),
          ),
              (route) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'حذف حساب انجام نشد',
            ),
          ),
        );
      }
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'خطا در ارتباط با سرور',
          ),
        ),
      );
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
            'پروفایل کاربری',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: _isLoading
              ? const Center(
            child: CircularProgressIndicator(),
          )
              : SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _buildProfileHeader(),

                const SizedBox(height: 24),

                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: _decoration(
                          label: 'نام و نام خانوادگی',
                          icon: Icons.badge_outlined,
                        ),
                      ),

                      const SizedBox(height: 16),

                      TextFormField(
                        controller: _usernameController,
                        readOnly: true,
                        textDirection: TextDirection.ltr,
                        decoration: _decoration(
                          label: 'نام کاربری',
                          icon: Icons.person_outline,
                        ),
                      ),

                      const SizedBox(height: 16),

                      TextFormField(
                        controller: _emailController,
                        keyboardType:
                        TextInputType.emailAddress,
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
                        controller: _phoneController,
                        keyboardType:
                        TextInputType.phone,
                        textDirection: TextDirection.ltr,
                        decoration: _decoration(
                          label: 'شماره موبایل',
                          icon: Icons.phone_outlined,
                        ),
                      ),

                      const SizedBox(height: 24),

                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: FilledButton.icon(
                          onPressed: _isUpdating
                              ? null
                              : _updateProfile,
                          icon: _isUpdating
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
                            Icons.save_outlined,
                          ),
                          label: Text(
                            _isUpdating
                                ? 'در حال ذخیره...'
                                : 'ذخیره تغییرات',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                _buildDangerSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    final name = _nameController.text.trim();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF0F3577),
            Color(0xFF173F86),
          ],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 42,
            backgroundColor:
            Colors.white.withValues(alpha: 0.15),
            child: const Icon(
              Icons.person_outline,
              size: 48,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 14),

          Text(
            name.isEmpty
                ? 'کاربر وکیلت آنلاین'
                : name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 21,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 6),

          Text(
            _usernameController.text.isEmpty
                ? 'حساب کاربری'
                : '@${_usernameController.text}',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
            textDirection: TextDirection.ltr,
          ),
        ],
      ),
    );
  }

  Widget _buildDangerSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'مدیریت حساب',
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 12),

        Card(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('خروج از حساب'),
                subtitle: const Text(
                  'خروج از حساب کاربری فعلی',
                ),
                onTap: _logout,
              ),

              const Divider(height: 1),

              ListTile(
                leading: const Icon(
                  Icons.delete_outline,
                ),
                title: const Text(
                  'حذف حساب کاربری',
                ),
                subtitle: const Text(
                  'حذف دائمی حساب و اطلاعات کاربری',
                ),
                onTap: _deleteAccount,
              ),
            ],
          ),
        ),
      ],
    );
  }
}