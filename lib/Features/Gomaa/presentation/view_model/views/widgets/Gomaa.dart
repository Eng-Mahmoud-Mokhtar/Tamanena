import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Gomaa extends StatelessWidget {
  const Gomaa({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff212121),
      appBar: AppBar(
        backgroundColor: Color(0xff2e7d32),
        centerTitle: true,
        title: Text(
          'سنن الجمعة',
          style: GoogleFonts.amiri(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
            children: [
          _buildAyah(),
          const SizedBox(height: 10),
        Column(
          children: _getGomaaContent(),
        ),
            ],
        ),
      ),
    );
  }
  Widget _buildAyah() {
    return Center(
      child: Text(
        'يَا أَيُّهَا الَّذِينَ آمَنُوا إِذَا نُودِيَ لِلصَّلَاةِ مِن يَوْمِ الْجُمُعَةِ فَاسْعَوْا إِلَىٰ ذِكْرِ اللَّهِ وَذَرُوا الْبَيْعَ ۚ ذَٰلِكُمْ خَيْرٌ لَّكُمْ إِن كُنتُمْ تَعْلَمُونَ',
        textAlign: TextAlign.center,
        style: GoogleFonts.amiri(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }
  List<Widget> _getGomaaContent() {
    return [
      _buildGomaaContainer(
          'الاغتسال',
          'قال رسول الله صلى الله عليه وسلم: إذا جاء أحدكم الجمعة فليغتسل',
          1),
      _buildGomaaContainer(
          'التطيب',
          'قال رسول الله صلى الله عليه وسلم: من جاء الجمعة فليتطيب إن استطاع',
          2),
      _buildGomaaContainer(
          'لبس أحسن الثياب',
          'قال رسول الله صلى الله عليه وسلم: خير لباسكم يوم الجمعة ما كان من البياض',
          3),
      _buildGomaaContainer(
          'الإكثار من الصلاة على النبي',
          'قال الله تعالى: إن الله وملائكته يصلون على النبي، (الأحزاب: 56)',
          4),
      _buildGomaaContainer(
          'التبكير إلى المسجد',
          'قال رسول الله صلى الله عليه وسلم: أحبكم إلى الله أعمكم في الجمعة',
          5),
      _buildGomaaContainer(
          'قراءة سورة الكهف',
          'قال رسول الله صلى الله عليه وسلم: من قرأ سورة الكهف يوم الجمعة أضاء له ما بين الجمعتين',
          6),
      _buildGomaaContainer(
          'التسوك',
          'قال رسول الله صلى الله عليه وسلم: لولا أن أشق على أمتي لأمرتهم بالسواك عند كل صلاة',
          7),
      _buildGomaaContainer(
          'الاستماع للخطبة',
          'قال الله تعالى: وإذا قيل لكم انصتوا فأنصتوا، (الأعراف: 204)',
          8),
      _buildGomaaContainer(
          'صلاة ركعتين بعد الخطبة',
          'قال رسول الله صلى الله عليه وسلم: إذا صليتم فلتصلوا ركعتين بعد الجمعة',
          9),
    ];
  }
  String convertToArabicNumerals(int number) {
    const arabicNumerals = [
      '٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'
    ];
    String numberStr = number.toString();
    return numberStr.split('').map((digit) => arabicNumerals[int.parse(digit)]).join('');
  }

  Widget _buildGomaaContainer(String text, String hadith, int index) {
    return Column(
      children: [
        ListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      textAlign: TextAlign.right,
                      text,
                      style: GoogleFonts.amiri(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                    SizedBox(height: 8),
                    Text(
                      textAlign: TextAlign.right,
                      hadith,
                      style: GoogleFonts.amiri(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color:Colors.white70
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xff212121),
                  border: Border.all(color:Color(0xff2e7d32), width: 3),
                ),
                child: Center(
                  child: Text(
                    '${convertToArabicNumerals(index)}',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
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
  }
}
