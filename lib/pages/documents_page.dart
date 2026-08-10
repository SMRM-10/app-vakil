import 'package:flutter/material.dart';

class DocumentsPage extends StatefulWidget {
  const DocumentsPage({super.key});

  @override
  State<DocumentsPage> createState() => _DocumentsPageState();
}

class _DocumentsPageState extends State<DocumentsPage> {
  final List<DocumentItem> documents = [];

  void addDocument() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'افزودن مدرک',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  ListTile(
                    leading: const Icon(Icons.camera_alt_outlined),
                    title: const Text('گرفتن عکس'),
                    subtitle: const Text(
                      'ثبت تصویر جدید از مدرک',
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      _showComingSoon('دوربین');
                    },
                  ),

                  ListTile(
                    leading: const Icon(Icons.photo_library_outlined),
                    title: const Text('انتخاب از گالری'),
                    subtitle: const Text(
                      'انتخاب تصویر از گوشی',
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      _showComingSoon('گالری');
                    },
                  ),

                  ListTile(
                    leading: const Icon(Icons.insert_drive_file_outlined),
                    title: const Text('انتخاب فایل'),
                    subtitle: const Text(
                      'افزودن فایل PDF یا سایر مدارک',
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      _showComingSoon('انتخاب فایل');
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '$feature در مرحله بعد فعال می‌شود.',
        ),
      ),
    );
  }

  void deleteDocument(int index) {
    setState(() {
      documents.removeAt(index);
    });
  }

  void showDocument(DocumentItem document) {
    showDialog(
      context: context,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: Text(document.title),
            content: Text(
              'نوع مدرک: ${document.type}\n'
                  'تاریخ ثبت: ${document.date}',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('بستن'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'کیف مدارک',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),

        floatingActionButton: FloatingActionButton.extended(
          onPressed: addDocument,
          icon: const Icon(Icons.add),
          label: const Text('افزودن مدرک'),
        ),

        body: SafeArea(
          child: documents.isEmpty
              ? _buildEmptyState()
              : _buildDocumentsList(),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.folder_open_outlined,
              size: 90,
              color: Theme.of(context)
                  .colorScheme
                  .primary,
            ),

            const SizedBox(height: 20),

            const Text(
              'کیف مدارک شما خالی است',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 12),

            Text(
              'مدارک مهم خود را در این بخش مدیریت کنید.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 25),

            FilledButton.icon(
              onPressed: addDocument,
              icon: const Icon(Icons.add),
              label: const Text('افزودن اولین مدرک'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentsList() {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(
        16,
        16,
        16,
        100,
      ),
      itemCount: documents.length,
      itemBuilder: (context, index) {
        final document = documents[index];

        return Card(
          margin: const EdgeInsets.only(bottom: 10),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),

            leading: CircleAvatar(
              child: Icon(
                document.type == 'تصویر'
                    ? Icons.image_outlined
                    : Icons.insert_drive_file_outlined,
              ),
            ),

            title: Text(
              document.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            subtitle: Text(
              '${document.type} • ${document.date}',
            ),

            onTap: () => showDocument(document),

            trailing: PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'delete') {
                  deleteDocument(index);
                }
              },
              itemBuilder: (context) => const [
                PopupMenuItem(
                  value: 'delete',
                  child: Text('حذف مدرک'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class DocumentItem {
  final String title;
  final String type;
  final String date;

  const DocumentItem({
    required this.title,
    required this.type,
    required this.date,
  });
}