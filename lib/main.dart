import 'package:flutter/material.dart';

import 'api.dart';
import 'job.dart';

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

  String formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays >= 2) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays >= 1) {
      return '1 day ago';
    } else if (difference.inHours >= 2) {
      return '${difference.inHours} hours ago';
    } else if (difference.inHours >= 1) {
      return '1 hour ago';
    } else if (difference.inMinutes >= 2) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inMinutes >= 1) {
      return '1 minute ago';
    } else {
      return 'Just now';
    }
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
            SelectedJobChip(selectedKeys),
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
            FutureBuilder(
              future: Api.getData(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Expanded(
                    child: ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          return Container(
                            padding: const EdgeInsets.all(8),
                            margin: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            child: ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      snapshot.data[index].companyLogo),
                                ),
                                trailing: SizedBox(
                                  width: 200,
                                  child: ListView.builder(
                                      itemCount:
                                          snapshot.data[index].keywords.length,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, idx) {
                                        return Row(
                                          children: [
                                            Container(
                                              height: 30,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 4),
                                              alignment: Alignment.center,
                                              child: Text(
                                                snapshot
                                                    .data[index].keywords[idx],
                                                style: TextStyle(
                                                    color: Color(0xff6A9EA0),
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                                color: const Color(0xffebf3f3),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                          ],
                                        );
                                      }),
                                ),
                                title: Text(snapshot.data[index].company),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      snapshot.data[index].position,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                    Row(
                                      children: [
                                        Text(formatDateTime(
                                            snapshot.data[index].postedOn)),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Text(snapshot.data[index].timing),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Text(snapshot.data[index].location)
                                      ],
                                    ),
                                  ],
                                )),
                          );
                        }),
                  );
                } else if (snapshot.hasError) {
                  print(snapshot.error);
                  return const Center(
                    child: Text("Could not display data"),
                  );
                }
                return const CircularProgressIndicator();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class JobChip extends StatefulWidget {
  final List<String> jobTags;
  final Function(String) onKeywordTap;

  JobChip(this.jobTags, {required this.onKeywordTap});

  @override
  State<JobChip> createState() => _JobChipState();
}

class _JobChipState extends State<JobChip> {
  late List<String> tags;
  late List<bool> isSelected;

  _JobChipState();

  @override
  void initState() {
    super.initState();
    tags = widget.jobTags;

    isSelected = List<bool>.filled(20, false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      height: 100,
      color: Colors.white,
      child: ListView.builder(
        itemCount: widget.jobTags.length,
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          final keyword = widget.jobTags[index];

          return Row(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    isSelected[index] = !isSelected[index];
                    widget.onKeywordTap(keyword);
                  });
                },
                child: Chip(
                  backgroundColor: isSelected[index]
                      ? Color(0xff6A9EA0)
                      : Colors.transparent,
                  label: Text(
                    widget.jobTags[index],
                    style: TextStyle(
                      color:
                          isSelected[index] ? Colors.white : Color(0xff6A9EA0),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 8,
              ),
            ],
          );
        },
      ),
    );
  }
}

class SelectedJobChip extends StatefulWidget {
  final List<String> selectedKeys;

  SelectedJobChip(this.selectedKeys);

  @override
  State<SelectedJobChip> createState() => _SelectedJobChipState();
}

class _SelectedJobChipState extends State<SelectedJobChip> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      color: Colors.white,
      child: Row(
        children: widget.selectedKeys.map((key) {
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Chip(
              onDeleted: () {
                setState(() {
                  widget.selectedKeys.remove(key);
                });

                setState(() {});
              },
              label: Text(key),
              // Customize the chip as needed
            ),
          );
        }).toList(),
      ),
    );
  }
}
