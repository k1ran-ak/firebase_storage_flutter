import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage_flutter/search.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class HomeApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomeAppState();
  }
}

class HomeAppState extends State<HomeApp> {
  late File selectedVideo;
  String videoLink = '';
  Categories selectedCategory = Categories.people;
  String selectedCategoriesString = '';
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  String defaultValue = Categories.animals.name.toUpperCase();
  bool isVideoSelected = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  Future getVideo(BuildContext context) async {
    var tempVideo = await ImagePicker().pickVideo(
        source: ImageSource.gallery, maxDuration: const Duration(seconds: 60));
    if (tempVideo != null) {
      isVideoSelected = true;
      selectedVideo = File(tempVideo.path);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Your video is ready to upload')));
    }
  }

  void uploadVideo(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(
        children: [
          const Text('Uploading in progress'),
          Container(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: const CircularProgressIndicator(),
          )
        ],
      ),
      duration: const Duration(seconds: 10),
    ));
    FirebaseStorage firebaseStorage = FirebaseStorage.instance;

    Reference rootReference = firebaseStorage.ref();

    if (defaultValue.isNotEmpty) {
      selectedCategoriesString = defaultValue;
    }

    debugPrint(selectedCategoriesString);

    for (var i = 0; i < 2; i++) {
      if (i == 1) {
        Reference videoReference = rootReference
            .child('videos')
            .child('Video - ${DateTime.now().toString()}');
        videoReference
            .putFile(selectedVideo, SettableMetadata(contentType: 'video/mp4'))
            .then((task) async {
          String link = await task.ref.getDownloadURL();
          debugPrint(link);
        });
      } else {
        Reference videoReference = rootReference
            .child(selectedCategoriesString)
            .child('Video - ${DateTime.now().toString()}');
        videoReference
            .putFile(selectedVideo, SettableMetadata(contentType: 'video/mp4'))
            .then((task) async {
          String link = await task.ref.getDownloadURL();
          debugPrint(link);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Upload Completed'),
            duration: Duration(seconds: 1),
          ));
          setState(() {
            videoLink = link;
          });
          _controller = VideoPlayerController.network(
            videoLink,
          );
          _initializeVideoPlayerFuture = _controller.initialize();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    isButtonEnabled();

    return Scaffold(
        appBar: AppBar(
          title: const Text('Upload Your Video'),
        ),
        body: SafeArea(
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  alignment: Alignment.center,
                  child: videoLink.isEmpty
                      ? const Text('Upload a video')
                      : uploadedVideo(),
                ),
                Visibility(
                  // child: Text(
                  //     'Selected Category : ${selectedCategory.toString().toUpperCase().split('.').last}'),
                  child:
                      Text('Selected Categories : $selectedCategoriesString'),
                  visible: videoLink.isNotEmpty,
                ),
                Container(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                      onPressed: () {
                        getVideo(context);
                      },
                      child: const Text('Pick a video')),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          'Choose a category',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ),
                      RadioListTile(
                          title: Text(Categories.animals.name.toUpperCase()),
                          value: Categories.animals.name.toUpperCase(),
                          groupValue: defaultValue,
                          onChanged: (value) {
                            setState(() {
                              defaultValue = value as String;
                            });
                          }),
                      RadioListTile(
                          title: Text(Categories.birds.name.toUpperCase()),
                          value: Categories.birds.name.toUpperCase(),
                          groupValue: defaultValue,
                          onChanged: (value) {
                            setState(() {
                              defaultValue = value as String;
                            });
                          }),
                      RadioListTile(
                          title: Text(Categories.people.name.toUpperCase()),
                          value: Categories.people.name.toUpperCase(),
                          groupValue: defaultValue,
                          onChanged: (value) {
                            setState(() {
                              defaultValue = value as String;
                            });
                          }),
                      RadioListTile(
                          title: Text(Categories.nature.name.toUpperCase()),
                          value: Categories.nature.name.toUpperCase(),
                          groupValue: defaultValue,
                          onChanged: (value) {
                            setState(() {
                              defaultValue = value as String;
                            });
                          }),
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  child: MaterialButton(
                      color: Colors.blue,
                      disabledColor: Colors.red,
                      disabledTextColor: Colors.white,
                      onPressed: () => isButtonEnabled()
                          ? uploadVideo(context)
                          : throwError(context),
                      child: const Text('Upload')),
                )
              ],
            ),
          ),
        ),
        floatingActionButton: floatingButton(context),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: 0,
          fixedColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(
              label: "Upload",
              icon: Icon(Icons.home),
            ),
            BottomNavigationBarItem(
              label: "Home",
              icon: Icon(Icons.search),
            ),
          ],
          onTap: (int itemIndex) {
            if (itemIndex == 1) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SearchPage()));
            }
          },
        ));
  }

  Widget? floatingButton(BuildContext context) {
    return videoLink.isNotEmpty
        ? FloatingActionButton(
            onPressed: () {
              setState(() {
                // pause
                if (_controller.value.isPlaying) {
                  _controller.pause();
                } else {
                  // play
                  _controller.play();
                }
              });
            },
            // icon
            child: Icon(
              _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
            ),
          )
        : null;
  }

  Widget uploadedVideo() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  void throwError(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Please select a video to upload'),
      duration: Duration(seconds: 1),
    ));
  }

  bool isButtonEnabled() {
    bool value = false;
    if (isVideoSelected) {
      value = true;
    }
    return value;
  }

  void whenButtonIsEnabled(BuildContext context) {
    Navigator.pop(context);
  }
}

enum Categories { people, nature, animals, birds }
