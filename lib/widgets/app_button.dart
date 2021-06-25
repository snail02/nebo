import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppButton extends StatelessWidget {
  final String text;
  final Function onPressed;
  final bool enabled;

  const AppButton({
    required this.text,
    required this.onPressed,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      color: enabled? Colors.blue : Colors.blueGrey,
      onPressed: enabled ? () => onPressed.call() : () {},
      splashColor: enabled? null: Colors.transparent ,
      highlightColor:enabled? null: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(14),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 17, horizontal: 16),
        child: Text(
          text,
          style: GoogleFonts.openSans(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.justify,
        ),
      ),
    );
  }
}
