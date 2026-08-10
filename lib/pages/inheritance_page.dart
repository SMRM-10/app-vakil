import 'package:flutter/material.dart';

class InheritancePage extends StatefulWidget {
  const InheritancePage({super.key});

  @override
  State<InheritancePage> createState() => _InheritancePageState();
}

class _InheritancePageState extends State<InheritancePage> {
  final TextEditingController estateController = TextEditingController();

  bool hasSpouse = false;
  bool hasFather = false;
  bool hasMother = false;
  bool hasSon = false;
  bool hasDaughter = false;

  String spouseType = 'همسر';

  double? estateAmount;

  @override
  void dispose() {
    estateController.dispose();
    super.dispose();
  }

  void calculateInheritance() {
    final text = estateController.text
        .replaceAll(',', '')
        .replaceAll('٬', '')
        .replaceAll(' ', '');

    final amount = double.tryParse(text);

    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('لطفاً مبلغ ترکه را به‌درستی وارد کنید.'),
        ),
      );
      return;
    }

    setState(() {
      estateAmount = amount;
    });
  }

  void clearForm() {
    setState(() {
      estateController.clear();

      hasSpouse = false;
      hasFather = false;
      hasMother = false;
      hasSon = false;
      hasDaughter = false;

      spouseType = 'همسر';
      estateAmount = null;
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
            'محاسبه ارث',
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
                  'مبلغ ترکه',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 15),

                TextField(
                  controller: estateController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'ارزش خالص ترکه',
                    hintText: 'مثلاً 2000000000',
                    prefixIcon: Icon(
                      Icons.account_balance_wallet_outlined,
                    ),
                    suffixText: 'تومان',
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 25),

                const Text(
                  'وراث',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                _buildHeirSwitch(
                  title: 'همسر',
                  subtitle: 'وجود همسر متوفی',
                  value: hasSpouse,
                  onChanged: (value) {
                    setState(() {
                      hasSpouse = value;
                    });
                  },
                ),

                if (hasSpouse)
                  Padding(
                    padding: const EdgeInsets.only(
                      right: 16,
                      bottom: 8,
                    ),
                    child: DropdownButtonFormField<String>(
                      initialValue: spouseType,
                      decoration: const InputDecoration(
                        labelText: 'نوع همسر',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'همسر',
                          child: Text('همسر'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value == null) return;

                        setState(() {
                          spouseType = value;
                        });
                      },
                    ),
                  ),

                _buildHeirSwitch(
                  title: 'پدر',
                  subtitle: 'پدر متوفی در قید حیات است',
                  value: hasFather,
                  onChanged: (value) {
                    setState(() {
                      hasFather = value;
                    });
                  },
                ),

                _buildHeirSwitch(
                  title: 'مادر',
                  subtitle: 'مادر متوفی در قید حیات است',
                  value: hasMother,
                  onChanged: (value) {
                    setState(() {
                      hasMother = value;
                    });
                  },
                ),

                _buildHeirSwitch(
                  title: 'پسر',
                  subtitle: 'وجود فرزند پسر',
                  value: hasSon,
                  onChanged: (value) {
                    setState(() {
                      hasSon = value;
                    });
                  },
                ),

                _buildHeirSwitch(
                  title: 'دختر',
                  subtitle: 'وجود فرزند دختر',
                  value: hasDaughter,
                  onChanged: (value) {
                    setState(() {
                      hasDaughter = value;
                    });
                  },
                ),

                const SizedBox(height: 20),

                Row(
                  children: [
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: calculateInheritance,
                        icon: const Icon(
                          Icons.calculate_outlined,
                        ),
                        label: const Text('محاسبه ارث'),
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

                if (estateAmount != null) _buildResultCard(),
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
              'مبلغ خالص ترکه و وضعیت وراث را وارد کنید. '
                  'ساختار محاسبه در مراحل بعدی بر اساس قواعد قانونی تکمیل می‌شود.',
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

  Widget _buildHeirSwitch({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      child: SwitchListTile(
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(subtitle),
        value: value,
        onChanged: onChanged,
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
              Icons.account_balance_outlined,
              size: 45,
            ),

            const SizedBox(height: 12),

            const Text(
              'نتیجه اولیه',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            Text(
              '${formatNumber(estateAmount!)} تومان',
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            const Text(
              'اطلاعات وراث ثبت شد. '
                  'فرمول دقیق تقسیم سهم هر وارث در مرحله تکمیل موتور محاسبه ارث اضافه می‌شود.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                height: 1.7,
              ),
            ),
          ],
        ),
      ),
    );
  }
}