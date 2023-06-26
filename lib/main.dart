import 'package:flutter/material.dart';

import 'api.dart';

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
      title: 'Flutter Demo',
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
  late TextEditingController textEditingController;
  late String searchItem;
  @override
  void initState() {
    textEditingController = TextEditingController();
    super.initState();
  }
  void onItemChanged(String text){
    setState(() {
      searchItem = text;
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 40),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(20),
              height: 60,
              child: TextField(
                onSubmitted: (text) => onItemChanged(text),
                decoration: InputDecoration(
                    hintText: "Search", border: InputBorder.none),
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
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
                                        itemCount: snapshot
                                            .data[index].keywords.length,
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
                                                  snapshot.data[index]
                                                      .keywords[idx],
                                                  style: TextStyle(
                                                      color: Color(0xff6A9EA0),
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                  color:
                                                      const Color(0xffebf3f3),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        snapshot.data[index].position,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      ),
                                      Row(
                                        children: [
                                          Text("1 day ago"),
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
                }),
          ],
        ),
      ),
    );
  }

}
