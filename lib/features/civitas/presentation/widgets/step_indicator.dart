import 'package:flutter/material.dart';

// Tambah PulsingCircle widget
class _PulsingCircle extends StatefulWidget {
  final Widget child;
  
  const _PulsingCircle({required this.child});

  @override
  State<_PulsingCircle> createState() => _PulsingCircleState();
}

class _PulsingCircleState extends State<_PulsingCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: 1.0 + (_controller.value * 0.1),
          child: widget.child,
        );
      },
    );
  }
}

class StepIndicator extends StatelessWidget {
  final int currentStep;
  final List<String> steps;

  const StepIndicator({
    Key? key,
    required this.currentStep,
    required this.steps,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double circleSize = 43.0;
    const double lineHeight = 3.0;

    const activeColor = Color.fromRGBO(230, 68, 73, 100);
    const inactiveColor = Color(0xFFCFD8DC);
    const textActive = Color(0xFFE53935);
    const textInactive = Colors.grey;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Stack(
        children: [
          // 1. Lapisan Garis dengan Animasi
          Positioned(
            left: circleSize / 2,
            right: circleSize / 2,
            top: circleSize / 2 - (lineHeight / 2),
            child: Row(
              children: List.generate(steps.length - 1, (index) {
                bool isLineActive = index < currentStep;
                return Expanded(
                  child: TweenAnimationBuilder<double>(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    tween: Tween<double>(
                      begin: 0.0,
                      end: isLineActive ? 1.0 : 0.0,
                    ),
                    builder: (context, value, child) {
                      return Stack(
                        children: [
                          // Background line (inactive)
                          Container(
                            height: lineHeight,
                            color: inactiveColor,
                          ),
                          // Animated active line
                          FractionallySizedBox(
                            widthFactor: value,
                            child: Container(
                              height: lineHeight,
                              color: activeColor,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                );
              }),
            ),
          ),

          // 2. Lapisan Lingkaran dan Teks dengan Animasi
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(steps.length, (index) {
              bool isCompleted = index < currentStep;
              bool isCurrent = index == currentStep;

              Color borderColor = (isCompleted || isCurrent) ? activeColor : inactiveColor;
              Color fillColor = (isCompleted || isCurrent) ? activeColor : Colors.white;

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Lingkaran dengan Animasi Scale & Color
                  TweenAnimationBuilder<double>(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeOutBack,
                    tween: Tween<double>(
                      begin: 0.8,
                      end: 1.0,
                    ),
                    builder: (context, scale, child) {
                      Widget circle = Transform.scale(
                        scale: isCurrent ? scale : 1.0,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: circleSize,
                          height: circleSize,
                          decoration: BoxDecoration(
                            color: fillColor,
                            shape: BoxShape.circle,
                            border: Border.all(color: borderColor, width: 2),
                            boxShadow: isCurrent
                                ? [
                                    BoxShadow(
                                      color: activeColor.withOpacity(0.4),
                                      blurRadius: 8,
                                      spreadRadius: 2,
                                    ),
                                  ]
                                : [],
                          ),
                          child: Center(
                            child: _buildStepIcon(
                              isCompleted: isCompleted,
                              isCurrent: isCurrent,
                            ),
                          ),
                        ),
                      );
                      
                      // Wrap dengan PulsingCircle kalau current step
                      return isCurrent ? _PulsingCircle(child: circle) : circle;
                    },
                  ),
                  const SizedBox(height: 8),
                  // Label Teks dengan Animasi
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 300),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                      color: isCurrent || isCompleted ? textActive : textInactive,
                    ),
                    child: Text(steps[index]),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildStepIcon({
    required bool isCompleted,
    required bool isCurrent,
  }) {
    if (isCompleted) {
      return TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 400),
        curve: Curves.elasticOut,
        tween: Tween<double>(begin: 0.0, end: 1.0),
        builder: (context, value, child) {
          return Transform.scale(
            scale: value,
            child: const Icon(
              Icons.check,
              size: 18,
              color: Colors.white,
            ),
          );
        },
      );
    }

    if (isCurrent) {
      return TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
        tween: Tween<double>(begin: 0.5, end: 1.0),
        builder: (context, value, child) {
          return Transform.scale(
            scale: 0.5 + (value * 0.5),
            child: Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          );
        },
      );
    }

    return const SizedBox.shrink();
  }
}