import 'package:flutter/material.dart';
import 'mahr_page.dart';
import 'diyeh_page.dart';
import 'inheritance_page.dart';
import 'court_fee_page.dart';
import 'documents_page.dart';
import 'laws_page.dart';
import 'consultation_page.dart';
import 'contact_page.dart';


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'وکیلت آنلاین',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildWelcomeCard(),

                const SizedBox(height: 24),

                const Text(
                  'خدمات حقوقی',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 14),

                _MenuCard(
                  icon: Icons.calculate_outlined,
                  title: 'محاسبه مهریه',
                  subtitle: 'محاسبه ارزش روز مهریه',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MahrPage(),
                      ),
                    );
                  },
                ),

                _MenuCard(
                  icon: Icons.balance_outlined,
                  title: 'محاسبه دیه',
                  subtitle: 'محاسبه مبلغ دیه و ارش',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DiyehPage(),
                      ),
                    );
                  },
                ),

                _MenuCard(
                  icon: Icons.family_restroom_outlined,
                  title: 'محاسبه ارث',
                  subtitle: 'محاسبه سهم وراث',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const InheritancePage(),
                      ),
                    );
                  },
                ),

                _MenuCard(
                  icon: Icons.receipt_long_outlined,
                  title: 'هزینه دادرسی',
                  subtitle: 'محاسبه هزینه رسیدگی پرونده',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CourtFeePage(),
                      ),
                    );
                  },
                ),

                _MenuCard(
                  icon: Icons.folder_copy_outlined,
                  title: 'کیف مدارک',
                  subtitle: 'مدیریت و نگهداری مدارک',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DocumentsPage(),
                      ),
                    );
                  },
                ),

                _MenuCard(
                  icon: Icons.menu_book_outlined,
                  title: 'بانک قوانین',
                  subtitle: 'جستجو در قوانین و مقررات',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LawsPage(),
                      ),
                    );
                  },
                ),

                _MenuCard(
                  icon: Icons.support_agent_outlined,
                  title: 'درخواست مشاوره',
                  subtitle: 'ثبت درخواست مشاوره حقوقی',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ConsultationPage(),
                      ),
                    );
                  },
                ),

                _MenuCard(
                  icon: Icons.contact_support_outlined,
                  title: 'ارتباط با ما',
                  subtitle: 'راه‌های ارتباطی و شبکه‌های اجتماعی',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ContactPage(),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 20),

                _buildAboutCard(),

                const SizedBox(height: 20),

                _buildAboutCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF0F3577),
            Color(0xFF173F86),
          ],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'وکیلت آنلاین',
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'ابزارهای کاربردی حقوقی، همیشه همراه شما',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            const Icon(
              Icons.gavel,
              size: 42,
            ),
            const SizedBox(height: 10),
            const Text(
              'وکیلت آنلاین',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'ابزارهای حقوقی و محاسبات کاربردی',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _MenuCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: Theme.of(context)
                      .colorScheme
                      .primary
                      .withValues(alpha: 0.1),
                ),
                child: Icon(
                  icon,
                  size: 28,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),

              const SizedBox(width: 15),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),

              const Icon(
                Icons.arrow_back_ios_new,
                size: 17,
              ),
            ],
          ),
        ),
      ),
    );
  }
}