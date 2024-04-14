import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MaleCubit extends Cubit<bool> {
  MaleCubit() : super(false);

  void getMale() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool malePreference = prefs.getBool('male') ?? false;
    emit(malePreference);
    print(malePreference);
  }
    List<String>animBg=[
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
  void setMale(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    prefs.setBool('male', value);
    emit(value);
    print(value);
  }
  final player = AudioPlayer();
  Future<void> playSound(String path) async {
    await player.stop();
    await player.play(AssetSource(path),);
  }
  Future<void> playSound2(String path) async {
    final player2 = AudioPlayer();

    await player2.play(AssetSource(path),);
  }
  Future<void> startConfetti(controller,mounted) async {
    controller.play();
    await Future.delayed(
      const Duration(seconds: 6),
    );
    if (mounted) {
      controller.stop();
    }
  }
  var aniList = [
    "assets/lottie/qalam.json", //o'ngdan  o'nga
    "assets/lottie/ari.json", //o'ngdan  o'nga
    "assets/lottie/toshbaqa.json", //o'ngdan chapga
    "assets/lottie/hello.json", //o'ngdan chapga
    "assets/lottie/car.json", //o'ngdan chapga
    "assets/lottie/qurbaqa.json", //chapdan chapga
    "assets/lottie/it.json", //chapdan chapga
    "assets/lottie/ajdarho.json", //chapdan chapga
    "assets/lottie/yalmogiz.json", //chapdan chapga
    "assets/lottie/cat.json", //chapdan chapga
  ];

}
