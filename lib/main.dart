
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'package:flutter/material.dart';
import 'package:teste_sensor/utils/sensing.dart';

void main() => runApp(CARPMobileSensingApp());

class CARPMobileSensingApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CARP Mobile Sensing Demo',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: ConsolePage(title: 'CARP Mobile Sensing Demo'),
    );
  }
}

class ConsolePage extends StatefulWidget {
  ConsolePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  Console createState() => Console();
}

class Console extends State<ConsolePage> {
  String _log = '';
  Sensing sensing;

  void initState() {
    super.initState();
    sensing = Sensing();
    sensing.start();
  }

  void dispose() {
    sensing.stop();
    super.dispose();
  }

  Future<void> _showDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Aviso'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Aguarde até o fim do scanner!'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: StreamBuilder(
        stream: sensing.controller.events,
        builder: (context, AsyncSnapshot<Datum> snapshot) {
          if (snapshot.hasData) {
            Map<String, dynamic> sensorData = snapshot.data.toJson();
            _log = sensorData['max_lux'].toString();
            sensing.pause();
            return Center(child: Text(_log));
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _restart,
        //tooltip: 'Restart study & probes',
        child: Icon(Icons.play_arrow),
      ),
    );
  }

  void _restart() {
    if(sensing.isRunning){
      _showDialog();
    }else{
      sensing.resume();
    }
  }
}



