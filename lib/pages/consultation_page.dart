import 'package:flutter/material.dart';
import 'api_service.dart';

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

  bool _isSending = false;

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

  Future<void> submitConsultation() async {
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

    setState(() {
    _isSending = true;
    });

    try {
    final result = await ApiService.createConsultation(
    data: {
    'name': nameController.text.trim(),
    'phone': phoneController.text.trim(),
    'subject': subjectController.text.trim(),
    'message': messageController.text.trim(),
    'case_type': selectedCaseType,
    'province': selectedProvince,
    },
    );

    if (!mounted) return;

    final success = result is Map<String, dynamic> &&
    (result['status'] == true ||
    result['success'] == true ||
    result['id'] != null ||
    result['consultation'] != null);

    if (success) {
    await showDialog(
    context: context,
    builder: (context) {
    return Directionality(
    textDirection: TextDirection.rtl,
    child: AlertDialog(
    icon: const Icon(
    Icons.check_circle_outline,
    size: 55,
    ),
    title: const Text('درخواست ثبت شد'),
    content: const Text(
    'درخواست مشاوره شما با موفقیت ثبت شد. '
    'پس از بررسی، با شما تماس گرفته خواهد شد.',
    textAlign: TextAlign.center,
    ),
    actions: [
    FilledButton(
    onPressed: () {
    Navigator.pop(context);
    },
    child: const Text('متوجه شدم'),
    ),
    ],
    ),
    );
    },
    );

    _clearForm();
    } else {
    String message = 'ثبت درخواست مشاوره انجام نشد.';

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

    _showError(message);
    }
    } catch (_) {
    if (!mounted) return;

    _showError(
    'خطا در ارتباط با سرور. لطفاً دوباره تلاش کنید.',
    );
    } finally {
    if (mounted) {
    setState(() {
    _isSending = false;
    });
    }
    }


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
            if (value == null ||
                value.trim().isEmpty) {
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
            if (value == null ||
                value.trim().isEmpty) {
              return 'شماره تماس را وارد کنید.';
            }

            if (value.trim().length < 10) {
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
            return DropdownMenuItem<String>(
              value: type,
              child: Text(type),
            );
          }).toList(),
          onChanged: _isSending
              ? null
              : (value) {
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
            return DropdownMenuItem<String>(
              value: province,
              child: Text(province),
            );
          }).toList(),
          onChanged: _isSending
              ? null
              : (value) {
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
            if (value == null ||
                value.trim().isEmpty) {
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
            if (value == null ||
                value.trim().isEmpty) {
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
            onPressed:
            _isSending ? null : submitConsultation,
            icon: _isSending
                ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
                : const Icon(
              Icons.send_outlined,
            ),
            label: Text(
              _isSending
                  ? 'در حال ارسال...'
                  : 'ارسال درخواست مشاوره',
              style: const TextStyle(
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
                crossAxisAlignment:
                CrossAxisAlignment.start,
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