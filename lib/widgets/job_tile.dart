import 'package:flutter/material.dart';
import '../job.dart';
import '../utils/date_time.dart';

class JobTile extends StatefulWidget {
  final List<Job> jobs;
  final List<String> textValue;

  const JobTile({required this.textValue, required this.jobs, super.key});

  @override
  State<JobTile> createState() => _JobTileState();
}

class _JobTileState extends State<JobTile> {
  bool jobContainsSelectedKeywords(Job job, List<String> selectedKeywords) {
    for (final keyword in selectedKeywords) {
      if (!job.keywords!.contains(keyword)) {
        return false;
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final List<String> selectedValues = widget.textValue;
    final List<Job> filteredJobs = widget.jobs
        .where((job) => jobContainsSelectedKeywords(job, selectedValues))
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
                          Text(DateTimeUtil.formatDateTime(filteredJobs[index].postedOn)),
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
  }
}
