import 'package:flutter/material.dart';

class LawsPage extends StatefulWidget {
  const LawsPage({super.key});

  @override
  State<LawsPage> createState() => _LawsPageState();
}

class _LawsPageState extends State<LawsPage> {
  final TextEditingController searchController = TextEditingController();

  final List<LawItem> allLaws = [
    const LawItem(
      title: 'ماده ۱۰ قانون مدنی',
      category: 'قانون مدنی',
      text:
      'قراردادهای خصوصی نسبت به کسانی که آن را منعقد نموده‌اند، '
          'در صورتی که مخالف صریح قانون نباشد، نافذ است.',
    ),
    const LawItem(
      title: 'ماده ۲۱۹ قانون مدنی',
      category: 'قانون مدنی',
      text:
      'عقودی که بر طبق قانون واقع شده باشد بین متعاملین و قائم‌مقام '
          'آن‌ها لازم‌الاتباع است مگر اینکه به رضای طرفین اقاله یا به '
          'علت قانونی فسخ شود.',
    ),
    const LawItem(
      title: 'ماده ۲۲۰ قانون مدنی',
      category: 'قانون مدنی',
      text:
      'عقود نه فقط متعاملین را به اجرای چیزی که در آن تصریح شده است '
          'ملزم می‌نماید بلکه متعاملین به کلیه نتایجی هم که به موجب عرف '
          'و عادت یا به موجب قانون از عقد حاصل می‌شود ملزم می‌باشند.',
    ),
    const LawItem(
      title: 'ماده ۲۲۱ قانون مدنی',
      category: 'قانون مدنی',
      text:
      'اگر کسی تعهد اقدام به امری را بکند یا تعهد نماید که از انجام '
          'امری خودداری کند، در صورت تخلف مسئول خسارت طرف مقابل است.',
    ),
    const LawItem(
      title: 'ماده ۳۰ قانون مدنی',
      category: 'قانون مدنی',
      text:
      'هر مالکی نسبت به مایملک خود حق همه گونه تصرف و انتفاع دارد '
          'مگر در مواردی که قانون استثنا کرده باشد.',
    ),
    const LawItem(
      title: 'ماده ۳۱ قانون مدنی',
      category: 'قانون مدنی',
      text:
      'هیچ مالی را از تصرف صاحب آن نمی‌توان بیرون کرد مگر به حکم قانون.',
    ),
    const LawItem(
      title: 'ماده ۱ قانون مسئولیت مدنی',
      category: 'مسئولیت مدنی',
      text:
      'هر کس بدون مجوز قانونی عمداً یا در نتیجه بی‌احتیاطی به جان یا '
          'سلامتی یا مال یا آزادی یا حیثیت یا شهرت تجارتی یا به هر حق '
          'دیگر که به موجب قانون برای افراد ایجاد گردیده لطمه‌ای وارد '
          'نماید که موجب ضرر مادی یا معنوی دیگری شود مسئول جبران خسارت '
          'ناشی از عمل خود می‌باشد.',
    ),
  ];

  List<LawItem> filteredLaws = [];

  @override
  void initState() {
    super.initState();
    filteredLaws = List.from(allLaws);
    searchController.addListener(searchLaws);
  }

  void searchLaws() {
    final query = searchController.text.trim().toLowerCase();

    setState(() {
      if (query.isEmpty) {
        filteredLaws = List.from(allLaws);
        return;
      }

      filteredLaws = allLaws.where((law) {
        return law.title.toLowerCase().contains(query) ||
            law.category.toLowerCase().contains(query) ||
            law.text.toLowerCase().contains(query);
      }).toList();
    });
  }

  void openLaw(LawItem law) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LawDetailsPage(law: law),
      ),
    );
  }

  @override
  void dispose() {
    searchController.removeListener(searchLaws);
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'بانک قوانین',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                16,
                16,
                16,
                10,
              ),
              child: TextField(
                controller: searchController,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  hintText: 'جستجوی ماده، قانون یا کلمه...',
                  prefixIcon: const Icon(
                    Icons.search,
                  ),
                  suffixIcon: searchController.text.isNotEmpty
                      ? IconButton(
                    onPressed: () {
                      searchController.clear();
                    },
                    icon: const Icon(Icons.clear),
                  )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 5,
              ),
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  '${filteredLaws.length} مورد',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 13,
                  ),
                ),
              ),
            ),

            Expanded(
              child: filteredLaws.isEmpty
                  ? _buildEmptySearch()
                  : ListView.builder(
                padding: const EdgeInsets.fromLTRB(
                  16,
                  5,
                  16,
                  20,
                ),
                itemCount: filteredLaws.length,
                itemBuilder: (context, index) {
                  final law = filteredLaws[index];

                  return Card(
                    margin: const EdgeInsets.only(
                      bottom: 10,
                    ),
                    child: ListTile(
                      contentPadding:
                      const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      leading: CircleAvatar(
                        child: const Icon(
                          Icons.menu_book_outlined,
                        ),
                      ),
                      title: Text(
                        law.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(
                          top: 6,
                        ),
                        child: Text(
                          law.category,
                        ),
                      ),
                      trailing: const Icon(
                        Icons.chevron_left,
                      ),
                      onTap: () => openLaw(law),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptySearch() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 70,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 15),
            const Text(
              'موردی پیدا نشد',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'عبارت دیگری را جستجو کنید.',
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

class LawDetailsPage extends StatelessWidget {
  final LawItem law;

  const LawDetailsPage({
    super.key,
    required this.law,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('متن قانون'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                law.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                law.category,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 25),

              Card(
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    law.text,
                    style: const TextStyle(
                      fontSize: 17,
                      height: 2,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              const Text(
                'توجه',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'متن قوانین باید در نسخه نهایی با منبع رسمی '
                    'و آخرین اصلاحات تطبیق داده شود.',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  height: 1.7,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LawItem {
  final String title;
  final String category;
  final String text;

  const LawItem({
    required this.title,
    required this.category,
    required this.text,
  });
}