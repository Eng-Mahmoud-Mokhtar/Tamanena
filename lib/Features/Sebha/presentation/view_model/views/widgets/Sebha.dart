import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Sebha extends StatefulWidget {
  @override
  _SebhaState createState() => _SebhaState();
}

class _SebhaState extends State<Sebha> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String convertToArabicNumerals(int number) {
    const arabicNumerals = [
      '٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'
    ];
    String numberStr = number.toString();
    return numberStr.split('').map((digit) => arabicNumerals[int.parse(digit)]).join('');
  }
  final Map<String, List<Map<String, dynamic>>> tasbeehs = {
    "بعد الصلاة": [
      {
        "text": "سبحان الله",
        "benefit": "تعظيم وتطهير للنفس",
        "count": 0,
        "maxCount": 33
      },
      {
        "text": "الحمد لله",
        "benefit": "شكر واعتراف بنعم الله",
        "count": 0,
        "maxCount": 33
      },
      {
        "text": "الله أكبر",
        "benefit": "يُجلب السكينة والطمانينة",
        "count": 0,
        "maxCount": 34
      },

    ],
    "طوال اليوم": [
      {
        "text": "الحمد لله",
        "benefit": "من أقوى وسائل الرزق، وسبب في زيادة النعم",
        "count": 0,
        "maxCount": 100
      },
      {
        "text": "سبحان الله وبحمده سبحان الله العظيم",
        "benefit": "قال ﷺ: كلمتان خفيفتان على اللسان، ثقيلتان في الميزان، حبيبتان إلى الرحمن (صحيح البخاري)",
        "count": 0,
        "maxCount": 100
      },
      {
        "text": "الصلاة على النبي ﷺ",
        "benefit": "تزيد من حب النبي، وتكون شفاعة يوم القيامة",
        "count": 0,
        "maxCount": 100
      },
      {
        "text": "أعوذ بالله من الشيطان الرجيم",
        "benefit": "حماية من وساوس الشيطان ومن الشرور",
        "count": 0,
        "maxCount": 10
      },
      {
        "text": "لا إله إلا الله وحده لا شريك له، له الملك وله الحمد وهو على كل شيء قدير",
        "benefit": "قال ﷺ: من قالها في يوم مئة مرة كانت له عدل عشر رقاب، وكتبت له مئة حسنة، ومحيت عنه مئة سيئة، وكانت له حرزًا من الشيطان (صحيح مسلم)",
        "count": 0,
        "maxCount": 100
      },
      {
        "text": "استغفر الله",
        "benefit": "استغفار الله يُكفّر الذنوب ويجلب الرزق",
        "count": 0,
        "maxCount": 100
      }
    ]
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tasbeehs.keys.length, vsync: this);
  }

  void _incrementCount(String category, int index) {
    setState(() {
      if (tasbeehs[category]![index]["count"] < tasbeehs[category]![index]["maxCount"]) {
        tasbeehs[category]![index]["count"]++;
      }
    });
  }

  void _showAddTasbeehDialog(String category) {
    String? newText;
    int? newMaxCount;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xff212121),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: TextField(
                  textAlign: TextAlign.right,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'اكتب',
                    hintStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: Colors.white70,
                  ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    counterText: "",
                  ),
                  onChanged: (value) {
                    newText = value;
                  },
                ),
              ),
              SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: TextField(
                  textAlign: TextAlign.right,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'العدد',
                    hintStyle: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: Colors.white70,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15), // مساحة داخلية
                    counterText: "",
                  ),
                  keyboardType: TextInputType.number,
                  maxLength: 3,
                  onChanged: (value) {
                    newMaxCount = int.tryParse(value);
                  },
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "إلغاء",
                style: GoogleFonts.amiri(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color:  Colors.white,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                if (newText != null && newMaxCount != null) {
                  setState(() {
                    tasbeehs[category]!.add({
                      "text": newText!,
                      "benefit": "",
                      "count": 0,
                      "maxCount": newMaxCount!,
                    });
                  });
                  Navigator.of(context).pop();
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                decoration: BoxDecoration(
                  color: Color(0xffaa8428),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  "إضافة",
                  style: GoogleFonts.amiri(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xff1c1c1c),
        appBar: AppBar(
          backgroundColor:Color(0xff2e7d32),
        centerTitle: true,
        title: Text(
          'التسبيح',
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
        bottom: TabBar(
          controller: _tabController,
          indicatorColor:  Color(0xffaa8428),
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          tabs: tasbeehs.keys.map((String category) {
            return Tab(
              child: Text(
                category,
                style: GoogleFonts.amiri(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            );
          }).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: tasbeehs.keys.map((String category) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
              itemCount: tasbeehs[category]!.length,
              itemBuilder: (context, index) {
                final tasbeeh = tasbeehs[category]![index];
                bool isMaxReached = tasbeeh["count"] >= tasbeeh["maxCount"];
                return GestureDetector(
                  onLongPress: () {
                  _showDeleteConfirmationDialog(category, index);},
                  onTap: () => _incrementCount(category, index),
                  child: Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    color: isMaxReached ? Color(0xffaa8428) : Color(0xff333333),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            tasbeeh["text"],
                            style: GoogleFonts.amiri(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10),
                          if (!isMaxReached)
                            Row(
                              children: [
                                Text(
                                  ' ${convertToArabicNumerals(tasbeeh["maxCount"])}', // العدد الأقصى على اليسار
                                  style: GoogleFonts.amiri(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CircleAvatar(
                                        radius: 30,
                                        backgroundColor:Color(0xff2e7d32),
                                        child: Text(
                                          '${convertToArabicNumerals(tasbeeh["count"])}',
                                          style: GoogleFonts.amiri(
                                            fontSize: 23,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 25),
                              ],
                            ),
                          if (isMaxReached)
                            Text(
                              tasbeeh["benefit"],
                              style: const TextStyle(fontSize: 20, color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }).toList(),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FloatingActionButton(
          onPressed: () {
            String currentCategory = tasbeehs.keys.toList()[_tabController.index]; // تحديد القسم النشط
            _showAddTasbeehDialog(currentCategory);
          },
          child: Icon(Icons.add,size: 25,color: Colors.white,),
          backgroundColor: Color(0xffaa8428),
        ),
      )
    );
  }
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  void _showDeleteConfirmationDialog(String category, int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xff212121),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'هل تريد الحذف ؟',
                style: GoogleFonts.amiri(
                  color: Colors.white,
                  fontSize: 20
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "إلغاء",
                style: GoogleFonts.amiri(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  tasbeehs[category]!.removeAt(index);
                });
                Navigator.of(context).pop();
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                decoration: BoxDecoration(
                  color: Color(0xffaa8428),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  "نعم",
                  style: GoogleFonts.amiri(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
