import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:tamanina/Features/FadlElSour/presentation/view_model/views/FadlElSour.dart';
import '../../../../../Gomaa/presentation/view_model/views/widgets/Gomaa.dart';
import '../../../../../Quran/presentation/view_model/views/Quran.dart';
import 'CircularImage.dart';
import 'Hadith.dart';
import '../../../../../Sebha/presentation/view_model/views/widgets/Sebha.dart';
import '../../../../../Doaa/presentation/view_model/views/TodaysDoaa.dart';
import '../../../../../NamesOfAllah/presentation/view_model/views/widgets/namesOfAllah.dart';
import 'package:dio/dio.dart';
class HomeBody extends StatefulWidget {
  const HomeBody({super.key});

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  late String currentHadith;
  late Timer timer;
  String hijriDate = '';
  String gregorianDate = '';

  @override
  void initState() {
    super.initState();
    currentHadith = getRandomHadith();
    fetchHijriDate();
    startTimer();
    gregorianDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
  }
  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    timer = Timer.periodic(Duration(hours: 1), (Timer t) {
      setState(() {
        currentHadith = getRandomHadith();
        fetchHijriDate();
      });
    });
  }

  String getRandomHadith() {
    final random = Random();
    return hadiths[random.nextInt(hadiths.length)];
  }

  Future<void> fetchHijriDate() async {
    String currentDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
    Dio dio = Dio();

    try {
      final response = await dio.get('http://api.aladhan.com/v1/gToH/$currentDate');

      if (response.statusCode == 200) {
        final data = response.data;
        final hijriData = data['data']['hijri'];

        setState(() {
          hijriDate = '${hijriData['weekday']['ar']} ${hijriData['day']} ${hijriData['month']['ar']} ${hijriData['year']} هـ';
        });
      }
    } catch (e) {
      setState(() {
        hijriDate = 'خطأ في جلب التاريخ';
      });
    }
  }

  String convertToArabicNumerals(int number) {
    const arabicNumerals = [
      '٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'
    ];
    String numberStr = number.toString();
    return numberStr.split('').map((digit) => arabicNumerals[int.parse(digit)]).join('');
  }

  String convertMonthToArabic(String month) {
    const monthsInArabic = {
      '01': 'يناير',
      '02': 'فبراير',
      '03': 'مارس',
      '04': 'أبريل',
      '05': 'مايو',
      '06': 'يونيو',
      '07': 'يوليو',
      '08': 'أغسطس',
      '09': 'سبتمبر',
      '10': 'أكتوبر',
      '11': 'نوفمبر',
      '12': 'ديسمبر',
    };
    return monthsInArabic[month]!;
  }

  @override
  Widget build(BuildContext context) {
    String todayHadith = getRandomHadith();

    return Scaffold(
      backgroundColor: Color(0xff212121),
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          'طمأنينة',
          style: GoogleFonts.amiri(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('Images/mosque-building-architecture-with-crescent-moon.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: Container(
              color: Colors.black.withOpacity(0.8),
            ),
          ),
          Column(
            children: [
              Container(
                color: Colors.black,
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${convertToArabicNumerals(int.parse(gregorianDate.split('-')[0]))}${convertMonthToArabic(gregorianDate.split('-')[1])} ${convertToArabicNumerals(int.parse(gregorianDate.split('-')[2]))}',
                      style: GoogleFonts.amiri(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                    Text(
                      hijriDate,
                      style: GoogleFonts.amiri(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: buildHadithContainer(todayHadith),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      buildCircularImageButton(
                        context,
                        'Images/islamic_14416706.png',
                        'سنن الجمعة',
                            () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Gomaa()),
                          );
                        },
                      ),
                      SizedBox(width: 12),
                      buildCircularImageButton(
                        context,
                        'Images/allah.png',
                        'الأسماء الحسني',
                            () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => NamesOfAllahPage()),
                          );
                        },
                      ),
                      SizedBox(width: 12),
                      buildCircularImageButton(
                        context,
                        'Images/tasbih_7222953.png',
                        'التسبيح',
                            () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Sebha()),
                          );
                        },
                      ),
                      SizedBox(width: 12),
                      buildCircularImageButton(
                        context,
                        'Images/praying_15319785.png',
                        'ادعية',
                            () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => TodaysDoaa()),
                          );
                        },
                      ),
                      SizedBox(width: 12),
                      buildCircularImageButton(
                        context,
                        'Images/idea.png',
                        'فضل السور',
                            () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => FadlElSour()),
                          );
                        },
                      ),
                      SizedBox(width: 12),
                      buildCircularImageButton(
                        context,
                        'Images/quran_4358605.png',
                        'القرآن الكريم',
                            () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => QuranSurah()),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
