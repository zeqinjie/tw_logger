import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:tw_logger/src/ui/tw_search_base.dart';
import 'package:tw_logger/tw_logger.dart';

class TWLoggerOverlay extends StatefulWidget {
  final TWLoggerOverlayConfigure configure;

  const TWLoggerOverlay._({
    required this.configure,
  });

  static OverlayEntry attachTo(
    BuildContext context, {
    bool rootOverlay = true,
    TWLoggerOverlayConfigure? configure,
  }) {
    if (!TWLoggerConfigure().open) {
      return OverlayEntry(builder: (context) => const SizedBox());
    }

    final entry = OverlayEntry(
      builder: (context) => TWLoggerOverlay._(
        configure: configure ?? TWLoggerOverlayConfigure.optional(),
      ),
    );
    Future.delayed(Duration.zero, () {
      if (!context.mounted) {
        return;
      }
      final overlay = Overlay.maybeOf(
        context,
        rootOverlay: rootOverlay,
      );
      if (overlay == null) {
        throw FlutterError(
          'TWLogger: No Overlay widget found',
        );
      }
      overlay.insert(entry);
    });
    return entry;
  }

  @override
  State<TWLoggerOverlay> createState() => _TWLoggerOverlayState();
}

class _TWLoggerOverlayState extends State<TWLoggerOverlay> {
  late double bottom = widget.configure.bottom;
  late double right = widget.configure.right;
  late Size buttonSize = widget.configure.buttonSize;

  late MediaQueryData screen;

  bool isOnRight = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    screen = MediaQuery.of(context);
    bottom += screen.padding.bottom;
    right += screen.padding.right;
  }

  Offset? lastPosition;

  void onPanUpdate(Offset localPosition) {
    final delta = lastPosition! - localPosition;

    bottom += delta.dy;
    right += delta.dx;

    lastPosition = localPosition;

    if (bottom < 0) {
      bottom = 0;
    }

    if (right < 0) {
      right = 0;
    }

    if (bottom + buttonSize.height > screen.size.height) {
      bottom = screen.size.height - buttonSize.height;
    }

    if (right + buttonSize.width > screen.size.width) {
      right = screen.size.width - buttonSize.width;
    }
    isOnRight = right < screen.size.width / 2;

    setState(() {});
  }

  /// When the pointer is lifted, reset the last position
  onPointerUp(PointerUpEvent event) {
    setState(() {
      if (widget.configure.adsorption) {
        final double screenWidth = screen.size.width;
        final double buttonWidth = buttonSize.width;
        if (isOnRight) {
          right = widget.configure.right + screen.padding.right;
        } else {
          right = screenWidth -
              buttonWidth -
              (widget.configure.right + screen.padding.left);
        }
      }
      if (bottom < widget.configure.bottom + screen.padding.bottom) {
        bottom = widget.configure.bottom + screen.padding.bottom;
      }
      if (bottom + buttonSize.height >
          screen.size.height - screen.padding.top) {
        bottom = screen.size.height - screen.padding.top - buttonSize.height;
      }
      lastPosition = null;
    });
  }

  /// When the pointer is pressed, set the last position to the current position
  onPointerDown(PointerDownEvent event) {
    setState(() {
      lastPosition = event.localPosition;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (widget.configure.draggable) {
      child = Positioned(
        right: right,
        bottom: bottom,
        child: Listener(
          onPointerMove: (event) => onPanUpdate(event.localPosition),
          onPointerDown: onPointerDown,
          onPointerUp: onPointerUp,
          child: Material(
            elevation: lastPosition == null ? 0 : 30,
            borderRadius: BorderRadius.all(Radius.circular(buttonSize.width)),
            child: TWLoggerButton(
              isOnRight: isOnRight,
              buttonSize: buttonSize,
            ),
          ),
        ),
      );
    } else {
      child = Positioned(
        right: widget.configure.right + screen.padding.right,
        bottom: widget.configure.bottom + screen.padding.bottom,
        child: TWLoggerButton(
          isOnRight: isOnRight,
          buttonSize: buttonSize,
        ),
      );
    }
    return child;
  }
}

class TWLoggerButton extends StatefulWidget {
  final bool isOnRight;
  final Size buttonSize;
  const TWLoggerButton({
    super.key,
    required this.isOnRight,
    required this.buttonSize,
  });

  @override
  TWLoggerButtonState createState() => TWLoggerButtonState();
}

class TWLoggerButtonState extends State<TWLoggerButton> {
  bool visible = true;

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      overlayColor: Colors.black,
      overlayOpacity: 0.5,
      backgroundColor: TWLoggerConfigure().themeColor,
      icon: Icons.rocket,
      elevation: 4.0,
      buttonSize: widget.buttonSize,
      childrenButtonSize: widget.buttonSize,
      activeIcon: Icons.rocket_launch,
      spaceBetweenChildren: 4.0,
      spacing: 4.0,
      visible: visible,
      direction:
          widget.isOnRight ? SpeedDialDirection.left : SpeedDialDirection.right,
      children: [
        SpeedDialChild(
          child: const Icon(Icons.insert_drive_file),
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          onTap: () => handleOnPressed(const TWRegularSearch()),
        ),
        SpeedDialChild(
          child: const Icon(Icons.error),
          backgroundColor: Colors.orange[300],
          foregroundColor: Colors.white,
          onTap: () => handleOnPressed(const TWCrashSearch()),
        ),
        SpeedDialChild(
          child: const Icon(Icons.network_ping_outlined),
          backgroundColor: Colors.purple[300],
          foregroundColor: Colors.white,
          onTap: () => handleOnPressed(const TWNetworkSearch()),
        ),
        SpeedDialChild(
          child: const Icon(Icons.close),
          backgroundColor: Colors.grey,
          foregroundColor: Colors.white,
          onTap: () => setState(() {
            visible = false;
          }),
        ),
      ],
    );
  }

  handleOnPressed(TWSearchBase searchScreen) async {
    setState(() {
      visible = false;
    });
    try {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => searchScreen,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          visible = true;
        });
      }
    }
  }
}
