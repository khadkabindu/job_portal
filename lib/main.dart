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

enum ApiState { initial, loading, error, success }

class HomePage extends StatefulWidget {
  HomePage({super.key});

  List<String> selectedKeys = [];

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Job> jobs = [];
  ApiState state = ApiState.initial;
  String error = "";

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      setState(() {
        state = ApiState.loading;
      });
      List<Job> data = await Api.getData();
      setState(() {
        jobs = data;
        state = ApiState.success;
      });
    } catch (e) {
      setState(() {
        state = ApiState.error;
        error = e.toString();
      });
      print('Error fetching data: $e');
    }
  }

  List<String> jobTags(List<Job> jobs) {
    Set<String> uniqueKeywords = {};

    for (Job job in jobs) {
      uniqueKeywords.addAll(job.keywords.toList());
    }
    return uniqueKeywords.toList();
  }

  Set<String> selectedKeys = {};

  handleKeywordTap(String keyword) {
    setState(() {
      selectedKeys.add(keyword);
    });
  }

  void handleChipDelete(String key) {
    setState(() {
      selectedKeys.remove(key);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffeffafb),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xff5ea5a6),
      ),
      body: state == ApiState.error
          ? Center(
              child: Text(error),
            )
          : Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 100, vertical: 40),
              child: state == ApiState.loading
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
                      children: [
                        SelectedJobChip(
                          selectedKeys: selectedKeys.toList(),
                          onChipDeleted: handleChipDelete,
                          onClear: () {
                            setState(() {
                              selectedKeys.clear();
                            });
                          },
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
                          textValue: selectedKeys.toList(),
                          jobs: jobs,
                        ),
                      ],
                    ),
            ),
    );
  }
}
