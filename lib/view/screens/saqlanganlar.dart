import 'dart:math';
import 'package:ertaklaraudio/data/cubit/male_cubit.dart';
import 'package:ertaklaraudio/data/cubit/saveItem_cubit.dart';
import 'package:ertaklaraudio/data/ertak_data.dart';
import 'package:ertaklaraudio/view/screens/details_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share/share.dart';

class Saqlanganlar extends StatefulWidget {
  const Saqlanganlar({Key? key}) : super(key: key);

  @override
  State<Saqlanganlar> createState() => _SaqlanganlarState();
}

class _SaqlanganlarState extends State<Saqlanganlar> {
  late MaleCubit _cubit;
  late SaveItemCubit _cubitIndex;
  List<String> itemIndex = [];

  @override
  void initState() {
    super.initState();
    _cubit = context.read<MaleCubit>();
    _cubitIndex = context.read<SaveItemCubit>();
    _cubit.playSound("sounds/bg.mp3");
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    var size = mediaQueryData.size;
    var number = Random();
    int randomNumber = number.nextInt(_cubit.animBg.length);
    return Scaffold(
      floatingActionButton: Container(
        decoration: const BoxDecoration(
            borderRadius:BorderRadius.all(Radius.circular(30),),
            image: DecorationImage(
                image: AssetImage("assets/images/bottomBg.jpg"),
                fit: BoxFit.cover)),
        child: FloatingActionButton(
          backgroundColor: Colors.transparent,
          onPressed: () {
            WidgetsBinding.instance.addPostFrameCallback(
                      (_) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlderDilaogNew(context);
                          },
                        );
                      },
                    );
          },
          child: const Icon(Icons.info,color: Colors.white,),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/bg.gif"), fit: BoxFit.cover),
        ),
        child: SafeArea(
          child: BlocBuilder<SaveItemCubit, List<String>>(
            builder: (context, state) {
              return Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        right: size.height * 0.008, left: size.height * 0.008),
                    child: Container(
                      alignment: Alignment.center,
                      height: size.height * 0.09,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/images/bottomBg.jpg"),
                            fit: BoxFit.cover),
                      ),
                      child: Text(
                        "Saqlandi",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.white60,
                            fontWeight: FontWeight.bold,
                            fontSize: size.height * 0.06),
                      ),
                    ),
                  ),
                  state.isEmpty
                      ? Center(
                          child: Padding(
                            padding: EdgeInsets.only(
                                right: size.height * 0.008,
                                left: size.height * 0.008,
                                top: size.height * 0.02),
                            child: Container(
                              height: size.height * 0.32,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                image: const DecorationImage(
                                    image: AssetImage(
                                        "assets/images/bottomBg.jpg"),
                                    fit: BoxFit.cover),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Center(
                                child: Text(
                                  "Saqlanganlar yo'q!",
                                  style: TextStyle(
                                    color: Colors.white60,
                                    fontWeight: FontWeight.bold,
                                    fontSize: size.height * 0.04,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      : Expanded(
                          child: ListView.builder(
                            itemCount: ErtakData.data.length,
                            itemBuilder: (context, index) {
                              if (state.contains(index.toString())) {
                                return Padding(
                                  padding: EdgeInsets.only(
                                      right: size.height * 0.008,
                                      left: size.height * 0.008,
                                      top: size.height * 0.02),
                                  child: Container(
                                    height: size.height * 0.32,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      image: const DecorationImage(
                                          image: AssetImage(
                                              "assets/images/bottomBg.jpg"),
                                          fit: BoxFit.cover),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            if (!state
                                                .contains(index.toString())) {
                                              setState(() {
                                                _cubitIndex.itemsIndex
                                                    .add(index.toString());
                                              });
                                              _cubitIndex.saveSelected(
                                                  _cubitIndex.itemsIndex);
                                            } else {
                                              _cubitIndex
                                                  .removeItem(index.toString());
                                            }
                                          },
                                          icon: Icon(
                                              CupertinoIcons.bookmark_solid,
                                              color: state.contains(
                                                      index.toString())
                                                  ? Colors.amber
                                                  : Colors.white60),
                                        ),
                                        ClipRect(
                                          child: Banner(
                                            color: const Color(0xFFE28E48),
                                            message: 'Ertaklar',
                                            location: BannerLocation.bottomEnd,
                                            child: Banner(
                                              color: const Color(0xFFE28E48),
                                              message: 'Ertaklar',
                                              location: BannerLocation.topStart,
                                              child: Banner(
                                                color: const Color(0xFFE28E48),
                                                message: 'Ertaklar',
                                                location:
                                                    BannerLocation.bottomStart,
                                                child: Banner(
                                                  color:
                                                      const Color(0xFFE28E48),
                                                  message: 'Ertaklar',
                                                  location:
                                                      BannerLocation.topEnd,
                                                  child: InkWell(
                                                    onTap: () {
                                                      setState(() {});
                                                      _cubit.player.stop();
                                                      Navigator.push(
                                                        context,
                                                        CupertinoPageRoute(
                                                          builder: (context) =>
                                                              DetailsPage(
                                                            name: ErtakData
                                                                .data[index]
                                                                .name,
                                                            imgUrl: ErtakData
                                                                .data[index]
                                                                .imgUrl,
                                                            audioUrl: ErtakData
                                                                .data[index]
                                                                .audioUrl,
                                                            randomNumber:
                                                                randomNumber,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    child: Container(
                                                      alignment: Alignment
                                                          .bottomCenter,
                                                      width: size.height * 0.28,
                                                      height: size.width * 0.5,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          image:
                                                              DecorationImage(
                                                            image: NetworkImage(
                                                              ErtakData
                                                                  .data[index]
                                                                  .imgUrl,
                                                            ),
                                                            fit: BoxFit.cover,
                                                          )),
                                                      child: Image.network(
                                                        height: 0,
                                                        cacheWidth: 1,
                                                        width: 0,
                                                        ErtakData
                                                            .data[index].imgUrl,
                                                        loadingBuilder:
                                                            (BuildContext
                                                                    context,
                                                                Widget child,
                                                                ImageChunkEvent?
                                                                    loadingProgress) {
                                                          if (loadingProgress ==
                                                              null) {
                                                            return child;
                                                          } else {
                                                            return Center(
                                                              child:
                                                                  CircularProgressIndicator(
                                                                color: Colors
                                                                    .white,
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
                                                        errorBuilder:
                                                            (BuildContext
                                                                    context,
                                                                Object
                                                                    exception,
                                                                StackTrace?
                                                                    stackTrace) {
                                                          return Center(
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Icon(
                                                                  Icons
                                                                      .wifi_off,
                                                                  color: Colors
                                                                      .white,
                                                                  size:
                                                                      size.height *
                                                                          0.06,
                                                                ),
                                                                Text(
                                                                  "Internet Yo'q :(",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          size.height *
                                                                              0.02),
                                                                ),
                                                              ],
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            Share.share('Assalomu aleykum!\n\nMen audio ertaklar tinglamoqdaman, sizgaham tavsiya qilaman.\nManzil:\nhttps://play.google.com/store/apps/details?id=uz.muslimsoft.ertaklaraudio');

                                          },
                                          icon: const Icon(Icons.share,
                                              color: Colors.white60),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              } else {
                                return const SizedBox();
                              }
                            },
                          ),
                        ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

Widget AlderDilaogNew(BuildContext context) {
  return AlertDialog(
    backgroundColor: Colors.white54,
    title: const Card(
      color: Colors.white54,
      elevation: 20,
      shadowColor: Colors.grey,
    ),
    content: const Text(
        "Dasturdagi ma'lumotlar audio.ziyonet.uz saytidan olinmoqda!",
        style: TextStyle(
            fontSize: 18, color: Colors.black, fontWeight: FontWeight.w600)),
    actions: [
      ElevatedButton(
        style: const ButtonStyle(
          backgroundColor: MaterialStatePropertyAll(Colors.grey),
        ),
        onPressed: () {
          Navigator.of(context).pop(false);
        },
        child: const Text(
          "Chiqsh",
          style: TextStyle(color: Colors.white),
        ),
      ),
    ],
  );
}
