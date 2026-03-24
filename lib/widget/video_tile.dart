import 'package:flutter/material.dart';
import 'package:gal/gal.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

class VideoTile extends StatefulWidget {
  final int index;
  final Player? player;
  final VideoController? controller;
  final bool isExpanded;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onDoubleTap;

  const VideoTile({
    super.key,
    required this.index,
    required this.player,
    required this.controller,
    required this.isExpanded,
    required this.isSelected,
    required this.onTap,
    required this.onDoubleTap,
  });

  @override
  State<VideoTile> createState() => _VideoTileState();
}

class _VideoTileState extends State<VideoTile> {
  bool _isMuted = false;
  double _volumeLevel = 100.0;
  bool _showVolume = false;
  double _dragStartY = 0;
  double _dragStartVolume = 100;

  void _togglePlayPause() {
    final player = widget.player;
    if (player == null) return;
    if (player.state.playing) {
      player.pause();
    } else {
      player.play();
    }
  }

  Future<void> _takeScreenshot() async {
    final player = widget.player;
    if (player == null) return;
    try {
      final bytes = await player.screenshot();
      if (bytes == null) {
        if (mounted) _showSnack('Không thể chụp ảnh kênh ${widget.index + 1}');
        return;
      }
      final hasAccess = await Gal.hasAccess(toAlbum: true);
      if (!hasAccess) await Gal.requestAccess(toAlbum: true);
      await Gal.putImageBytes(bytes, album: 'StreamVideo');
      if (mounted)
        _showSnack('Đã lưu ảnh kênh ${widget.index + 1} vào thư viện!');
    } catch (e) {
      if (mounted) _showSnack('Lỗi chụp ảnh: $e');
    }
  }

  void _toggleMute() {
    final player = widget.player;
    if (player == null) return;

    setState(() {
      _isMuted = !_isMuted;
    });
    player.setVolume(_isMuted ? 0 : _volumeLevel);
  }

  void _onVolumeDragStart(DragStartDetails details) {
    setState(() {
      _showVolume = true;
      _dragStartY = details.globalPosition.dy;
      _dragStartVolume = _volumeLevel;
    });
  }

  void _onVolumeDragUpdate(DragUpdateDetails details) {
    final player = widget.player;
    if (player == null) return;
    final delta = _dragStartY - details.globalPosition.dy;
    final newVolume = (_dragStartVolume + delta * 0.8).clamp(0.0, 100.0);
    setState(() {
      _volumeLevel = newVolume;
      _isMuted = newVolume == 0;
    });
    player.setVolume(newVolume);
  }

  void _onVolumeDragEnd() {
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) setState(() => _showVolume = false);
    });
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.black87,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isInitialized = widget.controller != null;

    return GestureDetector(
      onTap: widget.onTap,
      onDoubleTap: widget.onDoubleTap,
      child: Container(
        margin: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          color: Colors.black87,
          border: Border.all(
            color: widget.isExpanded
                ? Colors.green
                : widget.isSelected
                ? Colors.lightGreenAccent
                : Colors.grey.shade800,
            width: widget.isSelected || widget.isExpanded ? 2 : 1,
          ),
        ),
        child: isInitialized
            ? Stack(
                children: [
                  Positioned.fill(
                    child: Video(
                      controller: widget.controller!,
                      fit: BoxFit.cover,
                      controls: NoVideoControls,
                    ),
                  ),
                  Positioned(
                    bottom: 4,
                    left: 4,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Nút Play/Pause
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: _togglePlayPause,
                          child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: StreamBuilder<bool>(
                              stream: widget.player?.stream.playing,
                              initialData:
                                  widget.player?.state.playing ?? false,
                              builder: (context, snapshot) {
                                final isPlaying = snapshot.data ?? false;
                                return Icon(
                                  isPlaying
                                      ? Icons.pause_circle_outline
                                      : Icons.play_circle_outline,
                                  color: Colors.white70,
                                  size: 24,
                                );
                              },
                            ),
                          ),
                        ),
                        // Nút Volume
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: _toggleMute,
                          onVerticalDragStart: _onVolumeDragStart,
                          onVerticalDragUpdate: _onVolumeDragUpdate,
                          onVerticalDragEnd: (_) => _onVolumeDragEnd(),
                          child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: Stack(
                              clipBehavior: Clip.none,
                              alignment: Alignment.center,
                              children: [
                                Icon(
                                  _isMuted
                                      ? Icons.volume_off
                                      : _volumeLevel < 50
                                      ? Icons.volume_down
                                      : Icons.volume_up,
                                  color: _isMuted
                                      ? Colors.redAccent
                                      : Colors.white70,
                                  size: 22,
                                ),
                                if (_showVolume)
                                  Positioned(
                                    bottom: 28,
                                    child: Container(
                                      width: 28,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 6,
                                        horizontal: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.black87,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            '${_volumeLevel.round()}%',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 8,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          SizedBox(
                                            height: 60,
                                            width: 8,
                                            child: RotatedBox(
                                              quarterTurns: -1,
                                              child: LinearProgressIndicator(
                                                value: _volumeLevel / 100,
                                                backgroundColor: Colors.white24,
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                      Color
                                                    >(
                                                      _volumeLevel < 30
                                                          ? Colors.redAccent
                                                          : Colors
                                                                .lightGreenAccent,
                                                    ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        // Nút Screenshot
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: _takeScreenshot,
                          child: const Padding(
                            padding: EdgeInsets.all(4),
                            child: Icon(
                              Icons.camera_alt_outlined,
                              color: Colors.white70,
                              size: 22,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 4,
                    right: 4,
                    child: Icon(
                      widget.isExpanded
                          ? Icons.fullscreen_exit
                          : Icons.fullscreen,
                      color: Colors.white70,
                      size: 20,
                    ),
                  ),
                  Positioned(
                    top: 4,
                    left: 4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 2,
                      ),
                      color: Colors.black54,
                      child: Text(
                        'CH${widget.index + 1}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : Stack(
                alignment: Alignment.center,
                children: [
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white70,
                      strokeWidth: 2,
                    ),
                  ),
                  Positioned(
                    top: 4,
                    left: 4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 2,
                      ),
                      color: Colors.black54,
                      child: Text(
                        'CH${widget.index + 1}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
