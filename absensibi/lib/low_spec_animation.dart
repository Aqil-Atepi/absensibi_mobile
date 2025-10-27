import 'package:flutter/material.dart';

class LowSpecPageRoute<T> extends PageRouteBuilder<T> {
  LowSpecPageRoute({
    required WidgetBuilder builder,
    Duration duration = const Duration(milliseconds: 220),
    RouteSettings? settings,
  }) : super(
          settings: settings,
          transitionDuration: duration,
          reverseTransitionDuration: duration,
          pageBuilder: (context,_, __) => builder(context),
          transitionsBuilder: (_, anim, __, child) {
            final curved = CurvedAnimation(
              parent: anim,
              curve: Curves.easeOutCubic,
              reverseCurve: Curves.easeInCubic,
            );
            return FadeTransition(
              opacity: curved,
              child: SlideTransition(
                position:
                    Tween<Offset>(begin: const Offset(0.06, 0), end: Offset.zero)
                        .animate(curved),
                child: child,
              ),
            );
          },
        );
}
