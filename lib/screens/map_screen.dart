import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../data.dart';
import '../models.dart';
import '../theme.dart';
import '../widgets/guide_widgets.dart';
import 'place_detail_screen.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  void _openPlace(BuildContext context, Place place) => Navigator.of(context).push(MaterialPageRoute(builder: (_) => PlaceDetailScreen(placeId: place.id)));

  @override
  Widget build(BuildContext context) => SafeArea(child: Center(child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(padding: const EdgeInsets.fromLTRB(22, 22, 22, 12), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Eyebrow('Город на карте'),
            const SizedBox(height: 6),
            Text('Карта мест', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 6),
            Text('Нажимайте на метки, чтобы посмотреть подробную информацию о месте.', style: Theme.of(context).textTheme.bodyMedium),
          ])),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 22), child: Container(padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11), decoration: BoxDecoration(color: const Color(0xFFE6F0EA), borderRadius: BorderRadius.circular(13)), child: const Row(children: [Icon(Icons.wifi_rounded, size: 18, color: GuideColors.green), SizedBox(width: 9), Expanded(child: Text('Для отображения карты требуется интернет. Каталог доступен офлайн.', style: TextStyle(fontSize: 12, color: GuideColors.ink, height: 1.35)))]))),
          const SizedBox(height: 13),
          Expanded(child: Padding(padding: const EdgeInsets.fromLTRB(22, 0, 22, 14), child: ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: FlutterMap(
              options: const MapOptions(initialCenter: LatLng(56.3640, 41.3060), initialZoom: 12.2),
              children: [
                TileLayer(urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png', userAgentPackageName: 'ru.kovrov.guide'),
                MarkerLayer(markers: kPlaces.where((place) => place.coordinatesVerified).map((place) => Marker(
                  point: LatLng(place.latitude, place.longitude),
                  width: 46,
                  height: 54,
                  child: GestureDetector(
                    onTap: () => _openPlace(context, place),
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      Container(width: 39, height: 39, alignment: Alignment.center, decoration: BoxDecoration(color: GuideColors.green, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2), boxShadow: const [BoxShadow(color: Color(0x22000000), blurRadius: 5, offset: Offset(0, 2))]), child: Text(place.emoji, style: const TextStyle(fontSize: 19))),
                      Container(width: 2, height: 11, color: GuideColors.greenDark),
                    ]),
                  ),
                )).toList()),
                RichAttributionWidget(attributions: [TextSourceAttribution('© OpenStreetMap contributors', onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const _AttributionScreen())))]),
              ],
            ),
          ))),
          SizedBox(
            height: 112,
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(22, 0, 22, 14),
              scrollDirection: Axis.horizontal,
              itemCount: kPlaces.length,
              separatorBuilder: (_, __) => const SizedBox(width: 9),
              itemBuilder: (context, index) {
                final place = kPlaces[index];
                return SizedBox(
                  width: 245,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(17),
                    onTap: () => _openPlace(context, place),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(17),
                        border: Border.all(color: GuideColors.line),
                      ),
                      child: Row(children: [
                        Text(place.emoji, style: const TextStyle(fontSize: 25)),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(place.name, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: GuideColors.ink)),
                              const SizedBox(height: 3),
                              Text(place.coordinatesVerified ? place.category : 'Координаты уточняются', style: const TextStyle(fontSize: 10, color: GuideColors.muted)),
                            ],
                          ),
                        ),
                      ]),
                    ),
                  ),
                );
              },
            ),
          ),
        ]),
      )));
}

class _AttributionScreen extends StatelessWidget {
  const _AttributionScreen();
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('О карте')), body: const Padding(padding: EdgeInsets.all(22), child: Text('Карта предоставлена сервисом OpenStreetMap.')));
}