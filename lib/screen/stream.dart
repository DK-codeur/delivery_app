import 'dart:async';
import 'package:delivery_app/providers/cmd.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StreamBuilderExample extends StatefulWidget {
  const StreamBuilderExample({Key key}) : super(key: key);

  @override
  StreamBuilderExampleState createState() => StreamBuilderExampleState();
}

class StreamBuilderExampleState extends State<StreamBuilderExample> {
  // The timer's value shown on app's UI.
  int _timerValue = 0;
  bool _paused = true;

  final Stream<int> _periodicStream = Stream.periodic(
    Duration(milliseconds: 10000), 
    (i) => i
  );


  int _previousStreamValue = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Stream'),),
      body: Container(
        
        alignment: Alignment.center,
        margin: EdgeInsets.all(8),
        child: StreamBuilder(
          stream: this._periodicStream,
          builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data != this._previousStreamValue) {
                print('Latest snapshot from stream: ${snapshot.data}');

                Provider.of<Commandes>(context).fetchAndSetCommande();

                this._previousStreamValue = snapshot.data;
                if (!_paused) {
                  this._timerValue++;
                }
              }
            }
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text("StreamBuilders can listen to a stream, and update UI "
                    "according to the stream's latest snapshot value.\n\n"
                    "In this demo we build a simple timer app by listening to a "
                    "stream that updates every second.\n"),
                Card(child: _buildTimerUI()),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildTimerUI() {
    return Column(
      children: <Widget>[
        Text(
          '$_timerValue',
          style: Theme.of(context).textTheme.display1,
        ),
        ButtonBar(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            IconButton(
              icon: Icon(this._paused ? Icons.play_arrow : Icons.pause),
              onPressed: () => setState(() => this._paused = !this._paused),
            ),
            IconButton(
              icon: Icon(Icons.stop),
              onPressed: () => setState(
                () {
                  this._timerValue = 0;
                  this._paused = true;
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}