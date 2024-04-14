import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:ertaklaraudio/data/cubit/male_cubit.dart';
import 'package:ertaklaraudio/data/ertak_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DetailsPage extends StatefulWidget {
  String name;
  String imgUrl;
  String audioUrl;
  int randomNumber;

  @override
  // TODO: implement hashCode

  DetailsPage(
      {required this.name,
      required this.imgUrl,
      required this.audioUrl,
      required this.randomNumber,
      Key? key})
      : super(key: key);

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  Duration? duration = Duration.zero;
  Duration? position = Duration.zero;
  final player = AudioPlayer();

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(minutes: 20),
    );
    player.onDurationChanged.listen((newDuration) {
      setState(() {
        duration = newDuration;
      });
      player.onPositionChanged.listen((newPosition) {
        setState(() {
          position = newPosition;
        });
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    player.release();
    player.dispose();
    _controller.dispose();
    super.dispose();
  }

  static List<String> animBg = [
    "assets/details/a.gif",
    "assets/details/b.gif",
    "assets/details/d.gif",
    "assets/details/e.gif",
    "assets/details/f.gif",
    "assets/details/g.gif",
    "assets/details/h.gif",
    "assets/details/i.gif",
    "assets/details/j.gif",
    "assets/details/k.gif",
    "assets/details/l.gif",
    "assets/details/m.gif",
    "assets/details/n.gif",
    "assets/details/o.gif",
    "assets/details/p.gif",
  ];

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    var size = mediaQueryData.size;
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(animBg[widget.randomNumber]),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                height: size.height * 0.08,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.only(left: size.height * 0.008),
                    child: Text(
                      widget.name,
                      style: TextStyle(
                        fontSize: size.height * 0.044,
                        color: Colors.white,
                        shadows:  [
                          Shadow(
                            color: Colors.black,
                            blurRadius: size.height*0.008,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  RotationTransition(
                    turns: Tween(begin: 0.0, end: 88.0).animate(_controller),
                    child: Container(
                      alignment: Alignment.center,
                      height: size.height*0.3,
                      width: size.height*0.3,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(widget.imgUrl),
                            fit: BoxFit.cover),
                        color: Colors.white38,
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        if (_controller.isAnimating) {
                          player.stop();
                          setState(() {
                            _controller.reset();
                            _controller.stop();
                            position = const Duration(seconds: 0);
                          });
                        } else {
                          MediaQueryData mediaQueryData =
                              MediaQuery.of(context);
                          var size = mediaQueryData.size;
                          var snackBar = SnackBar(
                            backgroundColor: Colors.white60,
                            elevation: 12,
                            shape: BeveledRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(size.height * 0.22),
                                topRight: Radius.circular(size.height * 0.22),
                              ),
                            ),
                            content: const Center(
                              child: Text(
                                "Iltimos kuting...",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          );
                          // ignore: use_build_context_synchronously
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          widget.name == "Alla Bolajon"
                              ? playSound2(widget.audioUrl)
                              : playSound(widget.audioUrl);
                          setState(() {
                            _controller.repeat();
                          });
                        }
                      },
                      icon: Icon(
                        _controller.isAnimating
                            ? CupertinoIcons.pause_solid
                            : CupertinoIcons.play_arrow_solid,
                        size: size.height*0.14,
                        color: Colors.white,
                        shadows: const [
                          Shadow(color: Colors.black, blurRadius: 80)
                        ],
                      ))
                ],
              ),
              Column(
                children: [
                  Slider(
                    activeColor: Colors.white,
                    inactiveColor: Colors.white54,
                    min: 0.0,
                    max: duration!.inSeconds.toDouble(),
                    value: position!.inSeconds.toDouble(),
                    onChanged: (value) async {
                      final position = Duration(seconds: value.toInt());
                      await player.seek(position);
                      await player.resume();
                    },
                  ),
                  Padding(
                    padding:  EdgeInsets.all(size.height*0.01),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          formatTime(position!),
                          style:  TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: size.height*0.034),
                        ),
                        Text(
                          formatTime(
                            duration!,
                          ),
                          style:  TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: size.height*0.034),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> playSound(String url) async {
    await player.play(UrlSource(url));
  }

  Future<void> playSound2(String url) async {
    await player.play(AssetSource(url));
  }

  String formatTime(Duration duration) {
    String twDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twDigits(duration.inHours);
    final minutes = twDigits(duration.inMinutes.remainder(60));
    final seconds = twDigits(duration.inSeconds.remainder(60));
    return [if (duration.inHours > 0) hours, minutes, seconds].join(':');
  }
}
