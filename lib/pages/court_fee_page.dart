import 'package:flutter/material.dart';

class CourtFeePage extends StatefulWidget {
  const CourtFeePage({super.key});

  @override
  State<CourtFeePage> createState() => _CourtFeePageState();
}

class _CourtFeePageState extends State<CourtFeePage> {
  final TextEditingController amountController = TextEditingController();

  String selectedType = 'دعاوی مالی';
  String selectedStage = 'بدوی';

  double? result;

  final List<String> types = [
    'دعاوی مالی',
    'دعاوی غیرمالی',
    'اعتراض به رأی',
    'تجدیدنظر',
    'فرجام‌خواهی',
  ];

  final List<String> stages = [
    'بدوی',
    'تجدیدنظر',
    'فرجام‌خواهی',
  ];

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }

  void calculateFee() {
    final text = amountController.text
        .replaceAll(',', '')
        .replaceAll('٬', '')
        .replaceAll(' ', '');

    final amount = double.tryParse(text);

    if (selectedType == 'دعاوی مالی' &&
        (amount == null || amount <= 0)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'برای دعوای مالی مبلغ خواسته را وارد کنید.',
          ),
        ),
      );
      return;
    }

    double fee = 0;

    // مقدار فعلی صرفاً آزمایشی است.
    // جدول رسمی هزینه دادرسی در مرحله بعد اضافه می‌شود.
    if (selectedType == 'دعاوی مالی') {
      fee = (amount ?? 0) * 0.035;
    } else {
      fee = 500000;
    }

    setState(() {
      result = fee;
    });
  }

  void clearForm() {
    setState(() {
      amountController.clear();
      selectedType = 'دعاوی مالی';
      selectedStage = 'بدوی';
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
            'هزینه دادرسی',
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
                  'نوع دعوا',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 15),

                DropdownButtonFormField<String>(
                  initialValue: selectedType,
                  decoration: const InputDecoration(
                    labelText: 'نوع دعوا',
                    prefixIcon: Icon(
                      Icons.gavel_outlined,
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

                const SizedBox(height: 15),

                DropdownButtonFormField<String>(
                  initialValue: selectedStage,
                  decoration: const InputDecoration(
                    labelText: 'مرحله رسیدگی',
                    prefixIcon: Icon(
                      Icons.account_balance_outlined,
                    ),
                    border: OutlineInputBorder(),
                  ),
                  items: stages.map((stage) {
                    return DropdownMenuItem<String>(
                      value: stage,
                      child: Text(stage),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value == null) return;

                    setState(() {
                      selectedStage = value;
                    });
                  },
                ),

                const SizedBox(height: 15),

                if (selectedType == 'دعاوی مالی')
                  TextField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'مبلغ خواسته',
                      hintText: 'مثلاً 500000000',
                      prefixIcon: Icon(
                        Icons.payments_outlined,
                      ),
                      suffixText: 'تومان',
                      border: OutlineInputBorder(),
                    ),
                  ),

                const SizedBox(height: 22),

                Row(
                  children: [
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: calculateFee,
                        icon: const Icon(
                          Icons.calculate_outlined,
                        ),
                        label: const Text(
                          'محاسبه هزینه',
                        ),
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
              'نوع دعوا و مرحله رسیدگی را انتخاب کنید. '
                  'در دعاوی مالی، مبلغ خواسته نیز باید وارد شود.',
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
              Icons.receipt_long_outlined,
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
              'نوع دعوا: $selectedType',
              style: TextStyle(
                color: Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 5),

            Text(
              'مرحله: $selectedStage',
              style: TextStyle(
                color: Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 15),

            const Text(
              'مبلغ فعلی آزمایشی است و جدول رسمی هزینه‌های دادرسی '
                  'در نسخه نهایی جایگزین خواهد شد.',
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