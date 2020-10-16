import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

typedef void OnError(Exception exception);

void main() {
  runApp(new MaterialApp(home: new MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Duration _duration = new Duration();
  Duration _position = new Duration();
  AudioPlayer advancedPlayer;
  AudioCache audioCache;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    initPlayer();
  }

  void initPlayer() {
    advancedPlayer = new AudioPlayer();
    audioCache = new AudioCache(fixedPlayer: advancedPlayer);

    advancedPlayer.durationHandler = (d) => setState(() {
          _duration = d;
        });

    advancedPlayer.positionHandler = (p) => setState(() {
          _position = p;
        });
  }

  String localFilePath;

  Widget _tab(List<Widget> children) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: children
              .map((w) => Container(child: w, padding: EdgeInsets.all(6.0)))
              .toList(),
        ),
      ),
    );
  }

  Widget slider() {
    return Slider(
        value: _position.inSeconds.toDouble(),
        min: 0.0,
        max: _duration.inSeconds.toDouble(),
        onChanged: (double value) {
          setState(() {
            seekToSecond(value.toInt());
            value = value;
          });
        });
  }

  Widget playpause() {
    return isPlaying
        ? Icon(
            Icons.pause,
            size: 35.0,
          )
        : Icon(
            Icons.play_arrow,
            size: 35.0,
          );
  }

  Widget playButton() {
    return RawMaterialButton(
      onPressed: () {
        if (isPlaying) {
          advancedPlayer.pause();
          isPlaying = false;
        } else {
          audioCache.play('audio.mp3');
          isPlaying = true;
        }
      },
      elevation: 2.0,
      fillColor: Colors.white,
      child: playpause(),
      padding: EdgeInsets.all(15.0),
      shape: CircleBorder(),
    );
  }

  Widget localAsset() {
    return _tab([
      slider(),
      playButton(),
    ]);
  }

  void seekToSecond(int second) {
    Duration newDuration = Duration(seconds: second);

    advancedPlayer.seek(newDuration);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.indigoAccent,
          bottom: TabBar(
            tabs: [
              Tab(text: 'Local Asset'),
            ],
          ),
          title: Text(
            'Omkar\'s AudioPlayer',
            style: TextStyle(
                color: Colors.brown.shade900, fontWeight: FontWeight.bold),
          ),
        ),
        body: TabBarView(
          children: [localAsset()],
        ),
      ),
    );
  }
}
