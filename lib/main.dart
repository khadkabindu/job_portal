import 'package:flutter/material.dart';

import 'api.dart';
import 'job.dart';
import 'widgets/job_chip.dart';
import 'widgets/job_tile.dart';
import 'widgets/selected_job_chip.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Job Portal',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({super.key});

  List<String> selectedKeys = [];

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Job> jobs = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      List<Job> data = await Api.getData();
      setState(() {
        jobs = data;
      });
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  List<String> jobTags(List<Job> jobs) {
    Set<String> uniqueKeywords = Set<String>();

    for (Job job in jobs) {
      uniqueKeywords.addAll((job.keywords as List<dynamic>).cast<String>());
    }
    return uniqueKeywords.toList();
  }

  bool isTapped = false;
  List<Map<String, dynamic>> filteredData = [];

  List<String> selectedKeys = [];

  handleKeywordTap(String p1) {
    setState(() {
      if (selectedKeys.contains(p1)) {
        selectedKeys.remove(p1);
      } else {
        selectedKeys.add(p1);
      }
    });
  }

  void handleChipDelete(String key) {
    setState(() {
      selectedKeys.remove(key);
    });
    print("----- Triggered-----");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffeffafb),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xff5ea5a6),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 40),
        child: Column(
          children: [
            SelectedJobChip(
              selectedKeys: selectedKeys,
              onChipDeleted: handleChipDelete,
            ),
            const SizedBox(
              height: 10,
            ),
            JobChip(
              jobTags(jobs),
              onKeywordTap: handleKeywordTap,
            ),
            const SizedBox(
              height: 10,
            ),
            JobTile(
              textValue: selectedKeys,
            ),
          ],
        ),
      ),
    );
  }
}
