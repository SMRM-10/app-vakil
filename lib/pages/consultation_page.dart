import 'package:flutter/material.dart';

class ConsultationPage extends StatefulWidget {
  const ConsultationPage({super.key});

  @override
  State<ConsultationPage> createState() => _ConsultationPageState();
}

class _ConsultationPageState extends State<ConsultationPage> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final subjectController = TextEditingController();
  final messageController = TextEditingController();

  String? selectedCaseType;
  String? selectedProvince;

  final List<String> caseTypes = [
    'خانواده',
    'ملکی',
    'قراردادها',
    'کیفری',
    'حقوقی',
    'ارث',
    'مهریه',
    'دیه',
    'چک و سفته',
    'سایر',
  ];

  final List<String> provinces = [
    'قم',
    'تهران',
    'اصفهان',
    'خراسان رضوی',
    'آذربایجان شرقی',
    'آذربایجان غربی',
    'فارس',
    'البرز',
    'گیلان',
    'مازندران',
    'کرمان',
    'یزد',
    'مرکزی',
    'همدان',
    'کرمانشاه',
    'خوزستان',
    'سایر',
  ];

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    subjectController.dispose();
    messageController.dispose();
    super.dispose();
  }

  void submitConsultation() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (selectedCaseType == null) {
      _showError('لطفاً نوع پرونده را انتخاب کنید.');
      return;
    }

    if (selectedProvince == null) {
      _showError('لطفاً استان را انتخاب کنید.');
      return;
    }

    FocusScope.of(context).unfocus();

    showDialog(
      context: context,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            icon: const Icon(
              Icons.check_circle_outline,
              size: 55,
            ),
            title: const Text('درخواست آماده ارسال است'),
            content: const Text(
              'اطلاعات شما با موفقیت بررسی شد. '
                  'در مرحله بعد این درخواست به سایت وکیلت آنلاین ارسال خواهد شد.',
              textAlign: TextAlign.center,
            ),
            actions: [
              FilledButton(
                onPressed: () {
                  Navigator.pop(context);
                  _clearForm();
                },
                child: const Text('متوجه شدم'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  void _clearForm() {
    nameController.clear();
    phoneController.clear();
    subjectController.clear();
    messageController.clear();

    setState(() {
      selectedCaseType = null;
      selectedProvince = null;
    });
  }

  InputDecoration _inputDecoration(
      String label,
      IconData icon,
      ) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
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
            'درخواست مشاوره',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(18),
            children: [
              _buildHeader(),

              const SizedBox(height: 25),

              TextFormField(
                controller: nameController,
                decoration: _inputDecoration(
                  'نام و نام خانوادگی',
                  Icons.person_outline,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'نام و نام خانوادگی را وارد کنید.';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: _inputDecoration(
                  'شماره تماس',
                  Icons.phone_outlined,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'شماره تماس را وارد کنید.';
                  }

                  final phone = value.trim();

                  if (phone.length < 10) {
                    return 'شماره تماس صحیح نیست.';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 15),

              DropdownButtonFormField<String>(
                initialValue: selectedCaseType,
                decoration: _inputDecoration(
                  'نوع پرونده',
                  Icons.gavel_outlined,
                ),
                items: caseTypes.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCaseType = value;
                  });
                },
              ),

              const SizedBox(height: 15),

              DropdownButtonFormField<String>(
                initialValue: selectedProvince,
                decoration: _inputDecoration(
                  'استان',
                  Icons.location_on_outlined,
                ),
                items: provinces.map((province) {
                  return DropdownMenuItem(
                    value: province,
                    child: Text(province),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedProvince = value;
                  });
                },
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller: subjectController,
                decoration: _inputDecoration(
                  'موضوع مشاوره',
                  Icons.subject_outlined,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'موضوع مشاوره را وارد کنید.';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller: messageController,
                maxLines: 7,
                textAlignVertical: TextAlignVertical.top,
                decoration: _inputDecoration(
                  'شرح مسئله',
                  Icons.description_outlined,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'شرح مسئله را وارد کنید.';
                  }

                  if (value.trim().length < 10) {
                    return 'لطفاً توضیحات بیشتری وارد کنید.';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 25),

              SizedBox(
                height: 55,
                child: FilledButton.icon(
                  onPressed: submitConsultation,
                  icon: const Icon(
                    Icons.send_outlined,
                  ),
                  label: const Text(
                    'ارسال درخواست مشاوره',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              Text(
                'اطلاعات واردشده صرفاً برای بررسی درخواست مشاوره استفاده می‌شود.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              child: const Icon(
                Icons.support_agent_outlined,
                size: 30,
              ),
            ),
            const SizedBox(width: 14),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'مشاوره حقوقی',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'مشخصات و موضوع پرونده خود را وارد کنید.',
                    style: TextStyle(
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}