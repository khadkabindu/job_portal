import 'package:flutter/material.dart';

import '../api.dart';
import '../job.dart';

class JobTile extends StatefulWidget {
  final List<String> textValue;
  const JobTile({required this.textValue});

  @override
  State<JobTile> createState() => _JobTileState();
}

class _JobTileState extends State<JobTile> {
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
    final List<String> selectedValues = widget.textValue;
    print("--------$selectedValues--------------");
    return FutureBuilder(
      future: Api.getData(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final List<Job> filteredJobs = snapshot.data
              .where((job) =>
              jobContainsSelectedKeywords(job, selectedValues))
              .toList();
          return Expanded(
            child: ListView.builder(
                itemCount: filteredJobs.length,
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
                          backgroundImage:
                          NetworkImage(filteredJobs[index].companyLogo),
                        ),
                        trailing: SizedBox(
                          width: 200,
                          child: ListView.builder(
                              itemCount: filteredJobs[index].keywords!.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, idx) {
                                return Row(
                                  children: [
                                    Container(
                                      height: 30,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      alignment: Alignment.center,
                                      child: Text(
                                        filteredJobs[index].keywords![idx],
                                        style: TextStyle(
                                            color: Color(0xff6A9EA0),
                                            fontWeight: FontWeight.bold),
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
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
                        title: Text(filteredJobs[index].company),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              filteredJobs[index].position,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            Row(
                              children: [
                                Text(formatDateTime(
                                    filteredJobs[index].postedOn)),
                                SizedBox(
                                  width: 20,
                                ),
                                Text(filteredJobs[index].timing),
                                SizedBox(
                                  width: 20,
                                ),
                                Text(filteredJobs[index].location)
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
    );
  }


  bool jobContainsSelectedKeywords(Job job, List<String> selectedKeywords) {
    for (final keyword in selectedKeywords) {
      if (!job.keywords!.contains(keyword)) {
        return false;
      }
    }
    return true;
  }
}