import 'package:flutter/material.dart';
import 'package:lablink/Models/DetailVariant.dart';

Color getBgColorForVariant(DetailVariant v) {
  switch (v) {
    case DetailVariant.date:
      return const Color(0xFFE9F7FB);
    case DetailVariant.time:
      return const Color(0xFFE9F9F4);
    case DetailVariant.location:
      return const Color(0xFFEFF5FF);
    case DetailVariant.id:
      return const Color(0xFFFFF7EA);
  }
}

Color getIconColorForVariant(DetailVariant v) {
  switch (v) {
    case DetailVariant.date:
      return const Color(0xFF00B4DB);
    case DetailVariant.time:
      return const Color(0xFF00BBA7);
    case DetailVariant.location:
      return const Color(0xFF6C7BFF);
    case DetailVariant.id:
      return const Color(0xFFFFA726);
  }
}
