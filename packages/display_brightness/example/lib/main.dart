import 'dart:async';

import 'package:flutter/material.dart';
import 'package:display_brightness/display_brightness.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Display Brightness Example',
      home: const BrightnessPage(),
    );
  }
}

class BrightnessPage extends StatefulWidget {
  const BrightnessPage({super.key});

  @override
  State<BrightnessPage> createState() => _BrightnessPageState();
}

class _BrightnessPageState extends State<BrightnessPage> {
  late final DisplayBrightnessController _controller;
  StreamSubscription<double>? _subscription;
  double? _currentBrightness;
  double _sliderValue = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = DisplayBrightnessController();
    _currentBrightness = _controller.brightness;
    _sliderValue = _currentBrightness ?? _sliderValue;

    _subscription = _controller.onBrightnessChanged.listen((value) {
      setState(() {
        _currentBrightness = value;
        _sliderValue = value;
      });
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final brightnessText = _currentBrightness?.toStringAsFixed(2) ?? 'Unknown';

    return Scaffold(
      appBar: AppBar(title: const Text('Display Brightness')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Current Brightness',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  brightnessText,
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                const SizedBox(height: 32),
                Text(
                  'Set Brightness',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Slider(
                  value: _sliderValue,
                  min: 0.0,
                  max: 1.0,
                  divisions: 100,
                  label: _sliderValue.toStringAsFixed(2),
                  onChanged: (value) {
                    setState(() {
                      _sliderValue = value;
                      _currentBrightness = value;
                    });
                    _controller.setBrightness(value);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
