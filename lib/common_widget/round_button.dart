import 'package:flutter/material.dart';
import 'package:lib_ms/common/color__extention.dart';

class RoundButton extends StatefulWidget {
  final String title;
  final VoidCallback? onPressed;
  final bool isEnabled;
  final bool isLoading;

  const RoundButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.isEnabled = true,
    this.isLoading = false,
  });

  @override
  State<RoundButton> createState() => _RoundButtonState();
}

class _RoundButtonState extends State<RoundButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (widget.isEnabled && !widget.isLoading) {
      setState(() {
        _isPressed = true;
      });
      _animationController.forward();
    }
  }

  void _onTapUp(TapUpDetails details) {
    _resetAnimation();
  }

  void _onTapCancel() {
    _resetAnimation();
  }

  void _resetAnimation() {
    setState(() {
      _isPressed = false;
    });
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: widget.isEnabled && !widget.isLoading ? widget.onPressed : null,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 50,
              width: double.maxFinite,
              decoration: BoxDecoration(
                color: widget.isEnabled && !widget.isLoading
                    ? Tcolor.primary
                    : Tcolor.subTitle.withOpacity(0.3),
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: widget.isEnabled && !widget.isLoading
                    ? [
                        BoxShadow(
                          color: Tcolor.primary.withOpacity(0.3),
                          blurRadius: _isPressed ? 5 : 10,
                          offset: Offset(0, _isPressed ? 2 : 4),
                        ),
                      ]
                    : null,
              ),
              child: Center(
                child: widget.isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(
                        widget.title,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                          color: widget.isEnabled
                              ? Colors.white
                              : Colors.white.withOpacity(0.6),
                        ),
                      ),
              ),
            ),
          );
        },
      ),
    );
  }
}

////////////////////////////////////
class RoundLineButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  const RoundLineButton(
      {super.key, required this.title, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: getColor(Colors.white, Tcolor.primary),
        foregroundColor: getColor(Tcolor.primary, Colors.white),
        shadowColor:
            WidgetStateProperty.resolveWith((states) => Tcolor.primary),
        shape: WidgetStateProperty.resolveWith(
          (states) => RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
            side: BorderSide(
                width: 1,
                color: states.contains(WidgetState.pressed)
                    ? Colors.transparent
                    : Tcolor.primary),
          ),
        ),
      ),
      child: Text(
        title,
        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
      ),
    );
  }

  WidgetStateProperty<Color> getColor(Color color, Color colorPressed) {
    return WidgetStateProperty.resolveWith((states) =>
        states.contains(WidgetState.pressed) ? colorPressed : color);
  }
}

////////////////////////////////////
class MiniRoundButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  const MiniRoundButton(
      {super.key, required this.title, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor:
            WidgetStateProperty.resolveWith((states) => Tcolor.primary),
        foregroundColor:
            WidgetStateProperty.resolveWith((states) => Colors.white),
        shadowColor:
            WidgetStateProperty.resolveWith((states) => Tcolor.primary),
        minimumSize:
            WidgetStateProperty.resolveWith((states) => const Size(150, 35)),
        shape: WidgetStateProperty.resolveWith(
          (states) => RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      child: Text(
        title,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
    );
  }

  WidgetStateProperty<Color> getColor(Color color, Color colorPressed) {
    return WidgetStateProperty.resolveWith((states) =>
        states.contains(WidgetState.pressed) ? colorPressed : color);
  }
}
