import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quran_qeraat/faces_page.dart';
import 'constant.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'faces_page.dart';
import 'dart:developer' as dev;

final ItemScrollController itemScrollController = ItemScrollController();
final ItemPositionsListener itemPositionsListener =
    ItemPositionsListener.create();

class SurahBuilder extends StatefulWidget {
  final surah;
  final arabic;
  final surahName;
  int ayah;

  SurahBuilder({
    Key? key,
    this.surah,
    this.arabic,
    this.surahName,
    required this.ayah,
  }) : super(key: key);

  @override
  State<SurahBuilder> createState() => _SurahBuilderState();
}

class _SurahBuilderState extends State<SurahBuilder> {
  bool view = true;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => jumbToAyah());
    super.initState();
  }

  jumbToAyah() {
    if (fabIsClicked) {
      itemScrollController.scrollTo(
        index: widget.ayah,
        duration: const Duration(seconds: 2),
        curve: Curves.easeInOutCubic,
      );
    }
    fabIsClicked = false;
  }

  saveBookMark(surah, ayah) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt("surah", surah);
    await prefs.setInt("ayah", ayah);
  }

//
  Row verseBuilder(int index, previousVerses) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                widget.arabic[index + previousVerses]['aya_text'],
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  fontSize: arabicFontSize,
                  fontFamily: arabicFont,
                  color: const Color.fromARGB(196, 0, 0, 0),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [],
              ),
            ],
          ),
        ),
      ],
    );
  }

  SafeArea singleSuraBuilder(LenghtOfSurah) {
    String fullSura = "";
    int previousVerses = 0;
    if (widget.surah + 1 != 1) {
      for (int i = widget.surah - 1; i >= 0; i--) {
        previousVerses = previousVerses + noOfVerses[i];
      }
    }
    if (!view) {
      for (int i = 0; i < LenghtOfSurah; i++) {
        fullSura += (widget.arabic[i + previousVerses]['aya_text']);
      }
    }

    return SafeArea(
      child: Container(
          color: Color.fromARGB(255, 253, 251, 240),
          child: view
              ? ScrollablePositionedList.builder(
                  itemCount: LenghtOfSurah,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        (index != 0) ||
                                (widget.surah == 0) ||
                                (widget.surah == 8)
                            ? const Text("")
                            : const ReturnBasmalah(),
                        Container(
                          color: index % 2 != 0
                              ? const Color.fromARGB(255, 253, 251, 240)
                              : const Color.fromARGB(255, 253, 247, 230),
                          child: GestureDetector(
                            onTap: () async {
                              var result= await isAssetExits(
                                  widget.surah+1,index+1);
                              print(result.toString());
                              if(result){
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => facesPage(surah: widget.surah,aya:index+1 ,)
                                  )
                              );


                              dev.log('surah '+(widget.surah+1).toString() +' aya '+(index+1).toString());
                            }},
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: verseBuilder(index, previousVerses),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                  itemScrollController: itemScrollController,
                  itemPositionsListener: itemPositionsListener,
                )
              : ListView(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              widget.surah + 1 != 1 && widget.surah + 1 != 9
                                  ? const ReturnBasmalah()
                                  : const Text(''),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  fullSura,
                                  textDirection: TextDirection.rtl,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: musahfFontSize,
                                    fontFamily: arabicFont,
                                    color: Color.fromARGB(196, 44, 44, 55),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                )),
    );
  }

  @override
  Widget build(BuildContext context) {
    int LengthOfSurah = noOfVerses[widget.surah];

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.yellow),
      home: Scaffold(
        appBar: AppBar(
          // swap mushaf mode
          leadingWidth: 140,
          leading: Row(
            children: [
              IconButton(onPressed: (){
                Navigator.pop(context);
              }, icon: Icon(Icons.arrow_back_rounded)),
              SizedBox(width: 10,),
              Tooltip(
                message: 'Mushaf Mode',
                child: TextButton(
                  child: const Icon(
                    Icons.chrome_reader_mode,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      view = !view;
                    });
                  },
                ),
              ),
            ],
          ),
          centerTitle: true,
          title: Text(
            widget.surahName,
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'quran',
                shadows: [
                  Shadow(
                    offset: Offset(1, 1),
                    blurRadius: 2.0,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ]),
          ),
          backgroundColor: const Color.fromARGB(255, 56, 115, 59),
        ),
        body: singleSuraBuilder(LengthOfSurah),
      ),
    );
  }

  Future<bool> isAssetExits(int surah,int aya) async {
    String path='';
    path="assets/audio/" + surah.toString() + "-" + aya.toString() + "-"+
        1.toString() +
        ".mp3";
    print(path);
    try {
       await rootBundle.load(path);
       return true;
    } catch(_) {
      return false;
    }
  }


}


// basmalah
class ReturnBasmalah extends StatelessWidget {
  const ReturnBasmalah({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Center(
          child: Text(
            '???????????? ???????????????? ?????????????????????????? ???????????????????? ',
            style: TextStyle(
              fontFamily: "me_quran",
              fontSize: 30,
            ),
            textDirection: TextDirection.rtl,
          ),
        )
      ],
    );
  }
}
