import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ModifiedText extends StatelessWidget {
  const ModifiedText({
    super.key,
    required this.text,
    required this.color,
    required this.size,
    this.maxLines,
  });

  final String text;
  final Color color;
  final double size;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLines,
      overflow: maxLines != null ? TextOverflow.ellipsis : null,
      style: GoogleFonts.roboto(
        color: color,
        fontSize: size,
      ),
    );
  }
}