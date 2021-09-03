import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Animatable<Color?> background = TweenSequence<Color?>(
  [
    TweenSequenceItem(
      weight: 1.0,
      tween: ColorTween(
        begin: Colors.purple,
        end: Colors.blue,
      ),
    ),
    TweenSequenceItem(
      weight: 1.0,
      tween: ColorTween(
        begin: Colors.blue,
        end: Colors.tealAccent,
      ),
    ),
    TweenSequenceItem(
      weight: 1.0,
      tween: ColorTween(
        begin: Colors.tealAccent,
        end: Colors.purple,
      ),
    ),
  ],
);

Animatable<Color?> getBackground() {
  return background;
}