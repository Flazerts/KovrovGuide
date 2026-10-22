flutter build web --release --dart-define=FLUTTER_WEB_AUTO_DETECT=false
flutter run -d edge --dart-define=FLUTTER_WEB_AUTO_DETECT=false
cd build\web
netlify deploy --prod