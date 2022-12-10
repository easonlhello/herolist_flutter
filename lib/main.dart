import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'model/heros.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required String title}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Heroes> heros = [];

  Future getHeros() async {
    var response =
        await http.get(Uri.https('pvp.qq.com', '/web201605/js/herolist.json'));
    // var jsonData = jsonDecode(response.body);
    var jsonData = json.decode(utf8.decode(response.bodyBytes));
    // print(jsonData[0]['cname']);
    // print(jsonData.length);//112

    for (var eachTeam in jsonData) {
      // print(eachTeam);
      final heroes = Heroes(
        ename: eachTeam['ename'],
        cname: eachTeam['cname'],
        title: eachTeam['title'],
      );
      // print('${heroes.title}-${heroes.cname}');
      // print(heroes.title);
      heros.add(heroes);

      // print(heros);
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('123'),
      ),
      body: SafeArea(
        child: FutureBuilder(
            future: getHeros(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return ListView.builder(
                  itemCount: heros.length,
                  padding: const EdgeInsets.all(8),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ListTile(
                          title: Text(heros[index].title),
                          subtitle: Text(heros[index].cname),
                        ),
                      ),
                    );
                  },
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }),
      ),
    );
  }
}
