import 'dart:async';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:confetti/confetti.dart';
import 'package:ertaklaraudio/data/cubit/male_cubit.dart';
import 'package:ertaklaraudio/data/ertak_data.dart';
import 'package:ertaklaraudio/view/screens/details_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomePage extends StatefulWidget {
  int ranNum;

  HomePage(this.ranNum, {Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // final controller = PageController(viewportFraction: 0.8, keepPage: true);
  int activeIndex = 0;
  double _left = -500;
  bool view = false;
  double _right = 500;
  final controller = ConfettiController();
  late MaleCubit _cubit;

  @override
  void initState() {
    _cubit = context.read<MaleCubit>();
    _cubit.playSound("sounds/bg.mp3");
    moveTextToLeft();
    super.initState();
  }

  void moveTextToLeft() {
    if (widget.ranNum >= 0 && widget.ranNum <= 4) {
      Timer.periodic(const Duration(milliseconds: 40), (timer) {
        setState(() {
          _left += 1;
          if (_left >= MediaQuery.of(context).size.width) {
            _left = MediaQuery.of(context).size.width;
            timer.cancel();
          }
        });
      });
    } else {
      Timer.periodic(const Duration(milliseconds: 40), (timer) {
        setState(() {
          _right -= 1;
          if (_right <= -MediaQuery.of(context).size.width) {
            _right = MediaQuery.of(context).size.width;
            timer.cancel();
          }
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    var size = mediaQueryData.size;
    var number = Random();
    int randomNumber = number.nextInt(_cubit.animBg.length);
    return BlocBuilder<MaleCubit, bool>(
      builder: (context, state) {
        return Scaffold(
          floatingActionButton: Container(
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(30),
                ),
                image: DecorationImage(
                    image: AssetImage("assets/images/bottomBg.jpg"),
                    fit: BoxFit.cover)),
            child: FloatingActionButton(
              backgroundColor: Colors.transparent,
              onPressed: () {
                _cubit.playSound2("sounds/over.mp3");
                _cubit.startConfetti(controller, mounted);
              },
              child: Lottie.asset("assets/lottie/sehirgar.json"),
            ),
          ),
          body: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/bg.gif"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: ConfettiWidget(
                  confettiController: controller,
                  numberOfParticles: 50,
                  colors: const [Colors.green, Colors.greenAccent],
                  shouldLoop: false,
                  blastDirectionality: BlastDirectionality.explosive,
                ),
              ),
              SingleChildScrollView(
                child: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: size.height * 0.03),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CarouselSlider.builder(
                          itemCount: ErtakData.data.length,
                          itemBuilder: (BuildContext context, int itemIndex,
                                  int pageViewIndex) =>
                              InkWell(
                            onTap: () {
                              _cubit.player.stop();
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) => DetailsPage(
                                    name: ErtakData.data[itemIndex].name,
                                    imgUrl: ErtakData.data[itemIndex].imgUrl,
                                    audioUrl:
                                        ErtakData.data[itemIndex].audioUrl,
                                    randomNumber: randomNumber,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              height: size.height*1,
                              width: size.width*1,
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.white, width: size.width*0.004),
                                image: DecorationImage(
                                    image: NetworkImage(
                                        ErtakData.data[itemIndex].imgUrl),
                                    fit: BoxFit.cover),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Image.network(
                                height: 0,
                                cacheWidth: 1,
                                width: 0,
                                ErtakData.data[itemIndex].imgUrl,
                                loadingBuilder: (BuildContext context,
                                    Widget child,
                                    ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child;
                                  } else {
                                    return Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        value: loadingProgress
                                                    .expectedTotalBytes !=
                                                null
                                            ? loadingProgress
                                                    .cumulativeBytesLoaded /
                                                loadingProgress
                                                    .expectedTotalBytes!
                                            : null,
                                      ),
                                    );
                                  }
                                },
                                errorBuilder: (BuildContext context,
                                    Object exception, StackTrace? stackTrace) {
                                  return  Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.wifi_off,
                                          color: Colors.white,
                                          size: size.height*0.08,
                                        ),
                                         Text(
                                          "Internet Yo'q :(",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: size.height*0.02),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          options: CarouselOptions(
                            autoPlay: true,
                            enlargeCenterPage: true,
                            viewportFraction: 0.8,
                            aspectRatio: 1.3,
                            initialPage: 8,
                            onPageChanged: (index, reason) =>
                                setState(() => activeIndex = index),
                          ),
                        ),
                         SizedBox(
                          height: size.height*0.024,
                        ),
                        buildIndicator(),
                        SizedBox(
                          height: size.height*0.024,
                        ),
                        // Adjust spacing between sections
                        SizedBox(
                          height: size.height*0.3,
                          width: MediaQuery.of(context).size.width,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: ErtakData.data.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding:  EdgeInsets.all(size.height*0.008),
                                child: InkWell(
                                  onTap: () {
                                    _cubit.player.stop();
                                    Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                        builder: (context) => DetailsPage(
                                          name: ErtakData.data[index].name,
                                          imgUrl: ErtakData.data[index].imgUrl,
                                          audioUrl:
                                              ErtakData.data[index].audioUrl,
                                          randomNumber: randomNumber,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    height: size.height*0.3,
                                    width: size.width*0.5,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      border: Border.all(
                                          color: Colors.white, width: size.width*0.004),
                                      image: DecorationImage(
                                          image: NetworkImage(
                                              ErtakData.data[index].imgUrl),
                                          fit: BoxFit.cover),
                                    ),
                                    child: Image.network(
                                      height: 0,
                                      cacheWidth: 1,
                                      width: 0,
                                      ErtakData.data[index].imgUrl,
                                      loadingBuilder: (BuildContext context,
                                          Widget child,
                                          ImageChunkEvent? loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child;
                                        } else {
                                          return Center(
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                              value: loadingProgress
                                                          .expectedTotalBytes !=
                                                      null
                                                  ? loadingProgress
                                                          .cumulativeBytesLoaded /
                                                      loadingProgress
                                                          .expectedTotalBytes!
                                                  : null,
                                            ),
                                          );
                                        }
                                      },
                                      errorBuilder: (BuildContext context,
                                          Object exception,
                                          StackTrace? stackTrace) {
                                        return  Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.wifi_off,
                                                color: Colors.white,
                                                size: size.height*0.06,
                                              ),
                                              Text(
                                                "Internet Yo'q :(",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: size.height*0.02),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Center(
                child: SizedBox(
                  height: size.height*0.2,
                  width: size.width*0.06,
                  child: InkWell(
                    onTap: () {
                      _cubit.startConfetti(controller, mounted);
                      _cubit.playSound2("sounds/over.mp3");
                      print("mana");
                    },
                    child: AnimatedContainer(
                      height: size.height*0.2,
                      width: size.width*0.06,
                      duration: const Duration(milliseconds: 0),
                      transform: Matrix4.translationValues(
                          widget.ranNum >= 0 && widget.ranNum <= 4
                              ? _left
                              : _right,
                          0,
                          0),
                      child: Lottie.asset(_cubit.aniList[widget.ranNum],
                          height: size.height*0.2,
                          width: size.width*0.06, fit: BoxFit.cover),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  buildIndicator() => AnimatedSmoothIndicator(
        activeIndex: activeIndex,
        count: ErtakData.data.length,
        effect: ScrollingDotsEffect(
            dotWidth: 12,
            dotHeight: 12,
            activeDotColor: colors[rng.nextInt(colors.length)]),
      );
  var rng = Random();
  final colors = const [
    Colors.red,
    Colors.green,
    Colors.greenAccent,
    Colors.amberAccent,
    Colors.blue,
    Colors.amber,
  ];
}
