import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './ball.dart';
import './bat.dart';

enum Direction { up, down, right, left }

class PingPong extends StatefulWidget {
  @override
  _PingPongState createState() => _PingPongState();
}

class _PingPongState extends State<PingPong>
    with SingleTickerProviderStateMixin {
  int score = 0, cnt = 0;
  double width, height;
  double inc = 5;
  double actualInc = 5;
  double lr = 0.08;
  String label = "Start";
  //ball positions
  double ballPosX, ballPosY;

  final double diameter = 50.0;

  //Bat dimension
  double batWidth, batHeight;

  //Bat positions
  double batPosX = 0;

  Animation<double> animation;
  AnimationController controller;

  Direction vDir = Direction.down;
  Direction hDir = Direction.right;

  void initState() {
    super.initState();
    ballPosX = 0;
    ballPosY = 0;
    controller = AnimationController(
      duration: const Duration(minutes: 10000),
      vsync: this,
    );
    animation = Tween<double>(begin: 0, end: 100).animate(controller);
    animation.addListener(() {
      safeSetState(() {
        if (label == "Start") controller.stop();
        checkBorders();
        inc += (lr * lr * lr);
        ballPosX = hDir == Direction.right ? ballPosX + inc : ballPosX - inc;
        ballPosY = vDir == Direction.down ? ballPosY + inc : ballPosY - inc;
      });
      checkBorders();
    });
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        width = constraints.maxWidth;
        height = constraints.maxHeight;
        batWidth = width / 3;
        batHeight = height / 25;
        return Stack(
          children: <Widget>[
            Positioned(
              top: 30,
              right: 20,
              child: RaisedButton(
                elevation: 10,
                child: Text(label),
                onPressed: () => controlBtn(),
              ),
            ),
            Positioned(
              top: 0,
              right: 20,
              child: Text(
                "Score: " + (score < 10 ? '0' : '') + score.toString(),
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24.0,
                    color: Colors.green[300]),
              ),
            ),
            Positioned(
              child: Ball(),
              top: ballPosY,
              left: ballPosX,
            ),
            Positioned(
              bottom: 10,
              left: batPosX,
              child: GestureDetector(
                onHorizontalDragUpdate: (DragUpdateDetails details) =>
                    moveBat(details),
                child: Bat(
                  height: batHeight,
                  width: batWidth,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void showMessages(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Game Over",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
                color: Colors.black87,
              ),
            ),
            content: Text(
              "Your Score: " + score.toString() + "\nPlay Again?",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15.0,
                color: Colors.black,
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text("Yes"),
                onPressed: () {
                  setState(() {
                    ballPosX = 0;
                    ballPosY = 0;
                    inc = actualInc;
                    score = 0;
                  });
                  Navigator.of(context).pop();
                  controller.repeat();
                },
              ),
              FlatButton(
                child: Text("No"),
                onPressed: () {
                  Navigator.of(context).pop();
                  dispose();
                  SystemNavigator.pop();
                },
              ),
            ],
          );
        });
  }

  void checkBorders() {
    if (ballPosX <= 0 && hDir == Direction.left) {
      hDir = Direction.right;
    }

    if (ballPosX >= width - diameter && hDir == Direction.right) {
      hDir = Direction.left;
    }
    if (ballPosY <= 0 && vDir == Direction.up) {
      vDir = Direction.down;
    }

    if (ballPosY >= height - 60 - batHeight && vDir == Direction.down) {
      if (ballPosX >= batPosX - diameter &&
          ballPosX <= batPosX + batWidth + diameter) {
        vDir = Direction.up;
        score++;
      } else {
        if (cnt <= 40) {
          cnt++;
        } else {
          cnt = 0;
          controller.stop();
          showMessages(context);
        }
      }
    }
  }

  void moveBat(DragUpdateDetails details) {
    safeSetState(() {
      batPosX += details.delta.dx;
      batPosX = max(0, batPosX);
      batPosX = min(width - batWidth, batPosX);
    });
  }

  void controlBtn() {
    setState(() {
      if (label == "Start") {
        label = "Pause";
        controller.forward();
      } else {
        controller.stop();
        label = "Start";
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void safeSetState(Function function) {
    if (controller.isAnimating && mounted) {
      setState(() {
        function();
      });
    }
  }
}
