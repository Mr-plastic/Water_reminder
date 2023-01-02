import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'dart:async';
import 'package:dio/dio.dart';
import 'calendar.dart';

void main() async {
  runApp(MaterialApp(
    home: HomePage(),
    title: "water-reminder",
  ));
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class Water {
  late int amount = 0;
}

DateTime now = DateTime.now();
var date = now;

Water my = new Water();

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late AnimationController firstController;
  late Animation<double> firstAnimation;

  late AnimationController secondController;
  late Animation<double> secondAnimation;

  late AnimationController thirdController;
  late Animation<double> thirdAnimation;

  late AnimationController fourthController;
  late Animation<double> fourthAnimation;
  late Timer timer;

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(Duration(seconds: 5), (t) {
      getHttp();
      setState(() {});
    });
    firstController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1500));
    firstAnimation = Tween<double>(begin: 1.9, end: 2.1).animate(
        CurvedAnimation(parent: firstController, curve: Curves.easeInOut))
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          firstController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          firstController.forward();
        }
      });

    secondController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1500));
    secondAnimation = Tween<double>(begin: 1.8, end: 2.4).animate(
        CurvedAnimation(parent: secondController, curve: Curves.easeInOut))
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          secondController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          secondController.forward();
        }
      });

    thirdController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1500));
    thirdAnimation = Tween<double>(begin: 1.8, end: 2.4).animate(
        CurvedAnimation(parent: thirdController, curve: Curves.easeInOut))
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          thirdController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          thirdController.forward();
        }
      });

    fourthController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1500));
    fourthAnimation = Tween<double>(begin: 1.9, end: 2.1).animate(
        CurvedAnimation(parent: fourthController, curve: Curves.easeInOut))
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          fourthController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          fourthController.forward();
        }
      });

    Timer(Duration(seconds: 5), () {
      firstController.forward();
    });

    Timer(Duration(milliseconds: 1600), () {
      secondController.forward();
    });

    Timer(Duration(milliseconds: 800), () {
      thirdController.forward();
    });

    fourthController.forward();
  }

  @override
  void dispose() {
    firstController.dispose();
    secondController.dispose();
    thirdController.dispose();
    fourthController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        title: Text('${date.year}年${date.month}月${date.day}日喝水量'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            date = date.subtract(const Duration(days: 1));
            getHttp();
            print(date);
            setState(() {});
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.arrow_forward),
            onPressed: () {
              date = date.add(const Duration(days: 1));
              getHttp();
              setState(() {});
            },
          )
        ],
      ),
      backgroundColor: Colors.white,
      body: Stack(children: <Widget>[
        Center(
          child: Column(
            children: [
              SizedBox(
                height: 140,
                width: 140,
              ),
              new CircularPercentIndicator(
                radius: 100.0,
                lineWidth: 20.0,
                percent: my.amount / 2000, //
                center: new Text(
                  my.amount.toString() + "/2000",
                  style: new TextStyle(fontSize: 20),
                ),
                progressColor: my.amount > 999 ? Colors.green : Colors.red,
              ),
              Text(
                "喝水量",
                style: TextStyle(fontSize: 30),
              ),
              SizedBox(
                height: 100,
                width: 100,
              ),
            ],
          ),
        ),
        CustomPaint(
          painter: MyPainter(
            firstAnimation.value * (my.amount / 2000) * 3,
            secondAnimation.value * (my.amount / 2000) * 3,
            thirdAnimation.value * (my.amount / 2000) * 3,
            fourthAnimation.value * (my.amount / 2000) * 3,
          ),
          child: SizedBox(
            height: size.height,
            width: size.width,
          ),
        ),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
          ),
        ]),
      ]),
    );
  }
}

Future getHttp() async {
  try {
    var response = await Dio().get('http://140.115.59.3:10191/drinks?year=' +
        date.year.toString() +
        '&month=' +
        date.month.toString() +
        '&day=' +
        date.day.toString());
    Map<String, dynamic> data = (response.data);
    print(data);
    if (data.isEmpty) {
      my.amount = 0;
      print(my.amount);
    } else {
      my.amount = int.parse(data['amount']);
    }
    print(data['amount']);
    return data['amount'];
  } catch (e) {
    print(e);
  }
}

class MyPainter extends CustomPainter {
  final double firstValue;
  final double secondValue;
  final double thirdValue;
  final double fourthValue;

  MyPainter(
    this.firstValue,
    this.secondValue,
    this.thirdValue,
    this.fourthValue,
  );

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Color(0xff3B6ABA).withOpacity(.8)
      ..style = PaintingStyle.fill;

    var path = Path()
      ..moveTo(0, size.height / firstValue)
      ..cubicTo(size.width * .4, size.height / secondValue, size.width * .7,
          size.height / thirdValue, size.width, size.height / fourthValue)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
