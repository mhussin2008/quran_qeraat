import 'package:flutter/material.dart';
import 'package:quran_qeraat/main.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'dart:developer' as dev;

import 'constant.dart';

class facesPage extends StatefulWidget {
  final surah;
  final aya;
  const facesPage({Key? key, this.surah, this.aya}) : super(key: key);

  @override
  State<facesPage> createState() => _facesPageState();
}

class _facesPageState extends State<facesPage> {
  @override
  Widget build(BuildContext context) {
    var t='أوجه الآية  ${widget.aya}  من سورة '+ arabicName[widget.surah]['name'];
    return Scaffold(
      appBar: AppBar(

        title: Center(child: Text(t)),
        leading: IconButton(onPressed: (){
        Navigator.pop(context);
            },icon: const Icon(Icons.arrow_back_rounded),),),
             body: SafeArea(
                child: SingleChildScrollView(
                  child: Center(
                     child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                        children: faces.where((element) => element['surah']==widget.surah && element['aya']==widget.aya)
                        .map((e) => Column(
                          children: [
                          Container(
                            padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.teal, width: 5),
                                  borderRadius: const BorderRadius.all(Radius.circular(20))),
                              child: GestureDetector(
                                onTap: () {
                                  print(faces[0]['surah']);
                                  //dev.log(e['face'].toString());
                                 // print(faces);
                                  print(getFaceAsset(widget.surah, widget.aya, e['face']));
                                  AssetsAudioPlayer.newPlayer().open(

                                    Audio(getFaceAsset(widget.surah, widget.aya, e['face'])),
                                    autoStart: true,
                                    showNotification: true,
                                  );
                                },
                                child: Column(
                                  children: [
                                    Text(
                                      e['text'],
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blueAccent,
                                        fontFamily: 'hafs2001',
                                        fontSize: 20,
                                      ),
                                      textDirection: TextDirection.rtl,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment: CrossAxisAlignment.start,

                                      children: <Widget>[
                                        Expanded(
                                          child: Text(e['desc'],

                                              textAlign: TextAlign.center,
                                              softWrap: true,
                                              style: const TextStyle(

                                                  color: Colors.red,
                                                  fontFamily: 'hafs2001',
                                                  fontSize: 20)),
                                        ), SizedBox(width: 10,)
                                      , Container(
                                          height: 40,
                                          width: 40,
                                          decoration: BoxDecoration(
                                            border: Border.all(color: Colors.teal, width: 5),
                                            borderRadius: const BorderRadius.all(Radius.circular(20))),
                                          child: Text(e['face'].toString(),
                                          style: const TextStyle(fontSize: 22)
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
                                  child: const SizedBox(
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

String getFaceAsset(int surah,int aya,int face){
    //print(surah.toString()+'   '+aya.toString());

    return "assets/audio/${surah+1}-$aya-$face.mp3";
}

}
