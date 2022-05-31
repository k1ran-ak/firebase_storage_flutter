import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage_flutter/firebase_api.dart';
import 'package:firebase_storage_flutter/firebase_file.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class SearchPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SearchPageState();
  }
}

class SearchPageState extends State<SearchPage> {
  late Future<List<FirebaseFile>> futureFiles;
  final List<ListItem> _dropDownItems = [
    ListItem(1, 'All'),
    ListItem(2, 'Animals'),
    ListItem(3, 'Birds'),
    ListItem(4, 'People'),
    ListItem(5, 'Nature')
  ];
  late List<DropdownMenuItem<ListItem>> _dropDownMenuItems;
  late ListItem _itemSelected;
  String list = 'videos/';
  late Future<void> _initializeVideoPlayerFuture;
  late VideoPlayerController _controller;
  bool isplay = true;
  IconData icon = Icons.place_rounded;

  @override
  void initState() {
    super.initState();
    _dropDownMenuItems = buildDropDownMenuItems(_dropDownItems);
    _itemSelected = _dropDownItems[0];
    futureFiles = FirebaseApi.listAll(list);
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  List<DropdownMenuItem<ListItem>> buildDropDownMenuItems(List listItems) {
    List<DropdownMenuItem<ListItem>> items = [];
    for (ListItem listItem in listItems) {
      items.add(
        DropdownMenuItem(
          child: Text(listItem.name),
          value: listItem,
        ),
      );
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Videos'),
        actions: [
          DropdownButtonHideUnderline(
            child: DropdownButton(
              items: _dropDownMenuItems,
              value: _itemSelected,
              onChanged: (value) {
                setState(() {
                  _itemSelected = value as ListItem;
                  if (_itemSelected.name.toUpperCase() == 'ALL') {
                    list = 'videos';
                    futureFiles = FirebaseApi.listAll(list);
                  } else {
                    list = '${_itemSelected.name.toUpperCase()}/';
                    futureFiles = FirebaseApi.listAll(list);
                  }
                });
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            icon = icon == Icons.pause_circle
                ? Icons.play_circle
                : Icons.pause_circle; // Change icon and setState to rebuild
          });
          _controller.value.isPlaying
              ? _controller.pause()
              : _controller.play();
          // setState(() {
          // pause
          // if (_controller.value.isPlaying) {
          //   _controller.pause();
          // } else {
          //   // play
          //   _controller.play();
          // }
          // });
        },
        // icon
        //isplay ? Icons.play_arrow : Icons.pause_circle,
        child: Icon(icon),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: FutureBuilder<List<FirebaseFile>>(
            future: futureFiles,
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return const Center(child: CircularProgressIndicator());
                case ConnectionState.none:
                  return const Center(child: CircularProgressIndicator());
                default:
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text('Some Error Ocurred'),
                    );
                  }
                  final files = snapshot.data!;
                  return Column(children: [
                    buildHeader(files.length),
                    Expanded(
                      child: ListView.builder(
                        itemBuilder: ((context, index) {
                          var file = files[index];
                          return buildFile(context, file);
                        }),
                        scrollDirection: Axis.vertical,
                        itemCount: files.length,
                        shrinkWrap: true,
                      ),
                    )
                  ]);
              }
            },
          ),
        ),
      ),
    );
  }

  Widget buildHeader(int length) {
    return ListTile(
      tileColor: Colors.blue,
      leading: const SizedBox(
        height: 30,
        width: 30,
        child: Icon(Icons.file_copy_sharp),
      ),
      title: Text('$length Files'),
    );
  }

  Widget uploadedVideo(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
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
            return const Center(
                child: CircularProgressIndicator(color: Colors.red));
          }
        },
      ),
    );
  }

  Widget buildFile(BuildContext context, FirebaseFile file) {
    var videoLink = file.url;
    _controller = VideoPlayerController.network(
      videoLink,
    );
    _initializeVideoPlayerFuture = _controller.initialize();

    _controller.value.isPlaying ? _controller.pause() : _controller.play();

    // isplay ?  : _controller.pause();
    return ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            file.name,
            softWrap: true,
            overflow: TextOverflow.clip,
            style: const TextStyle(fontSize: 11),
          ),
          IconButton(
              onPressed: () {
                FirebaseStorage.instance.refFromURL(file.url).delete();
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Deleted Sucessfully')));
                setState(() {
                  futureFiles = FirebaseApi.listAll(list);
                });
              },
              icon: const Icon(Icons.delete))
        ],
      ),
      subtitle: uploadedVideo(context),
    );
  }

  Widget floatingButton(BuildContext context) {
    return FloatingActionButton(
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
    );
  }
}

class ListItem {
  int value;
  String name;

  ListItem(this.value, this.name);
}
