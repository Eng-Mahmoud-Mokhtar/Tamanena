import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dio/dio.dart';

class PrayerTimesPage extends StatefulWidget {
  const PrayerTimesPage({Key? key}) : super(key: key);

  @override
  _PrayerTimesPageState createState() => _PrayerTimesPageState();
}

class _PrayerTimesPageState extends State<PrayerTimesPage> {
  String? _city;
  String? _country;
  List<String>? _prayerTimes;
  bool _isLoading = true;
  final Dio _dio = Dio();

  @override
  void initState() {
    super.initState();
    _getLocation();
  }
  Future<void> _getLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showPermissionDeniedDialog();
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _showPermissionDeniedForeverDialog();
      return;
    }

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    await _fetchPrayerTimes(position.latitude, position.longitude);
    await _getAddressFromLatLng(position.latitude, position.longitude);
  }
  Future<void> _fetchPrayerTimes(double latitude, double longitude) async {
    try {
      final response = await _dio.get(
        'https://api.aladhan.com/v1/timings',
        queryParameters: {'latitude': latitude, 'longitude': longitude},
      );

      if (response.statusCode == 200) {
        final data = response.data;
        setState(() {
          _prayerTimes = [
            'الفجر: ${convertTo12HourFormat(data['data']['timings']['Fajr'])}',
            'الظهر: ${convertTo12HourFormat(data['data']['timings']['Dhuhr'])}',
            'العصر: ${convertTo12HourFormat(data['data']['timings']['Asr'])}',
            'المغرب: ${convertTo12HourFormat(data['data']['timings']['Maghrib'])}',
            'العشاء: ${convertTo12HourFormat(data['data']['timings']['Isha'])}',
          ];
          _isLoading = false; // انتهاء التحميل
        });
      } else {
        throw Exception('فشل في تحميل أوقات الصلاة');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
  Future<void> _getAddressFromLatLng(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
      Placemark place = placemarks[0];
      setState(() {
        _city = place.locality;
        _country = place.country;
      });
    } catch (e) {
      print(e);
    }
  }
  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color(0xff212121),
        title: const Text(
          'تم رفض الإذن',
          style: TextStyle(fontSize: 20, color: Colors.white),
          textAlign: TextAlign.right,
        ),
        content: const Text(
          'يرجى تمكين أذونات الموقع في إعدادات جهازك',
          style: TextStyle(fontSize: 15, color: Colors.white70),
          textAlign: TextAlign.right,
        ),
        actions: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            decoration: BoxDecoration(
              color: Color(0xffaa8428), // اللون الذي تريده
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              "حسناً",
              style: GoogleFonts.amiri(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showPermissionDeniedForeverDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color(0xff212121),
        title: const Text(
          'تم رفض الإذن بشكل دائم',
          style: TextStyle(fontSize: 20, color: Colors.white),
          textAlign: TextAlign.right,
        ),
        content: const Text(
          'يرجى تمكين أذونات الموقع في إعدادات جهازك',
          style: TextStyle(fontSize: 15, color: Colors.white70),
          textAlign: TextAlign.right,
        ),
        actions: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            decoration: BoxDecoration(
              color: Color(0xffaa8428), // اللون الذي تريده
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              "حسناً",
              style: GoogleFonts.amiri(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  final List<String> images = [
    'Images/freepik-export-20241008191635wxEj.png',
    'Images/freepik-export-20241008192028PKtW.jpeg',
    'Images/3d-stepping-stones-ocean-sunset.jpg',
    'Images/sea-sunset-with-stones-path.jpg',
    'Images/some-rocks-sea.jpg',
  ];

  String convertToArabicNumerals(String number) {
    const arabicNumerals = [
      '٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'
    ];

    return number.split('').map((digit) {
      return arabicNumerals[int.parse(digit)];
    }).join('');
  }

  String convertTo12HourFormat(String time) {
    List<String> parts = time.split(':');
    int hour = int.parse(parts[0]);
    String minute = parts[1];

    String period = hour >= 12 ? 'م' : 'ص';
    hour = hour % 12;
    hour = hour == 0 ? 12 : hour;

    return '${convertToArabicNumerals(hour.toString())}:${convertToArabicNumerals(minute)} $period';
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff212121),
      appBar: AppBar(
        backgroundColor: Color(0xff2e7d32),
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                'مواقيت الصلاة',
                style: GoogleFonts.amiri(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
              ),
              if (_city != null && _country != null)
                Text(
                  '$_city, $_country',
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: Colors.white54),
                )
            ],
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator()) // عرض المؤشر أثناء التحميل
          : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_prayerTimes != null)
            Expanded(
              child: ListView.builder(
                itemCount: _prayerTimes!.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            images[index % images.length],
                            fit: BoxFit.cover,
                            height: 120,
                            width: double.infinity,
                          ),
                        ),
                        Container(
                          height: 120,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.black.withOpacity(0.8),
                                Colors.transparent,
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 40),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _prayerTimes![index],
                                  style: GoogleFonts.amiri(
                                    fontSize: 23,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
