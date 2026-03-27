enum MapType {
  normal,
  satellite,
  terrain;

  String get url {
    switch (this) {
      case MapType.normal:
        return 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
      case MapType.satellite:
        return 'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}';
      case MapType.terrain:
        return 'https://tile.opentopomap.org/{z}/{x}/{y}.png';
    }
  }

  String get label {
    switch (this) {
      case MapType.normal:
        return 'Đường phố';
      case MapType.satellite:
        return 'Vệ tinh';
      case MapType.terrain:
        return 'Địa hình';
    }
  }

  List<String> get subdomains {
    switch (this) {
      case MapType.normal:
      case MapType.satellite:
      case MapType.terrain:
        return [];
    }
  }
}
