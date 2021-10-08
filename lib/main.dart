import 'dart:async';

import 'package:flutter/cupertino.dart';
import'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

void main()=>runApp(
  MyApp(),
);
////////////// stateless widget ////////////////

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      title: 'stop watch',
      home: HomePage(),
    );
  }
}
////////////// stateful widget ////////////////

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin{
  TabController tb;
  @override
  void initState(){
    tb = TabController(
      length: 2,
      vsync: this,
    );
    super.initState();
  }
  int hour = 0;
  int min = 0;
  int sec = 0;

///////////////////// numberPicker  HH widget /////////////////////

  Widget numberPickerHH(String timeFormat,int maxtime){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(bottom: 2.0
          ),
          child: Text(
            '$timeFormat',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 18.0,
            ),
          ),
        ),
        NumberPicker.integer(
          initialValue: hour,
          minValue: 0,
          maxValue: maxtime,
          listViewWidth: 50.0,
          onChanged: (val){
            setState(() {
              hour = val;
            });
          },
        ),
      ],
    );
  }// numberPickerHH

///////////////////// numberPicker  MM widget /////////////////////

  Widget numberPickerMM(String timeFormat,int maxtime){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(bottom: 2.0
          ),
          child: Text(
            '$timeFormat',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 18.0,
            ),
          ),
        ),
        NumberPicker.integer(
          initialValue: min,
          minValue: 0,
          maxValue: maxtime,
          onChanged: (val){
            setState(() {
              min = val;
            });
          },
        ),
      ],
    );
  }// numberPickerMM

///////////////////// numberPicker  SS widget ///////////////////

  Widget numberPickerSS(String timeFormat,int maxtime){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(bottom: 2.0
          ),
          child: Text(
            '$timeFormat',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 18.0,
            ),
          ),
        ),
        NumberPicker.integer(
          initialValue: sec,
          minValue: 0,
          maxValue: maxtime,
          listViewWidth: 50.0,
          onChanged: (val){
            setState(() {
              sec = val;
            });
          },
        ),
      ],
    );
  }// numberPickerSS

  bool started = true;
  bool stoped = true;
  String timeToDisplay = "";
  int timeForTimmer;
  bool caceltimmer = false;

  ////////////////////////// start function /////////////////////////////////////////
  void start(){
    setState(() {
      started = false;
      stoped = false;
      caceltimmer = false;
    });
    timeForTimmer = ((hour*3600)+min*60 + sec);
    Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {
        if(timeForTimmer <1 || caceltimmer){
          t.cancel();
          Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context)=>HomePage(),
          ));
        }
        else if(timeForTimmer <60){
          timeToDisplay = timeForTimmer.toString();
          timeForTimmer = timeForTimmer - 1;
        }
        else if(timeForTimmer >= 60 && timeForTimmer < 3600){
          int m = timeForTimmer ~/ 60;
          int s = timeForTimmer -(m*60);
          timeToDisplay = m.toString() + ":" + s.toString();
          timeForTimmer = timeForTimmer-1;
        }
        else{
          int h = timeForTimmer ~/ 3600;
          int m = (timeForTimmer-(h*3600)) ~/ 60;
          int s = timeForTimmer - (h*3600)-(m*60);
          timeToDisplay = h.toString() + ":" + m.toString() + ":" + s.toString();
          timeForTimmer = timeForTimmer - 1;

        }
      });
    });

  }

  ///////////// stop function //////////////////////////////////
  void stop(){
    setState(() {
      timeToDisplay = "";
      started = true;
      stoped = true;
      caceltimmer = true;
    });

  }


////////////////////// timmer widget ////////////////////

  Widget timmer(){
    return Container(
      child: Column(
        children: <Widget>[
          Expanded(

            flex: 6,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                numberPickerHH('HH',23),
                numberPickerMM('MM',59),
                numberPickerSS('SS',59),

              ],
            ),
          ),
          Expanded(
            flex:1,
            child: Text(
                '$timeToDisplay',
              style: TextStyle(
                fontSize: 40.0,
                fontWeight: FontWeight.w700,

              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                RaisedButton(
                  padding: EdgeInsets.symmetric(
                    vertical: 12.0,
                    horizontal: 35.0,
                  ),
                  color: Colors.green,
                  onPressed: started?start:null,
                  child: Text(
                    'start',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                  elevation: 10.0,
                ),
                RaisedButton(
                  padding: EdgeInsets.symmetric(
                    vertical: 12.0,
                    horizontal: 35.0,
                  ),
                  color: Colors.green,
                  onPressed: stoped?null:stop,
                  child: Text(
                    'stop',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                  elevation: 10.0,
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }
////////////// stopWatch started from here ////////////////////////////
  int timeForStopWatch = 0;
  bool stopIsPressed = true;
  bool resetIsPressed = true;
  bool startIsPressed = true;
  String displayOnStopWatch = "00:00:00";

  /////////////////// startStopWatch function ///////////////////////////////

  void startStopWatch(){
    setState(() {
      startIsPressed = false;
      resetIsPressed = false;
      stopIsPressed = false;
    });
    Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {
        if(timeForStopWatch < 60){
          if(timeForStopWatch < 10){
            displayOnStopWatch = "00:00:0" + timeForStopWatch.toString();
          }else{
            displayOnStopWatch = "00:00:" + timeForStopWatch.toString();
          }
          timeForStopWatch = timeForStopWatch + 1;
        }
        else if(timeForStopWatch < 3600){
          int mm = timeForStopWatch ~/ 60;
          int ss = timeForStopWatch - (mm*60);
          displayOnStopWatch = "00:" + mm.toString() + ":" + ss.toString();
          timeForStopWatch = timeForStopWatch + 1;
        }
        else{
          int hh = timeForStopWatch ~/ 3600;
          int mm = (timeForStopWatch - hh*3600) ~/ 60;
          int ss = timeForStopWatch - (hh*3600 + mm*60);
          displayOnStopWatch = hh.toString() + ":" + mm.toString() + ":" + ss.toString();
          timeForStopWatch = timeForStopWatch + 1;
        }
      });
    });

  }

  void stopStopWatch(){
    setState(() {
      stopIsPressed = true;
      resetIsPressed = false;
    });


  }

  void resetStopWatch(){
    setState(() {
      startIsPressed = true;
      resetIsPressed = true;
      stopIsPressed = true;
      displayOnStopWatch = "00:00:00";
    });

  }



/////////////////////// stopwatch widget /////////////////////////////////////////////

  Widget stopWatch(){
    return Container(
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 6,
            child:Container(
              alignment: Alignment.center,
              child: Text(
                '$displayOnStopWatch',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 60.0,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[

                    RaisedButton(
                      onPressed: stopIsPressed ? null : stopStopWatch,
                      padding: EdgeInsets.symmetric(
                          vertical:15.0,
                        horizontal: 40.0,
                      ),
                      color: Colors.red,
                      child: Text(
                        'Stop',//////////// stop button ///////////
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                      elevation: 10.0,
                    ),
                    RaisedButton(
                      onPressed: resetIsPressed ? null : resetStopWatch,
                      padding: EdgeInsets.symmetric(
                        vertical:15.0,
                        horizontal: 40.0,
                      ),
                      color: Colors.teal,
                      child: Text(
                        'Reset',//////////// reset button ///////////
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                      elevation: 10.0,
                    ),
                  ],
                ),
                RaisedButton(
                  onPressed: startIsPressed ? startStopWatch : null,
                  padding: EdgeInsets.symmetric(
                    vertical:20.0,
                    horizontal: 80.0,
                  ),
                  color: Colors.green,
                  child: Text(
                    'Start',///////// start button /////////////
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                  elevation: 10.0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      ////// appBar ////////////

      appBar: AppBar(
        automaticallyImplyLeading: false, // to remove '<-' icon from the appbar
        title: Text(
          'Watch',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
        bottom: TabBar(
          tabs: <Widget>[
            Text(
              'Timer',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            Text(
              'StopWatch',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ],
          labelPadding: EdgeInsets.only(bottom: 10.0),
          labelStyle: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
          ),
          controller: tb,
        ),
        centerTitle: true,
      ),

      //////// body ///////////////

      body: TabBarView(
        children: <Widget>[
          timmer(),
          stopWatch(),
        ],
        controller: tb,
      ),
    );
  }
}

