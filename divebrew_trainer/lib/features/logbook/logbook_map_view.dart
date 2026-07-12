import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../data/database.dart';

class LogbookMapView extends StatelessWidget {
  final List<DiveSession> sessions;
  final void Function(DiveSession) onMarkerTap;

  const LogbookMapView({
    super.key,
    required this.sessions,
    required this.onMarkerTap,
  });

  @override
  Widget build(BuildContext context) {
    // 위치 데이터가 있는 세션만 필터링
    final mapSessions = sessions.where((s) => s.lat != null && s.lon != null).toList();

    // 중심점 계산 (기본값: 대한민국 제주도 근방)
    LatLng center = const LatLng(33.24, 126.56);
    if (mapSessions.isNotEmpty) {
      center = LatLng(mapSessions.first.lat!, mapSessions.first.lon!);
    }

    return FlutterMap(
      options: MapOptions(
        initialCenter: center,
        initialZoom: 8.0,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.divebrew.trainer',
        ),
        MarkerLayer(
          markers: mapSessions.map((session) {
            return Marker(
              point: LatLng(session.lat!, session.lon!),
              width: 40,
              height: 40,
              child: GestureDetector(
                onTap: () => onMarkerTap(session),
                child: const Icon(
                  Icons.location_on,
                  color: Colors.red,
                  size: 40,
                ),
              ),
            );
          }).toList(),
        ),
        RichAttributionWidget(
          attributions: [
            TextSourceAttribution(
              'OpenStreetMap contributors',
              onTap: () {}, // 추후 외부 링크 오픈
            ),
          ],
        ),
      ],
    );
  }
}
