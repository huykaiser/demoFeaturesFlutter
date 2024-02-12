import 'dart:async';

import 'package:chewie/chewie.dart';
import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/material.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:share/share.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'TestFunctions/googleCalendar.dart';
import 'TestFunctions/imageShare.dart';
import 'TestFunctions/searchBar.dart';
import 'dart:io';

void main() {
  tz.initializeTimeZones();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      //home: MyCalendar(),
      home: ContentSharing(),
    );
  }
}

class ContentSharing extends StatefulWidget {
  @override
  _ContentSharingState createState() => _ContentSharingState();
}

class _ContentSharingState extends State<ContentSharing> {
  String sharedMediaPath = '';
  SharedMediaType? sharedMediaType;
  VideoPlayerController? _videoPlayerController;

  @override
  void initState() {
    super.initState();
    // Subscribe to receive shared intents
    ReceiveSharingIntent.getMediaStream().listen((List<SharedMediaFile> value) {
      setState(() {
        if (value.isNotEmpty) {
          final sharedMediaFile = value[0];
          sharedMediaPath = sharedMediaFile.path;
          sharedMediaType = sharedMediaFile.type;

          // Initialize video controller if it's a video
          if (sharedMediaType == SharedMediaType.video) {
            _videoPlayerController = VideoPlayerController.file(File(sharedMediaPath))
              ..initialize().then((_) {
                setState(() {
                  // Ensure that the VideoPlayer widget is rebuilt after initialization
                });
              })
              ..play();
          }
        } else {
          sharedMediaPath = '';
          sharedMediaType = null;
        }
      });
    });
  }

  @override
  void dispose() {
    // Dispose of video controller
    _videoPlayerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Media Receiver App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (sharedMediaPath.isNotEmpty)
              sharedMediaType == SharedMediaType.image
                  ? Image.file(
                File(sharedMediaPath),
                height: 200.0,
                width: 200.0,
                fit: BoxFit.cover,
              )
                  : sharedMediaType == SharedMediaType.video
                  ? AspectRatio(
                aspectRatio: _videoPlayerController!.value.aspectRatio,
                child: VideoPlayer(_videoPlayerController!),
              )
                  : Container(child: Text('No media shared.')),
            SizedBox(height: 16.0),
            Text(
              'Shared Media Path:',
              style: TextStyle(fontSize: 16.0),
            ),
            Text(
              sharedMediaPath,
              style: TextStyle(fontSize: 14.0),
            ),
          ],
        ),
      ),
    );
  }
}
