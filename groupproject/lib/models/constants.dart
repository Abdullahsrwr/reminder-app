import 'package:latlong2/latlong.dart';

class AppConstants {
  //https://api.mapbox.com/styles/v1/abdullahsrwr/clb2maty3000g14p4g8km9c5j/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiYWJkdWxsYWhzcndyIiwiYSI6ImNsYjJsdXowZTA1bTMzd25tejNqYmlucDUifQ.cwePGwtXq3Nw1M43xblH1A
  static const String mapBoxAccessToken =
      'pk.eyJ1IjoiYWJkdWxsYWhzcndyIiwiYSI6ImNsYjJsdXowZTA1bTMzd25tejNqYmlucDUifQ.cwePGwtXq3Nw1M43xblH1A';

  static const String mapBoxStyleId = 'clb2maty3000g14p4g8km9c5j';

  static final myLocation = LatLng(43.9456, -78.8968);
}
