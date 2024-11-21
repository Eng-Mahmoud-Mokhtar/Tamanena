import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:google_fonts/google_fonts.dart';
import 'widgets/aya.dart';

class QuranSurah extends StatefulWidget {
  @override
  _QuranSurahState createState() => _QuranSurahState();
}

class _QuranSurahState extends State<QuranSurah> {
  final Dio _dio = Dio();
  List<Map<String, dynamic>> surahs = [];
  bool isSearching = false;
  TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> filteredSurahs = [];

  String removeDiacritics(String text) {
    const diacritics = [
      'َ', 'ً', 'ُ', 'ٌ', 'ِ', 'ٍ', 'ْ', 'ٔ', 'ٓ', 'ᶜ', 'َ'
    ];
    diacritics.forEach((diacritic) {
      text = text.replaceAll(diacritic, '');
    });
    return text;
  }

  String convertToArabicNumerals(int number) {
    const arabicNumerals = [
      '٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'
    ];
    String numberStr = number.toString();
    return numberStr.split('').map((digit) => arabicNumerals[int.parse(digit)]).join('');
  }

  @override
  void initState() {
    super.initState();
    _fetchSurahs();
  }

  void filterSurahs(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredSurahs = List.from(surahs);
      });
    } else {
      String normalizedQuery = removeDiacritics(query.toLowerCase().trim());

      List<Map<String, dynamic>> filtered = surahs.where((surah) {
        String nameWithoutDiacritics = removeDiacritics(surah['name'].toLowerCase());
        String englishNameWithoutDiacritics = removeDiacritics(surah['englishName'].toLowerCase());

        return nameWithoutDiacritics.contains(normalizedQuery) ||
            englishNameWithoutDiacritics.contains(normalizedQuery);
      }).toList();

      setState(() {
        filteredSurahs = filtered;
      });
    }
  }

  Future<void> _fetchSurahs() async {
    try {
      final response = await _dio.get('https://api.alquran.cloud/v1/surah');
      if (response.statusCode == 200) {
        final data = response.data;
        if (data['data'] != null) {
          surahs = List<Map<String, dynamic>>.from(data['data'].map((surah) {
            return {
              'number': surah['number'],
              'name': surah['name'],
              'englishName': surah['englishName'],
              'ayahCount': surah['numberOfAyahs'],
            };
          }));
          filteredSurahs = List.from(surahs);
          setState(() {});
        }
      } else {
        throw Exception('فشل في تحميل السور');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xff1c1c1c),
        appBar: AppBar(
          backgroundColor: Color(0xff2e7d32), // أخضر داكن
          automaticallyImplyLeading: false,
          title: isSearching
              ? TextField(
            controller: searchController,
            onChanged: (value) {
              filterSurahs(value);
            },
            style: TextStyle(color: Colors.white),
            textAlign: TextAlign.right,
            decoration: InputDecoration(
              hintText: '... البحث',
              hintStyle: TextStyle(color: Colors.white70),
              border: InputBorder.none,
            ),
          )
              : Text(
            'القرآن الكريم',
            style: GoogleFonts.amiri(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            IconButton(
              icon: Icon(isSearching ? Icons.close : Icons.search, color: Colors.white),
              onPressed: () {
                setState(() {
                  if (isSearching) {
                    isSearching = false;
                    searchController.clear();
                    filteredSurahs = List.from(surahs);
                  } else {
                    isSearching = true;
                  }
                });
              },
            ),
          ],
        ),
        body: filteredSurahs.isEmpty
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
          itemCount: filteredSurahs.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                SizedBox(height: 10),
                ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            filteredSurahs[index]['name'],
                            style: GoogleFonts.amiri(
                              fontSize: 23,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'الآيات: ${convertToArabicNumerals(filteredSurahs[index]['ayahCount'])}',
                            style: GoogleFonts.amiri(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 10),
                      Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xff212121),
                          border: Border.all(color: Color(0xff2e7d32), width: 3),
                        ),
                        child: Center(
                          child: Text(
                            '${convertToArabicNumerals(filteredSurahs[index]['number'])}',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QuranAyahPage(
                          surahNumber: filteredSurahs[index]['number'],
                          surahName: filteredSurahs[index]['name'],
                        ),
                      ),
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Divider(
                    color: Colors.grey,
                    thickness: 1,
                  ),
                ),
              ],
            );
          },
        ));
  }
}
