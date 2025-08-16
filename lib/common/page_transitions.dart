import 'package:flutter/material.dart';

class SlidePageRoute<T> extends PageRouteBuilder<T> {
  final Widget child;
  final SlideDirection direction;
  final Duration duration;

  SlidePageRoute({
    required this.child,
    this.direction = SlideDirection.rightToLeft,
    this.duration = const Duration(milliseconds: 300),
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => child,
          transitionDuration: duration,
          reverseTransitionDuration: duration,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            Offset begin;
            switch (direction) {
              case SlideDirection.rightToLeft:
                begin = const Offset(1.0, 0.0);
                break;
              case SlideDirection.leftToRight:
                begin = const Offset(-1.0, 0.0);
                break;
              case SlideDirection.topToBottom:
                begin = const Offset(0.0, -1.0);
                break;
              case SlideDirection.bottomToTop:
                begin = const Offset(0.0, 1.0);
                break;
            }

            const end = Offset.zero;
            const curve = Curves.easeInOutCubic;

            var tween = Tween(begin: begin, end: end).chain(
              CurveTween(curve: curve),
            );

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        );
}

class FadePageRoute<T> extends PageRouteBuilder<T> {
  final Widget child;
  final Duration duration;

  FadePageRoute({
    required this.child,
    this.duration = const Duration(milliseconds: 300),
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => child,
          transitionDuration: duration,
          reverseTransitionDuration: duration,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        );
}

class ScalePageRoute<T> extends PageRouteBuilder<T> {
  final Widget child;
  final Duration duration;

  ScalePageRoute({
    required this.child,
    this.duration = const Duration(milliseconds: 300),
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => child,
          transitionDuration: duration,
          reverseTransitionDuration: duration,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const curve = Curves.easeInOutCubic;
            var tween = Tween(begin: 0.0, end: 1.0).chain(
              CurveTween(curve: curve),
            );

            return ScaleTransition(
              scale: animation.drive(tween),
              child: child,
            );
          },
        );
}

class SlideUpPageRoute<T> extends PageRouteBuilder<T> {
  final Widget child;
  final Duration duration;

  SlideUpPageRoute({
    required this.child,
    this.duration = const Duration(milliseconds: 400),
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => child,
          transitionDuration: duration,
          reverseTransitionDuration: duration,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(0.0, 1.0);
            const end = Offset.zero;
            const curve = Curves.easeOutCubic;

            var tween = Tween(begin: begin, end: end).chain(
              CurveTween(curve: curve),
            );

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        );
}

enum SlideDirection {
  rightToLeft,
  leftToRight,
  topToBottom,
  bottomToTop,
}

// Helper extension for easy navigation
extension NavigatorExtension on NavigatorState {
  Future<T?> pushSlide<T extends Object?>(
    Widget page, {
    SlideDirection direction = SlideDirection.rightToLeft,
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return push<T>(SlidePageRoute<T>(
      child: page,
      direction: direction,
      duration: duration,
    ));
  }

  Future<T?> pushFade<T extends Object?>(
    Widget page, {
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return push<T>(FadePageRoute<T>(
      child: page,
      duration: duration,
    ));
  }

  Future<T?> pushScale<T extends Object?>(
    Widget page, {
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return push<T>(ScalePageRoute<T>(
      child: page,
      duration: duration,
    ));
  }

  Future<T?> pushSlideUp<T extends Object?>(
    Widget page, {
    Duration duration = const Duration(milliseconds: 400),
  }) {
    return push<T>(SlideUpPageRoute<T>(
      child: page,
      duration: duration,
    ));
  }
}
