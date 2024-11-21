import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget buildCircularImageButton(BuildContext context, String imagePath, String label, VoidCallback onPressed) {
  double screenWidth = MediaQuery.of(context).size.width;
  double containerWidth = screenWidth * 0.2;
  double containerHeight = screenWidth * 0.2;
  return Column(
    children: [
      GestureDetector(
        onTap: onPressed,
        child: Container(
          height: containerHeight,
          width: containerWidth,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: Color(0xff2e7d32), width: 3),
          ),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
      SizedBox(height: 8),
      Text(
        label,
        style: GoogleFonts.amiri(
          fontSize: 15,
          color: Colors.white,
        ),
      ),
    ],
  );
}
