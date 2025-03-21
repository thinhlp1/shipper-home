import 'package:base/utils/assets.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class FavoriteButton extends StatefulWidget {
  final bool isFavorite;
  final VoidCallback onFavoritePressed;

  const FavoriteButton({
    super.key,
    required this.isFavorite,
    required this.onFavoritePressed,
  });

  @override
  _FavoriteButtonState createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
      lowerBound: 1.0,
      upperBound: 1.3,
    );
  }

  void _onTap() async {
    widget.onFavoritePressed();

    // Phát âm thanh
    await _audioPlayer.play(AssetSource(Assets.SOUND_LIKE));

    _controller.forward().then((_) => _controller.reverse());
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onTap,
      child: ScaleTransition(
        scale: _controller,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(
            widget.isFavorite ? Icons.star : Icons.star_border,
            color:
                widget.isFavorite ? Colors.yellowAccent.shade700 : Colors.grey,
            size: 40,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }
}
