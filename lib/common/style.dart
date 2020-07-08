import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Style {
  static final headline = GoogleFonts.dosis(
      textStyle: _headline.copyWith(
    fontSize: 36,
  ));

  static final subhead = GoogleFonts.dosis(
      textStyle:_subhead.copyWith(
    fontSize: 24,
  ));

  static const _headline = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w700,
    fontStyle: FontStyle.italic,
  );

  static const _subhead = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w400,
  );
}
