import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'constant.dart';
import 'index_page.dart';
import 'dart:developer' as dev;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

List arabic = [];
List malayalam = [];
List quran = [];
List faces=[];


Future readJson() async{

  final String response1 = await rootBundle.loadString("assets/hafs_smart_v8.json");
  final String response2 = await rootBundle.loadString("assets/faces.json");
  final data1 = json.decode(response1);
  final data2 = json.decode(response2);
  arabic = data1['quran'];
  malayalam = data1['malayalam'];
  faces=data2['faces'];
  //dev.log(faces[0]['rawy'].toString());
 return quran = [arabic,malayalam];
}





class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_)async{

      await readJson();
      await getSettings();
    });


    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quran',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const IndexPage(),
    );
  }
}

