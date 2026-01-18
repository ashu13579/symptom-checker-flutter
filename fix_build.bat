@echo off
echo Cleaning Flutter build cache...
flutter clean

echo.
echo Removing pub cache...
rd /s /q "%LOCALAPPDATA%\Pub\Cache\hosted\pub.dartlang.org" 2>nul

echo.
echo Getting dependencies...
flutter pub get

echo.
echo Running build runner...
flutter pub run build_runner build --delete-conflicting-outputs

echo.
echo Build fix complete! Now run: flutter run
pause