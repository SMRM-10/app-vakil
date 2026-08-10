import 'package:flutter/material.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
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
            'ارتباط با ما',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            _buildHeader(),

            const SizedBox(height: 25),

            const Text(
              'راه‌های ارتباطی',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            _ContactCard(
              icon: Icons.language,
              title: 'وب‌سایت',
              subtitle: 'vakiletonline.ir',
              onTap: () {
                _showMessage(
                  context,
                  'لینک وب‌سایت در نسخه نهایی فعال می‌شود.',
                );
              },
            ),

            _ContactCard(
              icon: Icons.phone_outlined,
              title: 'تماس با ما',
              subtitle: 'پشتیبانی و ارتباط مستقیم',
              onTap: () {
                _showMessage(
                  context,
                  'شماره تماس در نسخه نهایی اضافه می‌شود.',
                );
              },
            ),

            const SizedBox(height: 20),

            const Text(
              'شبکه‌های اجتماعی',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            _ContactCard(
              icon: Icons.send_outlined,
              title: 'تلگرام',
              subtitle: 'کانال و پشتیبانی تلگرام',
              onTap: () {
                _showMessage(
                  context,
                  'لینک تلگرام در نسخه نهایی فعال می‌شود.',
                );
              },
            ),

            _ContactCard(
              icon: Icons.camera_alt_outlined,
              title: 'اینستاگرام',
              subtitle: 'صفحه رسمی وکیلت آنلاین',
              onTap: () {
                _showMessage(
                  context,
                  'لینک اینستاگرام در نسخه نهایی فعال می‌شود.',
                );
              },
            ),

            _ContactCard(
              icon: Icons.chat_bubble_outline,
              title: 'واتساپ',
              subtitle: 'ارتباط از طریق واتساپ',
              onTap: () {
                _showMessage(
                  context,
                  'لینک واتساپ در نسخه نهایی فعال می‌شود.',
                );
              },
            ),

            _ContactCard(
              icon: Icons.forum_outlined,
              title: 'روبیکا',
              subtitle: 'صفحه وکیلت آنلاین در روبیکا',
              onTap: () {
                _showMessage(
                  context,
                  'لینک روبیکا در نسخه نهایی فعال می‌شود.',
                );
              },
            ),

            _ContactCard(
              icon: Icons.message_outlined,
              title: 'ایتا',
              subtitle: 'ارتباط در پیام‌رسان ایتا',
              onTap: () {
                _showMessage(
                  context,
                  'لینک ایتا در نسخه نهایی فعال می‌شود.',
                );
              },
            ),

            _ContactCard(
              icon: Icons.forum_outlined,
              title: 'بله',
              subtitle: 'ارتباط در پیام‌رسان بله',
              onTap: () {
                _showMessage(
                  context,
                  'لینک بله در نسخه نهایی فعال می‌شود.',
                );
              },
            ),

            _ContactCard(
              icon: Icons.chat_outlined,
              title: 'سروش',
              subtitle: 'ارتباط در پیام‌رسان سروش',
              onTap: () {
                _showMessage(
                  context,
                  'لینک سروش در نسخه نهایی فعال می‌شود.',
                );
              },
            ),

            const SizedBox(height: 25),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  children: [
                    const Icon(
                      Icons.security_outlined,
                      size: 42,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'وکیلت آنلاین',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'مرجع ابزارها و خدمات حقوقی',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CircleAvatar(
              radius: 38,
              child: const Icon(
                Icons.support_agent_outlined,
                size: 42,
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              'ارتباط با وکیلت آنلاین',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'برای دریافت اطلاعات بیشتر یا ارتباط با مجموعه '
                  'می‌توانید از راه‌های ارتباطی زیر استفاده کنید.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade600,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContactCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ContactCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 7,
        ),
        leading: CircleAvatar(
          child: Icon(icon),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text(subtitle),
        ),
        trailing: const Icon(
          Icons.chevron_left,
        ),
        onTap: onTap,
      ),
    );
  }
}