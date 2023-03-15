import 'dart:async';
import 'package:flutter/material.dart';

class DebounceService {
  DebounceService({required this.milliseconds});

  final int milliseconds;
  Timer? _timer;

  bool isLoading() {
    return _timer?.isActive ?? false;
  }

  void run(VoidCallback action) {
    if (isLoading()) {
      _timer?.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}
