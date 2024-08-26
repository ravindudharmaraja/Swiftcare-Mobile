import 'package:flutter/material.dart';

class GlowingButton extends StatefulWidget {
  final Color color1;
  final Color color2;
  final VoidCallback onTap;

  const GlowingButton({
    Key? key,
    this.color1 = Colors.cyan,
    this.color2 = Colors.greenAccent,
    required this.onTap,
  }) : super(key: key);

  @override
  _GlowingButtonState createState() => _GlowingButtonState();
}

class _GlowingButtonState extends State<GlowingButton> {
  var glowing = true;
  var scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapUp: (_) {
        setState(() {
          glowing = false;
          scale = 1.0;
        });
      },
      onTapDown: (_) {
        setState(() {
          glowing = true;
          scale = 1.1;
        });
        widget.onTap(); // Call the onTap function when button is tapped
      },
      child: AnimatedContainer(
        transform: Matrix4.identity()..scale(scale),
        duration: Duration(milliseconds: 200),
        height: 48,
        width: 160,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          gradient: LinearGradient(
            colors: [
              widget.color1,
              widget.color2,
            ],
          ),
          boxShadow: glowing
              ? [
                  BoxShadow(
                    color: widget.color1.withOpacity(0.6),
                    spreadRadius: 1,
                    blurRadius: 16,
                    offset: Offset(-8, 0),
                  ),
                  BoxShadow(
                    color: widget.color2.withOpacity(0.6),
                    spreadRadius: 1,
                    blurRadius: 16,
                    offset: Offset(8, 0),
                  ),
                  BoxShadow(
                    color: widget.color1.withOpacity(0.2),
                    spreadRadius: 16,
                    blurRadius: 32,
                    offset: Offset(-8, 0),
                  ),
                  BoxShadow(
                    color: widget.color2.withOpacity(0.2),
                    spreadRadius: 16,
                    blurRadius: 32,
                    offset: Offset(8, 0),
                  ),
                ]
              : [],
        ),
        child: Center(
          child: Text(
            "EMERGENCY BOOKING",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
