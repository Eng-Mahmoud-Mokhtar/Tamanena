import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tamanina/Features/FadlElSour/presentation/view_model/views/widgets/BestSourPage.dart';
import 'package:tamanina/Features/FadlElSour/presentation/view_model/views/widgets/List.dart';


class FadlElSour extends StatelessWidget {
  const FadlElSour({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff1c1c1c),
      appBar: AppBar(
        backgroundColor: Color(0xff2e7d32),
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          'فضائل السور',
          style: GoogleFonts.amiri(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: bestList.length,
          itemBuilder: (context, index) {
            final sourItem = bestList[index];
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
                        builder: (context) => BestSourPage(
                          sour: sourItem['sour']!,
                          title: sourItem['title']!,
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      sourItem['title']!,
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

