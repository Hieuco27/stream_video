enum MapType {
  normal,
  satellite,
  terrain;

  String get url {
    switch (this) {
      case MapType.normal:
        return 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
      case MapType.satellite:
        return 'https://{s}.google.com/vt/lyrs=s&x={x}&y={y}&z={z}';
      case MapType.terrain:
        return 'https://{s}.google.com/vt/lyrs=p&x={x}&y={y}&z={z}';
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
        return [];
      case MapType.satellite:
      case MapType.terrain:
        return ['mt0', 'mt1', 'mt2', 'mt3'];
    }
  }
}
