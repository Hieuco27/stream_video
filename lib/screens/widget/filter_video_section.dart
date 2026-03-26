import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'filter_bar.dart';
import 'video_tile.dart';

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
  int? _selectedIndex;

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

  Future<void> _connectChannel(int i) async {
    if (_players[i] != null) return;

    final url =
        'http://cameraxe.net:6604/hls/1_020260000062_${i}_1.m3u8?jsession=8E0DAFBC0B9372413DD55E315697A481';

    // Cấu hình player
    final player = Player(
      configuration: const PlayerConfiguration(bufferSize: 16 * 1024 * 1024),
    );
    final controller = VideoController(player);

    _players[i] = player;
    _controllers[i] = controller;

    // Tối ưu live stream: chỉ giới hạn đọc trước, TUYỆT ĐỐI KHÔNG tắt cache (cache='no')
    if (player.platform is NativePlayer) {
      final native = player.platform as NativePlayer;
      await native.setProperty('demuxer-readahead-secs', '8');
    }

    // NẾU trong lúc await mà người dùng đổi kênh khác -> _players[i] đã bị huỷ dở -> thoát để tránh lỗi Exception Disposed
    if (!mounted || _players[i] != player) return;

    // Cấu hình http
    player.open(
      Media(
        url,
        httpHeaders: {
          'Cookie': 'JSESSIONID=8E0DAFBC0B9372413DD55E315697A481',
          'Referer': 'https://cameraxe.net/',
        },
      ),
      play: true,
    );

    setState(() {});
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

  Widget _buildVideoTile(int index) {
    return VideoTile(
      key: ValueKey('channel_$index'),
      index: index,
      player: _players[index],
      controller: _controllers[index],
      isExpanded: _expandedIndex == index,
      isSelected: _selectedIndex == index,
      onTap: () => setState(() => _selectedIndex = index),
      onDoubleTap: () => _toggleExpand(index),
    );
  }

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
