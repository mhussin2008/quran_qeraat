import 'package:flutter/material.dart';
import 'package:quran_qeraat/main.dart';

class facesPage extends StatefulWidget {
  const facesPage({Key? key}) : super(key: key);

  @override
  State<facesPage> createState() => _facesPageState();
}

class _facesPageState extends State<facesPage> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: SafeArea(
        child: Center(child: Column(
          children:
          faces.map((e) => Container(child: Column(
            children: [
              Text(e['text'],
              style: TextStyle(color: Colors.blue,fontFamily: 'qaloon',fontSize: 20,),textDirection: TextDirection.rtl,),
              Text(e['desc'],
                  style: TextStyle(color: Colors.red,fontFamily: 'qaloon',fontSize: 20)),
              SizedBox(height: 20,)
            ],
          ),)).toList()
          ,
        ),
      ),
    )
    );
  }
}
