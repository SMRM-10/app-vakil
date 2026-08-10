import 'package:flutter/material.dart';

class MahrPage extends StatefulWidget {
  const MahrPage({super.key});

  @override
  State<MahrPage> createState() => _MahrPageState();
}

class _MahrPageState extends State<MahrPage> {
  final TextEditingController amountController = TextEditingController();

  int selectedYear = 1400;

  final List<int> years = List.generate(
    76,
        (index) => 1350 + index,
  );

  String selectedUnit = 'تومان';

  double? result;

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }

  void calculateMahr() {
    final amountText = amountController.text
        .replaceAll(',', '')
        .replaceAll('٬', '')
        .replaceAll(' ', '');

    final amount = double.tryParse(amountText);

    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('لطفاً مبلغ مهریه را به‌درستی وارد کنید.'),
        ),
      );
      return;
    }

    /*
      فعلاً ضریب آزمایشی است.

      در مرحله بعد جدول شاخص‌های رسمی سالانه
      را به این قسمت متصل می‌کنیم.
    */

    const double temporaryIndex = 1.0;

    setState(() {
      result = amount * temporaryIndex;
    });
  }

  void clearForm() {
    setState(() {
      amountController.clear();
      result = null;
      selectedYear = 1400;
      selectedUnit = 'تومان';
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
            'محاسبه مهریه',
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

                const SizedBox(height: 20),

                const Text(
                  'اطلاعات مهریه',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 15),

                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'مبلغ مهریه',
                    hintText: 'مثلاً 500000000',
                    prefixIcon: Icon(Icons.payments_outlined),
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 15),

                DropdownButtonFormField<String>(
                  initialValue: selectedUnit,
                  decoration: const InputDecoration(
                    labelText: 'واحد مبلغ',
                    prefixIcon: Icon(Icons.currency_exchange),
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'تومان',
                      child: Text('تومان'),
                    ),
                    DropdownMenuItem(
                      value: 'ریال',
                      child: Text('ریال'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value == null) return;

                    setState(() {
                      selectedUnit = value;
                    });
                  },
                ),

                const SizedBox(height: 15),

                DropdownButtonFormField<int>(
                  initialValue: selectedYear,
                  decoration: const InputDecoration(
                    labelText: 'سال عقد',
                    prefixIcon: Icon(Icons.calendar_month_outlined),
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

                const SizedBox(height: 22),

                Row(
                  children: [
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: calculateMahr,
                        icon: const Icon(Icons.calculate_outlined),
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
              'برای محاسبه ارزش روز مهریه، مبلغ مهریه و سال عقد را وارد کنید.',
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
              '${formatNumber(result!)} $selectedUnit',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 27,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              'سال عقد: $selectedYear',
              style: TextStyle(
                color: Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 15),

            const Text(
              'این نتیجه در حال حاضر آزمایشی است و در مرحله بعد با شاخص‌های رسمی تکمیل می‌شود.',
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