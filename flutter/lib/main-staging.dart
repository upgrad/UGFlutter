import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';

const String _kReloadChannelName = "reload";
const BasicMessageChannel<String> _kReloadChannel =
BasicMessageChannel<String>(_kReloadChannelName, const StringCodec());

void main() {
  _kReloadChannel.setMessageHandler(run);
  //unless the runApp is called in main, message sent to reload channel are not received here
  runApp(MaterialApp(
      home: RootWidget()
  ));
}

Future<String> run(String name) async {
  print(name);
  switch (name) {
    case "/path":
      runApp(MaterialApp(
          home: PathWidget()
      ));
      break;
    default:
      runApp(MaterialApp(
          home: RootWidget()
      ));
      break;
  }
  return '';
}

class RootWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Text(
            "Root Widget Staging",
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w300,
                fontStyle: FontStyle.normal),
          ),
        ),
        color: Colors.white,
      ),
    );
  }
}

class PathWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Text(
            "Path Widget Staging",
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w300,
                fontStyle: FontStyle.normal),
          ),
        ),
        color: Colors.white,
      ),
    );
  }
}
