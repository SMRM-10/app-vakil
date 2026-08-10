
import 'package:flutter/material.dart';
import 'api_service.dart';

class LawsPage extends StatefulWidget {
const LawsPage({super.key});

@override
State<LawsPage> createState() => _LawsPageState();
}

class _LawsPageState extends State<LawsPage> {
final TextEditingController searchController = TextEditingController();

List<LawItem> laws = [];
bool isLoading = true;
bool isSearching = false;
String? errorMessage;

@override
void initState() {
super.initState();
loadLaws();

searchController.addListener(() {
setState(() {});
});
}

@override
void dispose() {
searchController.dispose();
super.dispose();
}

Future<void> loadLaws() async {
setState(() {
isLoading = true;
errorMessage = null;
});

try {
final result = await ApiService.getLaws(
page: 1,
perPage: 50,
search: searchController.text.trim().isEmpty
? null
    : searchController.text.trim(),
);

if (!mounted) return;

if (result is List) {
final loadedLaws = result
    .whereType<Map>()
    .map(
(item) => LawItem.fromWordPress(
Map<String, dynamic>.from(item),
),
)
    .toList();

setState(() {
laws = loadedLaws;
isLoading = false;
});
} else if (result is Map<String, dynamic>) {
final data = result['data'];

if (data is List) {
final loadedLaws = data
    .whereType<Map>()
    .map(
(item) => LawItem.fromWordPress(
Map<String, dynamic>.from(item),
),
)
    .toList();

setState(() {
laws = loadedLaws;
isLoading = false;
});
} else {
setState(() {
laws = [];
isLoading = false;
errorMessage =
result['message']?.toString() ??
'دریافت قوانین با خطا مواجه شد.';
});
}
} else {
setState(() {
laws = [];
isLoading = false;
errorMessage = 'پاسخ نامعتبر از سرور دریافت شد.';
});
}
} catch (e) {
if (!mounted) return;

setState(() {
isLoading = false;
errorMessage = 'خطا در ارتباط با سرور.';
});
}
}

Future<void> searchLaws() async {
final query = searchController.text.trim();

if (query.isEmpty) {
await loadLaws();
return;
}

setState(() {
isSearching = true;
errorMessage = null;
});

try {
final result = await ApiService.getLaws(
page: 1,
perPage: 50,
search: query,
);

if (!mounted) return;

if (result is List) {
final loadedLaws = result
    .whereType<Map>()
    .map(
(item) => LawItem.fromWordPress(
Map<String, dynamic>.from(item),
),
)
    .toList();

setState(() {
laws = loadedLaws;
isSearching = false;
});
} else {
setState(() {
laws = [];
isSearching = false;
errorMessage = 'نتیجه‌ای از سرور دریافت نشد.';
});
}
} catch (e) {
if (!mounted) return;

setState(() {
isSearching = false;
errorMessage = 'خطا در جستجوی قوانین.';
});
}
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
onSubmitted: (_) => searchLaws(),
decoration: InputDecoration(
hintText: 'جستجوی ماده، قانون یا کلمه...',
prefixIcon: const Icon(Icons.search),
suffixIcon: searchController.text.isNotEmpty
? IconButton(
onPressed: () {
searchController.clear();
loadLaws();
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

SizedBox(
width: double.infinity,
child: Padding(
padding: const EdgeInsets.symmetric(
horizontal: 16,
vertical: 5,
),
child: FilledButton.icon(
onPressed: isSearching ? null : searchLaws,
icon: isSearching
? const SizedBox(
width: 18,
height: 18,
child: CircularProgressIndicator(
strokeWidth: 2,
color: Colors.white,
),
)
    : const Icon(Icons.search),
label: Text(
isSearching
? 'در حال جستجو...'
    : 'جستجوی قوانین',
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
'${laws.length} مورد',
style: TextStyle(
color: Colors.grey.shade600,
fontSize: 13,
),
),
),
),

Expanded(
child: isLoading
? const Center(
child: CircularProgressIndicator(),
)
    : errorMessage != null
? _buildError()
    : laws.isEmpty
? _buildEmptySearch()
    : ListView.builder(
padding: const EdgeInsets.fromLTRB(
16,
5,
16,
20,
),
itemCount: laws.length,
itemBuilder: (context, index) {
final law = laws[index];

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
leading: const CircleAvatar(
child: Icon(
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
padding:
const EdgeInsets.only(
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

Widget _buildError() {
return Center(
child: Padding(
padding: const EdgeInsets.all(30),
child: Column(
mainAxisAlignment: MainAxisAlignment.center,
children: [
const Icon(
Icons.cloud_off,
size: 70,
),
const SizedBox(height: 15),
Text(
errorMessage ?? 'خطایی رخ داد.',
textAlign: TextAlign.center,
),
const SizedBox(height: 15),
FilledButton.icon(
onPressed: loadLaws,
icon: const Icon(Icons.refresh),
label: const Text('تلاش دوباره'),
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
title: const Text(
'متن قانون',
),
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
'متن قوانین مستقیماً از بانک قوانین سایت '
'وکیلت آنلاین دریافت می‌شود.',
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

factory LawItem.fromWordPress(
Map<String, dynamic> json,
) {
final titleData = json['title'];
final contentData = json['content'];

String title = '';

if (titleData is Map) {
title = _stripHtml(
titleData['rendered']?.toString() ?? '',
);
}

String text = '';

if (contentData is Map) {
text = _stripHtml(
contentData['rendered']?.toString() ?? '',
);
}

return LawItem(
title: title.isEmpty ? 'بدون عنوان' : title,
category: 'قوانین و مقررات',
text: text.isEmpty
? 'متن قانون موجود نیست.'
    : text,
);
}

static String _stripHtml(String value) {
return value
    .replaceAll(RegExp(r'<[^>]*>'), '')
    .replaceAll('&nbsp;', ' ')
    .replaceAll('&quot;', '"')
    .replaceAll('&#8217;', '’')
    .replaceAll('&#8220;', '“')
    .replaceAll('&#8221;', '”')
    .replaceAll('&#8211;', '–')
    .replaceAll('&#8230;', '…')
    .trim();
}
}
