import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'filter_bar.dart';

class FilterVideoSection extends StatefulWidget {
  final bool isActive;

  const FilterVideoSection({super.key, this.isActive = true});

  @override
  State<FilterVideoSection> createState() => _FilterVideoSectionState();
}

class _FilterVideoSectionState extends State<FilterVideoSection> {
  bool _showVideo = false;
  String _selectedBks = '30VZ';
  String _selectedKenh = 'Tất cả';

  // Quản lý media_kit players và controllers
  final List<Player?> _players = List.filled(4, null);
  final List<VideoController?> _controllers = List.filled(4, null);

  int? _expandedIndex;

  // Danh sách Kênh có sẵn
  final List<String> _listKenh = [
    'Tất cả',
    'Kênh 1',
    'Kênh 2',
    'Kênh 3',
    'Kênh 4',
  ];

  // Danh sách BKS mẫu
  final List<String> _listBks = [
    '30VZ',
    '29A-123.45',
    '30G-678.90',
    '51F-111.11',
    '43A-222.22',
  ];

  // ─── Lifecycle ───────────────────────────────────────

  @override
  void didUpdateWidget(covariant FilterVideoSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isActive != widget.isActive) {
      widget.isActive ? _resumeAllVideos() : _pauseAllVideos();
    }
  }

  @override
  void dispose() {
    for (var player in _players) {
      player?.dispose();
    }
    super.dispose();
  }

  // ─── Video Controls ──────────────────────────────────

  void _pauseAllVideos() {
    for (var player in _players) {
      player?.pause();
    }
  }

  void _resumeAllVideos() {
    if (!_showVideo) return;
    for (int i = 0; i < 4; i++) {
      final player = _players[i];
      if (player != null) {
        if (_expandedIndex != null) {
          if (i == _expandedIndex) player.play();
        } else {
          player.play();
        }
      }
    }
  }

  void _connectChannel(int i) {
    if (_players[i] != null) return;

    final url =
        'http://cameraxe.net:6604/hls/1_020260000062_${i}_1.m3u8?jsession=AE51616B33CE830CA0E37FE2CB9DCD74';

    // Tạo player mới của media_kit
    final player = Player();
    final controller = VideoController(player);

    _players[i] = player;
    _controllers[i] = controller;

    // Cấu hình http headers nếu cần (media_kit hỗ trợ qua httpHeaders argument)
    player.open(
      Media(
        url,
        httpHeaders: {
          'Cookie': 'JSESSIONID=AE51616B33CE830CA0E37FE2CB9DCD74',
          'Referer': 'https://cameraxe.net/',
        },
      ),
      play: true,
    );

    // Xử lý lỗi
    player.stream.error.listen((event) {
      // Tự động thử lại sau 3 giây
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) _reconnectChannel(i);
      });
    });

    setState(() {});
  }

  /// Huỷ controller cũ và kết nối lại kênh
  void _reconnectChannel(int i) {
    _players[i]?.dispose();
    _players[i] = null;
    _controllers[i] = null;
    _connectChannel(i);
  }

  void _playDemoVideo() {
    setState(() {
      _showVideo = true;

      for (int i = 0; i < 4; i++) {
        _players[i]?.dispose();
        _players[i] = null;
        _controllers[i] = null;
      }

      if (_selectedKenh == 'Tất cả') {
        _expandedIndex = null;
        for (int i = 0; i < 4; i++) {
          _connectChannel(i);
        }
      } else {
        int k = int.parse(_selectedKenh.replaceAll('Kênh ', '')) - 1;
        _expandedIndex = k;
        _connectChannel(k);
      }
    });
  }

  void _toggleExpand(int index) {
    setState(() {
      if (_expandedIndex == index) {
        _expandedIndex = null;
        // Bật lại các kênh khác
        for (int i = 0; i < 4; i++) {
          _connectChannel(i);
        }
      } else {
        _expandedIndex = index;
      }
    });
  }

  // ─── Video Tile (1 ô video) ──────────────────────────

  Widget _buildVideoTile(int index) {
    final controller = _controllers[index];
    final isInitialized = controller != null;
    final isExpanded = _expandedIndex == index;

    return GestureDetector(
      onTap: () => _toggleExpand(index),
      child: Container(
        margin: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          color: Colors.black87,
          border: Border.all(
            color: isExpanded ? Colors.green : Colors.grey.shade800,
            width: 1,
          ),
        ),
        child: isInitialized
            ? Stack(
                children: [
                  // Lấp đầy ô bằng video
                  Positioned.fill(
                    child: Video(
                      controller: controller,
                      fit: BoxFit.cover, // Ensures video fills the area
                      controls: NoVideoControls, // Tắt control mặc định
                    ),
                  ),
                  // Icon Zoom (góc dưới phải)
                  Positioned(
                    bottom: 4,
                    right: 4,
                    child: Icon(
                      isExpanded ? Icons.fullscreen_exit : Icons.fullscreen,
                      color: Colors.white70,
                      size: 20,
                    ),
                  ),
                  // Tên Kênh (góc trên trái)
                  _buildChannelLabel(index),
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
                  _buildChannelLabel(index),
                ],
              ),
      ),
    );
  }

  Widget _buildChannelLabel(int index) {
    return Positioned(
      top: 4,
      left: 4,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        color: Colors.black54,
        child: Text(
          'CH${index + 1}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // ─── Video Grid (lưới 2x2) ───────────────────────────

  Widget _buildVideoGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 300,
        width: double.infinity,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(12),
        ),
        child: _expandedIndex != null
            ? _buildVideoTile(_expandedIndex!)
            : Column(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(child: _buildVideoTile(0)),
                        Expanded(child: _buildVideoTile(1)),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(child: _buildVideoTile(2)),
                        Expanded(child: _buildVideoTile(3)),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  // ─── Build ───────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FilterBar(
          selectedBks: _selectedBks,
          selectedKenh: _selectedKenh,
          listBks: _listBks,
          listKenh: _listKenh,
          onBksChanged: (value) => setState(() => _selectedBks = value),
          onKenhChanged: (value) => setState(() => _selectedKenh = value),
          onPlay: _playDemoVideo,
        ),
        const SizedBox(height: 20),
        if (_showVideo) _buildVideoGrid(),
      ],
    );
  }
}
