import 'package:flutter/material.dart';
import 'package:quran_qeraat/main.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'dart:developer' as dev;

class facesPage extends StatefulWidget {
  const facesPage({Key? key}) : super(key: key);

  @override
  State<facesPage> createState() => _facesPageState();
}

class _facesPageState extends State<facesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Center(
             child: Padding(
               padding: const EdgeInsets.all(8.0),
               child: Column(
                    children: faces
                      .map((e) => Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.teal, width: 5),
                                  borderRadius: BorderRadius.all(Radius.circular(20))),
                              child: GestureDetector(
                                onTap: () {
                                  dev.log(e['face'].toString());
                                  AssetsAudioPlayer.newPlayer().open(
                                    Audio("assets/audio/1-6-" +
                                        e['face'].toString() +
                                        ".mp3"),
                                    autoStart: true,
                                    showNotification: false,
                                  );
                                },
                                child: Column(
                                  children: [
                                    Text(
                                      e['text'],
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blueAccent,
                                        fontFamily: 'qaloon',
                                        fontSize: 20,
                                      ),
                                      textDirection: TextDirection.rtl,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(e['desc'],
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontFamily: 'qaloon',
                                                fontSize: 20)),SizedBox(width: 10,)
                                      , Container(
                                          height: 40,
                                          width: 40,
                                          decoration: BoxDecoration(
                                            border: Border.all(color: Colors.teal, width: 5),
                                            borderRadius: BorderRadius.all(Radius.circular(20))),
                                          child: Text(e['face'].toString(),
                                          style: TextStyle(fontSize: 22)
                                          ,textAlign: TextAlign.center,)

                              )],
                                    ),
                                    //SizedBox(height: 20,)
                                  ],
                                ),
                              )
            ),
                        ]+
                            [
                              Container(
                                  color: Colors.red,
                                  child: SizedBox(
                                    height: 20,
                                  )
                              )
                            ],
                      )
            ).toList()
        ),
             ),
      ),
          ),
    ));
  }
}
