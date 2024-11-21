import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:google_fonts/google_fonts.dart';

class QuranAyahPage extends StatefulWidget {
  final int surahNumber;
  final String surahName;

  QuranAyahPage({required this.surahNumber, required this.surahName});

  @override
  _QuranAyahPageState createState() => _QuranAyahPageState();
}

class _QuranAyahPageState extends State<QuranAyahPage> {
  List<Map<String, dynamic>> ayahs = [];
  final String edition = 'ar.alafasy';
  final int bitrate = 128;

  AudioPlayer audioPlayer = AudioPlayer();
  int? currentlyPlayingAyah;
  final Dio dio = Dio();

  @override
  void initState() {
    super.initState();
    _fetchAyahs(widget.surahNumber);
    audioPlayer.onPlayerComplete.listen((_) {
      _playNextAyah();
    });
  }

  Future<void> _fetchAyahs(int surahNumber) async {
    try {
      final response = await dio.get('https://api.alquran.cloud/v1/surah/$surahNumber');
      if (response.statusCode == 200) {
        final data = response.data;
        if (data['data']['ayahs'] != null) {
          ayahs = List<Map<String, dynamic>>.from(data['data']['ayahs'].map((ayah) {
            return {
              'text': ayah['text'],
              'number': ayah['number'].toString(),
            };
          })).toList();
          setState(() {});
        }
      }
    } catch (e) {
      print('Error fetching ayahs for surah $surahNumber: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff1c1c1c),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.surahName,
          style: GoogleFonts.amiri(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xff2e7d32),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: ayahs.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: ayahs.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    icon: AnimatedContainer(
                      duration: Duration(milliseconds: 500),
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: currentlyPlayingAyah == int.parse(ayahs[index]['number'])
                            ? [
                          BoxShadow(
                            color: Color(0xffaa8428).withOpacity(0.1),
                            spreadRadius: 2,
                            blurRadius: 20,
                          ),
                        ]
                            : [],
                      ),
                      child: Icon(
                        currentlyPlayingAyah == int.parse(ayahs[index]['number'])
                            ? Icons.stop_circle_outlined
                            : Icons.play_circle_outline,
                        size: 40,
                        color: currentlyPlayingAyah == int.parse(ayahs[index]['number'])
                            ? Color(0xffaa8428)
                            : Color(0xff2e7d32),
                      ),
                    ),
                    onPressed: () {
                      _toggleAudio(int.parse(ayahs[index]['number']!));
                    },
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Text(
                        '${ayahs[index]['text']}',
                        style: GoogleFonts.amiri(
                          fontSize: 23,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  void _toggleAudio(int ayahNumber) async {
    if (currentlyPlayingAyah == ayahNumber) {
      await audioPlayer.stop();
      setState(() {
        currentlyPlayingAyah = null;
      });
    } else {
      if (currentlyPlayingAyah != null) {
        await audioPlayer.stop();
      }
      final audioUrl =
          'https://cdn.islamic.network/quran/audio/$bitrate/$edition/$ayahNumber.mp3';
      await audioPlayer.setSourceUrl(audioUrl);
      await audioPlayer.resume();
      setState(() {
        currentlyPlayingAyah = ayahNumber;
      });
    }
  }

  void _playNextAyah() {
    if (currentlyPlayingAyah != null) {
      int currentIndex = ayahs.indexWhere((ayah) => int.parse(ayah['number']!) == currentlyPlayingAyah);
      if (currentIndex != -1 && currentIndex < ayahs.length - 1) {
        setState(() {
          currentlyPlayingAyah = null;
        });
        _toggleAudio(int.parse(ayahs[currentIndex + 1]['number']!));
      } else {
        _playNextSurah();
      }
    }
  }

  Future<void> _playNextSurah() async {
    int nextSurahNumber = widget.surahNumber + 1;
    try {
      final response = await dio.get('https://api.alquran.cloud/v1/surah/$nextSurahNumber');
      if (response.statusCode == 200) {
        final nextSurahName = response.data['data']['name'];
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => QuranAyahPage(
            surahNumber: nextSurahNumber,
            surahName: nextSurahName,
          ),
        ));
      } else {
        setState(() {
          currentlyPlayingAyah = null;
        });
      }
    } catch (e) {
      print('Error fetching next surah: $e');
    }
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }
}
