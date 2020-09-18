echo "generating theme file..."
bash ./lib/customizations/theme_generator/generate.sh
echo "generating g files..."
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs