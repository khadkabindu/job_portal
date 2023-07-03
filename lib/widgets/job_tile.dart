import 'package:flutter/material.dart';

import '../api.dart';

class JobTile extends StatefulWidget {
  const JobTile({Key? key}) : super(key: key);

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
    return FutureBuilder(
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
                          backgroundImage:
                              NetworkImage(snapshot.data[index].companyLogo),
                        ),
                        trailing: SizedBox(
                          width: 200,
                          child: ListView.builder(
                              itemCount: snapshot.data[index].keywords.length,
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
                                        snapshot.data[index].keywords[idx],
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
                        title: Text(snapshot.data[index].company),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              snapshot.data[index].position,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
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
    );
  }
}
