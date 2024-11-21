import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class NameOfAllah {
  final String name;
  final String meaning;

  NameOfAllah({required this.name, required this.meaning});

  factory NameOfAllah.fromJson(Map<String, dynamic> json) {
    return NameOfAllah(
      name: json['name'],
      meaning: json['en']['meaning'],
    );
  }
}

class NamesOfAllahPage extends StatefulWidget {
  const NamesOfAllahPage({super.key});

  @override
  _NamesOfAllahPageState createState() => _NamesOfAllahPageState();
}

class _NamesOfAllahPageState extends State<NamesOfAllahPage> {
  bool isConnected = true;
  Future<List<NameOfAllah>>? _futureNames;
  final Dio _dio = Dio();

  @override
  void initState() {
    super.initState();
    checkConnection();
  }

  Future<List<NameOfAllah>> fetchNames() async {
    try {
      final response = await _dio.get('http://api.aladhan.com/v1/asmaAlHusna');
      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = response.data['data'];
        return jsonResponse.map((nameData) => NameOfAllah.fromJson(nameData)).toList();
      } else {
        throw Exception('فشل في تحميل الأسماء');
      }
    } catch (e) {
      throw Exception('حدث خطأ أثناء الاتصال بالخادم');
    }
  }

  String convertToArabicNumerals(int number) {
    const arabicNumerals = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    String numberStr = number.toString();
    return numberStr.split('').map((digit) => arabicNumerals[int.parse(digit)]).join('');
  }

  void checkConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      isConnected = (connectivityResult != ConnectivityResult.none);
      if (isConnected) {
        _futureNames = fetchNames();
      }
    });

    Connectivity().onConnectivityChanged.listen((result) {
      setState(() {
        isConnected = result != ConnectivityResult.none;
        if (isConnected) {
          _futureNames = fetchNames();
        }
      });
    });
  }

  Widget buildErrorUI() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error, color: Colors.red, size: 50),
          SizedBox(height: 10),
          Text(
            'يرجى التحقق من الاتصال بالإنترنت',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff212121),
      appBar: AppBar(
        backgroundColor: Color(0xff2e7d32),
        centerTitle: true,
        title: Text(
          'أسماء الله الحسنى',
          style: GoogleFonts.amiri(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: isConnected
            ? FutureBuilder<List<NameOfAllah>>(
          future: _futureNames,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return buildErrorUI();
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return buildErrorUI();
            } else {
              final names = snapshot.data!;
              return ListView.builder(
                itemCount: names.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              names[index].name,
                              style: GoogleFonts.amiri(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              padding: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xff212121),
                                border: Border.all(color: Color(0xff2e7d32), width: 3),
                              ),
                              child: Center(
                                child: Text(
                                  '${convertToArabicNumerals(index + 1)}',
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
                },
              );
            }
          },
        )
            : buildErrorUI(),
      ),
    );
  }
}
