import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:ertaklaraudio/view/screens/alla_screen.dart';
import 'package:ertaklaraudio/view/screens/ertaklar_skreen.dart';
import 'package:ertaklaraudio/view/screens/home_page.dart';
import 'package:ertaklaraudio/view/screens/saqlanganlar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:lottie/lottie.dart';
import 'package:water_drop_nav_bar/water_drop_nav_bar.dart';

class BottomNawBar extends StatefulWidget {
  const BottomNawBar({Key? key}) : super(key: key);

  @override
  _BottomNawBarState createState() => _BottomNawBarState();
}

class _BottomNawBarState extends State<BottomNawBar> {
  final Color navigationBarColor = Colors.white;
  int selectedIndex = 0;
  late PageController pageController;
late bool ui=true;

  @override
  void initState() {
    super.initState();
    checkInternetConnection();
    pageController = PageController(initialPage: selectedIndex);
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    var size = mediaQueryData.size;
    Random random = Random();
    int randomNumber = random.nextInt(10);
    if(ui==true){
      return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          systemNavigationBarColor: navigationBarColor,
          systemNavigationBarIconBrightness: Brightness.light,
        ),
        child: Scaffold(
          // backgroundColor: Colors.grey,
          body: PageView(
            reverse: true,
            scrollDirection: Axis.vertical,
            physics: const NeverScrollableScrollPhysics(),
            controller: pageController,
            children: <Widget>[
              HomePage(randomNumber),
              const Ertaklar(),
              const AllaScreen(),
              const Saqlanganlar(),

            ],
          ),
          bottomNavigationBar: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/bottomBg.jpg"),fit: BoxFit.cover
              ),
            ),
            height: size.height*0.08,
            child: WaterDropNavBar(
              inactiveIconColor: Colors.white54,
              waterDropColor: Colors.white54,
              bottomPadding: size.height*0.002,
              backgroundColor: Colors.transparent,
              // const Color(0xFF1B4428)
              onItemSelected: (int index) {
                setState(() {
                  selectedIndex = index;
                });
                pageController.animateToPage(selectedIndex,
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOutSine);
              },
              selectedIndex: selectedIndex,
              barItems: <BarItem>[
                BarItem(
                  filledIcon: CupertinoIcons.house_fill,
                  outlinedIcon: Icons.water_drop,
                ),
                BarItem(
                    filledIcon: CupertinoIcons.book_solid,
                    outlinedIcon: Icons.water_drop),
                BarItem(
                  filledIcon: CupertinoIcons.moon_fill,
                  outlinedIcon: Icons.water_drop,
                ),
                BarItem(
                  filledIcon: Icons.bookmark,
                  outlinedIcon: Icons.water_drop,
                ),
              ],
            ),
          ),
        ),
      );

    }else {
      return  Scaffold(
        backgroundColor: Colors.grey,
        body: Center(
          child: Stack(
            children: [
              Align(
                  alignment: Alignment.center,
                  child: Lottie.asset("assets/lottie/caterror.json")),
              const Align(
                  alignment: Alignment(0.23, -0.33),
                  child: Text("Internet yo'q",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.grey),),),
              Align(
                alignment: const Alignment(0, 0.8),
                child: TextButton(
                  style: const ButtonStyle(side: MaterialStatePropertyAll(BorderSide(color: Colors.white,width: 2),),),
                  onPressed: () {
                    checkInternetConnection();
                  },
                  child: const Text("Takrorlash",style: TextStyle(color: Colors.white),),
                ),
              ),

            ],
          ),
        ),
      );

    }

  }

  void checkInternetConnection() async {
    var connectionResult = await InternetConnectionChecker().hasConnection;

    if (connectionResult == true) {
      setState(() {
        ui=true;
      });
    } else {
    setState(() {
      ui=false;
    });
    }
  }

}
