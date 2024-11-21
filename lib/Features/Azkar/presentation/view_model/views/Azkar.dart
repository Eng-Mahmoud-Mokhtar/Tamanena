import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tamanina/Features/Azkar/presentation/view_model/views/widgets/List.dart';
import 'package:tamanina/Features/Azkar/presentation/view_model/views/widgets/ElZekr.dart';

class Azkar extends StatelessWidget {
  const Azkar({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff1c1c1c),
      appBar: AppBar(
        backgroundColor: Color(0xff2e7d32),
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          'اذكار المسلم',
          style: GoogleFonts.amiri(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: AzkarList.length,
          itemBuilder: (context, index) {
            final zekrItem = AzkarList[index];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff333333),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                      side: const BorderSide(color: Color(0xff2e7d32), width: 2),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ElZekr(
                          zekr: zekrItem['zekr']!,
                          title: zekrItem['title']!,
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      zekrItem['title']!,
                      style: GoogleFonts.amiri(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            );
          },
        ),
      ),
    );
  }
}

