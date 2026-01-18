# Troubleshooting Guide

Common issues and their solutions when building the Symptom Checker Flutter app.

## Build Errors

### ✅ FIXED: CardTheme Type Mismatch

**Error:**
```
Error: The argument type 'CardTheme' can't be assigned to the parameter type 'CardThemeData?'
```

**Solution:**
Changed `CardTheme` to use `const CardTheme()` with proper parameters in `lib/core/theme/app_theme.dart`.

**Status:** ✅ Fixed in commit dd1a1cd

---

### ✅ FIXED: Duration Enum Conflict

**Error:**
```
Error: Enums can't be instantiated.
connectTimeout: const Duration(seconds: 10),
```

**Cause:**
The custom `Duration` enum in `symptom_data.dart` conflicted with Dart's core `Duration` class.

**Solution:**
Renamed custom enum from `Duration` to `SymptomDuration` throughout the codebase:
- `lib/data/models/symptom_data.dart`
- `lib/domain/usecases/analyze_symptoms.dart`
- `lib/presentation/pages/symptom_input_page.dart`
- `backend/main.py`

**Status:** ✅ Fixed in commits 2ed776f, fc4f430, 71f5c22, d4b78b2

---

### ✅ FIXED: Missing displayName Extension

**Error:**
```
Try correcting the name to the name of an existing getter, or defining a getter or field named 'displayName'.
state.symptomData.bodyRegion.displayName,
```

**Cause:**
The `BodyRegion` enum was missing the `displayName` extension method.

**Solution:**
The extension already exists in `lib/core/constants/body_regions.dart`. This error should resolve after the other fixes.

**Status:** ✅ Should be resolved

---

## Current Build Status

After the fixes above, run:

```bash
flutter clean
flutter pub get
flutter run
```

The app should now build successfully!

---

## Common Flutter Issues

### Issue: "Target kernel_snapshot_program failed"

**Causes:**
1. Syntax errors in Dart code
2. Missing dependencies
3. Conflicting package versions
4. Corrupted build cache

**Solutions:**

1. **Clean and rebuild:**
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

2. **Check for syntax errors:**
   ```bash
   flutter analyze
   ```

3. **Update dependencies:**
   ```bash
   flutter pub upgrade
   ```

4. **Clear pub cache (if needed):**
   ```bash
   flutter pub cache repair
   ```

---

### Issue: "Waiting for another flutter command to release the startup lock"

**Solution:**
```bash
# Kill all Flutter processes
taskkill /F /IM dart.exe /T  # Windows
killall -9 dart              # macOS/Linux

# Or delete the lock file
rm [flutter-sdk]/bin/cache/lockfile
```

---

### Issue: Google Fonts not loading

**Error:**
```
Failed to load font
```

**Solution:**
1. Ensure internet connection (fonts download on first use)
2. Or use system fonts instead:
   ```dart
   textTheme: ThemeData.light().textTheme,
   ```

---

### Issue: Android build fails

**Common causes:**
- Gradle version mismatch
- SDK not found
- Build tools outdated

**Solutions:**

1. **Update Gradle:**
   Edit `android/gradle/wrapper/gradle-wrapper.properties`:
   ```properties
   distributionUrl=https\://services.gradle.org/distributions/gradle-7.5-all.zip
   ```

2. **Update build.gradle:**
   Edit `android/app/build.gradle`:
   ```gradle
   android {
       compileSdkVersion 34
       defaultConfig {
           minSdkVersion 21
           targetSdkVersion 34
       }
   }
   ```

3. **Clean Android build:**
   ```bash
   cd android
   ./gradlew clean
   cd ..
   flutter clean
   flutter run
   ```

---

### Issue: iOS build fails (macOS only)

**Common causes:**
- CocoaPods not installed
- Pods outdated
- Xcode issues

**Solutions:**

1. **Install/Update CocoaPods:**
   ```bash
   sudo gem install cocoapods
   ```

2. **Update pods:**
   ```bash
   cd ios
   pod deintegrate
   pod install
   cd ..
   flutter clean
   flutter run
   ```

3. **Clean Xcode build:**
   ```bash
   cd ios
   xcodebuild clean
   cd ..
   flutter clean
   flutter run
   ```

---

## Backend Issues

### Issue: Backend won't start

**Error:**
```
Address already in use
```

**Solution:**
```bash
# Find process using port 8000
lsof -i :8000  # macOS/Linux
netstat -ano | findstr :8000  # Windows

# Kill the process or use different port
python main.py --port 8001
```

---

### Issue: Python dependencies fail to install

**Solution:**
```bash
# Create fresh virtual environment
python -m venv venv
source venv/bin/activate  # macOS/Linux
venv\Scripts\activate     # Windows

# Upgrade pip
pip install --upgrade pip

# Install dependencies
pip install -r requirements.txt
```

---

## API Connection Issues

### Issue: Flutter app can't connect to backend

**Symptoms:**
- Network errors
- Timeout errors
- Connection refused

**Solutions:**

1. **Check backend is running:**
   ```bash
   curl http://localhost:8000/health
   ```

2. **For Android emulator:**
   Use `10.0.2.2` instead of `localhost`:
   ```dart
   static const String baseUrl = 'http://10.0.2.2:8000/api';
   ```

3. **For iOS simulator:**
   Use `localhost` or your machine's IP:
   ```dart
   static const String baseUrl = 'http://localhost:8000/api';
   ```

4. **For physical device:**
   Use your machine's IP address:
   ```dart
   static const String baseUrl = 'http://192.168.1.100:8000/api';
   ```

5. **Check firewall:**
   Ensure port 8000 is not blocked by firewall

---

## Development Tips

### Enable verbose logging

```bash
flutter run -v
```

### Check Flutter doctor

```bash
flutter doctor -v
```

### Analyze code

```bash
flutter analyze
```

### Format code

```bash
flutter format .
```

### Run tests

```bash
flutter test
```

---

## Getting Help

If you encounter issues not covered here:

1. **Check the error message carefully** - It usually points to the exact problem
2. **Search GitHub issues** - Someone may have had the same problem
3. **Run `flutter doctor -v`** - Check for environment issues
4. **Create an issue** - Include:
   - Flutter version (`flutter --version`)
   - Error message (full stack trace)
   - Steps to reproduce
   - Platform (Android/iOS/Web)

---

## Quick Fixes Checklist

When build fails, try these in order:

- [ ] `flutter clean`
- [ ] `flutter pub get`
- [ ] `flutter analyze` (check for errors)
- [ ] Restart IDE
- [ ] Restart device/emulator
- [ ] Check internet connection
- [ ] Update Flutter: `flutter upgrade`
- [ ] Check `flutter doctor -v`

---

## Useful Commands

```bash
# Clean everything
flutter clean
cd android && ./gradlew clean && cd ..
cd ios && xcodebuild clean && cd ..

# Reset pub cache
flutter pub cache repair

# Update all dependencies
flutter pub upgrade

# Check for outdated packages
flutter pub outdated

# Run with specific device
flutter run -d <device-id>

# Build release APK
flutter build apk --release

# Build release iOS
flutter build ios --release
```

---

**Remember:** Most build issues can be resolved with `flutter clean` followed by `flutter pub get`!