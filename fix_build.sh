#!/bin/bash

echo "Cleaning Flutter build cache..."
flutter clean

echo ""
echo "Getting dependencies..."
flutter pub get

echo ""
echo "Running build runner..."
flutter pub run build_runner build --delete-conflicting-outputs

echo ""
echo "Build fix complete! Now run: flutter run"