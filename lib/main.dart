import 'package:flutter/material.dart';
import 'app_state.dart';
import 'screens/favorites_screen.dart';
import 'screens/home_screen.dart';
import 'screens/map_screen.dart';
import 'screens/places_screen.dart';
import 'screens/transport_screen.dart';
import 'theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppState.instance.load();
  runApp(const KovrovGuideApp());
}

class KovrovGuideApp extends StatelessWidget {
  const KovrovGuideApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Ковров — путеводитель',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: const GuideShell(),
      );
}

class GuideShell extends StatefulWidget {
  const GuideShell({super.key});

  @override
  State<GuideShell> createState() => _GuideShellState();
}

class _GuideShellState extends State<GuideShell> {
  int _index = 0;

  void _navigate(int index) => setState(() => _index = index);

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      HomeScreen(onNavigate: _navigate),
      const PlacesScreen(),
      const MapScreen(),
      const TransportScreen(),
      FavoritesScreen(onNavigate: _navigate),
    ];
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth >= 920) {
        return Scaffold(
          body: Row(children: [
            Container(
              width: 94,
              decoration: const BoxDecoration(color: GuideColors.greenDark),
              child: SafeArea(child: Column(children: [
                const SizedBox(height: 23),
                const Icon(Icons.explore_rounded, color: Colors.white, size: 30),
                const SizedBox(height: 28),
                Expanded(child: NavigationRail(
                  backgroundColor: Colors.transparent,
                  selectedIndex: _index,
                  onDestinationSelected: _navigate,
                  labelType: NavigationRailLabelType.all,
                  useIndicator: true,
                  indicatorColor: const Color(0xFFDAEDE3),
                  selectedIconTheme: const IconThemeData(color: GuideColors.greenDark),
                  unselectedIconTheme: const IconThemeData(color: Colors.white70),
                  selectedLabelTextStyle: const TextStyle(color: GuideColors.greenDark, fontSize: 10, fontWeight: FontWeight.w700),
                  unselectedLabelTextStyle: const TextStyle(color: Colors.white70, fontSize: 10),
                  destinations: const [
                    NavigationRailDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home_rounded), label: Text('Главная')),
                    NavigationRailDestination(icon: Icon(Icons.place_outlined), selectedIcon: Icon(Icons.place_rounded), label: Text('Места')),
                    NavigationRailDestination(icon: Icon(Icons.map_outlined), selectedIcon: Icon(Icons.map_rounded), label: Text('Карта')),
                    NavigationRailDestination(icon: Icon(Icons.directions_bus_outlined), selectedIcon: Icon(Icons.directions_bus_rounded), label: Text('Транспорт')),
                    NavigationRailDestination(icon: Icon(Icons.bookmark_border), selectedIcon: Icon(Icons.bookmark), label: Text('Избранное')),
                  ],
                )),
                const Padding(padding: EdgeInsets.only(bottom: 18), child: Text('КОВРОВ', style: TextStyle(color: Colors.white54, fontSize: 9, letterSpacing: 1.5, fontWeight: FontWeight.w800))),
              ])),
            ),
            Expanded(child: IndexedStack(index: _index, children: pages)),
          ]),
        );
      }
      return Scaffold(
        body: IndexedStack(index: _index, children: pages),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _index,
          onDestinationSelected: _navigate,
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home_rounded), label: 'Главная'),
            NavigationDestination(icon: Icon(Icons.place_outlined), selectedIcon: Icon(Icons.place_rounded), label: 'Места'),
            NavigationDestination(icon: Icon(Icons.map_outlined), selectedIcon: Icon(Icons.map_rounded), label: 'Карта'),
            NavigationDestination(icon: Icon(Icons.directions_bus_outlined), selectedIcon: Icon(Icons.directions_bus_rounded), label: 'Транспорт'),
            NavigationDestination(icon: Icon(Icons.bookmark_border), selectedIcon: Icon(Icons.bookmark), label: 'Избранное'),
          ],
        ),
      );
    });
  }
}
