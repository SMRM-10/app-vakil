import 'package:flutter/material.dart';

class DiyehPage extends StatefulWidget {
  const DiyehPage({super.key});

  @override
  State<DiyehPage> createState() => _DiyehPageState();
}

class _DiyehPageState extends State<DiyehPage> {
  int selectedYear = 1405;
  String selectedType = 'دیه کامل';

  final List<int> years = List.generate(
    76,
        (index) => 1350 + index,
  );

  final List<String> types = [
    'دیه کامل',
    'دیه اعضای بدن',
    'دیه جراحات',
    'ارش',
  ];

  double? result;

  void calculateDiyeh() {
    // فعلاً مقدار آزمایشی است.
    // در مرحله بعد جدول مبالغ رسمی سالانه اضافه می‌شود.

    const temporaryAmount = 1000000000.0;

    setState(() {
      result = temporaryAmount;
    });
  }

  void clearForm() {
    setState(() {
      selectedYear = 1405;
      selectedType = 'دیه کامل';
      result = null;
    });
  }

  String formatNumber(double number) {
    return number
        .round()
        .toString()
        .replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (match) => '${match.group(1)},',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'محاسبه دیه',
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
                _buildInfoCard(),

                const SizedBox(height: 22),

                const Text(
                  'اطلاعات دیه',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 15),

                DropdownButtonFormField<int>(
                  initialValue: selectedYear,
                  decoration: const InputDecoration(
                    labelText: 'سال دیه',
                    prefixIcon: Icon(
                      Icons.calendar_month_outlined,
                    ),
                    border: OutlineInputBorder(),
                  ),
                  items: years.map((year) {
                    return DropdownMenuItem<int>(
                      value: year,
                      child: Text(year.toString()),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value == null) return;

                    setState(() {
                      selectedYear = value;
                    });
                  },
                ),

                const SizedBox(height: 15),

                DropdownButtonFormField<String>(
                  initialValue: selectedType,
                  decoration: const InputDecoration(
                    labelText: 'نوع محاسبه',
                    prefixIcon: Icon(
                      Icons.category_outlined,
                    ),
                    border: OutlineInputBorder(),
                  ),
                  items: types.map((type) {
                    return DropdownMenuItem<String>(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value == null) return;

                    setState(() {
                      selectedType = value;
                    });
                  },
                ),

                const SizedBox(height: 22),

                Row(
                  children: [
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: calculateDiyeh,
                        icon: const Icon(
                          Icons.calculate_outlined,
                        ),
                        label: const Text('محاسبه'),
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            vertical: 15,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    OutlinedButton(
                      onPressed: clearForm,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: 15,
                          horizontal: 18,
                        ),
                      ),
                      child: const Icon(Icons.refresh),
                    ),
                  ],
                ),

                const SizedBox(height: 25),

                if (result != null) _buildResultCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Theme.of(context)
            .colorScheme
            .primary
            .withValues(alpha: 0.08),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline,
            size: 28,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'سال و نوع دیه را انتخاب کنید تا مبلغ مربوط به آن محاسبه شود.',
              style: TextStyle(
                fontSize: 14,
                height: 1.7,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultCard() {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Icon(
              Icons.check_circle_outline,
              size: 45,
            ),

            const SizedBox(height: 12),

            const Text(
              'نتیجه محاسبه',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            Text(
              '${formatNumber(result!)} تومان',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 27,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              'سال: $selectedYear',
              style: TextStyle(
                color: Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 5),

            Text(
              'نوع: $selectedType',
              style: TextStyle(
                color: Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 15),

            const Text(
              'مبلغ نمایش داده‌شده فعلاً آزمایشی است و پس از تکمیل جدول مبالغ قانونی جایگزین خواهد شد.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}