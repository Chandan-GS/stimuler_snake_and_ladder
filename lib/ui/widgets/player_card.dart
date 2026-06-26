import 'dart:ui';
import 'package:flutter/material.dart';

class PlayerCard extends StatefulWidget {
  final int playerNum;
  final String playerName;
  final int pos;
  final bool isActive;
  final Color color;

  const PlayerCard({
    super.key,
    required this.playerNum,
    required this.playerName,
    required this.pos,
    required this.isActive,
    required this.color,
  });

  @override
  State<PlayerCard> createState() => _PlayerCardState();
}

class _PlayerCardState extends State<PlayerCard> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _pulseAnimation = Tween<double>(begin: 0.2, end: 0.8).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    if (widget.isActive) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(PlayerCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      _pulseController.repeat(reverse: true);
    } else if (!widget.isActive && oldWidget.isActive) {
      _pulseController.stop();
      _pulseController.value = 0.0;
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        final glowIntensity = widget.isActive ? _pulseAnimation.value : 0.0;
        
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              if (widget.isActive)
                BoxShadow(
                  color: widget.color.withValues(alpha: glowIntensity * 0.5),
                  blurRadius: 16,
                  spreadRadius: 2,
                ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: widget.isActive 
                      ? widget.color.withValues(alpha: 0.2 + (glowIntensity * 0.15)) 
                      : Colors.white.withValues(alpha: 0.05),
                  border: Border.all(
                    color: widget.isActive 
                        ? widget.color.withValues(alpha: 0.5 + (glowIntensity * 0.5)) 
                        : Colors.white.withValues(alpha: 0.1),
                    width: widget.isActive ? 2 : 1,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: widget.color,
                      child: Text(
                        'P${widget.playerNum}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.playerName,
                      style: TextStyle(
                        color: widget.isActive ? Colors.white : Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.pos == 0 ? 'Start' : 'Sq ${widget.pos}',
                      style: TextStyle(
                        color: widget.isActive ? Colors.white : Colors.white54,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
