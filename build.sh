
#!/bin/bash
set -e

git clone --depth 1 --branch stable https://github.com/flutter/flutter.git /tmp/flutter
export PATH="/tmp/flutter/bin:$PATH"

flutter config --enable-web

echo "=== Current directory ==="
pwd
ls -la
find . -maxdepth 5 -name pubspec.yaml -print

cd frontend/frontend
flutter pub get
flutter build web --release
