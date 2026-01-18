# Quick Start Guide

Get the Symptom Checker app running in 5 minutes!

## Prerequisites

- Flutter SDK installed ([Get Flutter](https://docs.flutter.dev/get-started/install))
- Git installed
- A device/emulator ready

## 🚀 Quick Setup (3 Steps)

### 1. Clone & Install

```bash
# Clone the repository
git clone https://github.com/ashu13579/symptom-checker-flutter.git
cd symptom-checker-flutter

# Install dependencies
flutter pub get
```

### 2. Verify Setup

```bash
# Check Flutter installation
flutter doctor

# List available devices
flutter devices
```

### 3. Run the App

```bash
# Run on connected device/emulator
flutter run
```

That's it! The app will launch with local analysis (no backend needed for testing).

## 🎯 What You'll See

1. **Home Page**: Medical disclaimer and app introduction
2. **Body Map**: Interactive body region selection
3. **Symptom Input**: Structured questionnaire
4. **Results**: Analysis with urgency level and guidance

## 🧪 Try These Test Cases

### Test 1: Low Urgency
- Select: Head (Front)
- Pain Type: Dull
- Intensity: 3/10
- Duration: 2 hours
- Expected: Low urgency, monitor symptoms

### Test 2: Medium Urgency
- Select: Abdomen Upper Right
- Pain Type: Sharp
- Intensity: 6/10
- Associated: Nausea
- Expected: Medium urgency, see doctor soon

### Test 3: Emergency (Red Flag)
- Select: Chest
- Pain Type: Pressure
- Intensity: 8/10
- Associated: Shortness of breath, Sweating
- Expected: Emergency urgency, immediate care

## 📱 Platform-Specific Quick Start

### Android
```bash
# Start Android emulator
flutter emulators --launch <emulator_id>

# Or connect physical device via USB (enable USB debugging)

# Run app
flutter run
```

### iOS (macOS only)
```bash
# Open iOS Simulator
open -a Simulator

# Run app
flutter run
```

### Web
```bash
flutter run -d chrome
```

## 🔧 Common Quick Fixes

### Issue: "No devices found"
```bash
# For Android
flutter emulators
flutter emulators --launch <emulator_id>

# For iOS
open -a Simulator
```

### Issue: "Pub get failed"
```bash
flutter clean
flutter pub get
```

### Issue: "Build failed"
```bash
flutter clean
flutter pub get
flutter run
```

## 📚 Next Steps

Once the app is running:

1. **Explore the UI**: Try different body regions and symptoms
2. **Read Documentation**: 
   - [ARCHITECTURE.md](ARCHITECTURE.md) - System design
   - [MEDICAL_SAFETY.md](MEDICAL_SAFETY.md) - Safety guidelines
   - [SETUP.md](SETUP.md) - Detailed setup
3. **Set Up Backend** (Optional):
   ```bash
   cd backend
   pip install -r requirements.txt
   python main.py
   ```
4. **Start Developing**: Check [CONTRIBUTING.md](CONTRIBUTING.md)

## 🆘 Need Help?

- **Setup Issues**: See [SETUP.md](SETUP.md)
- **Flutter Problems**: Run `flutter doctor -v`
- **Questions**: Open an issue on GitHub

## ⚠️ Important Reminder

This is an **educational tool**, not a medical device. Always include proper disclaimers and never make diagnostic claims.

---

**Ready to build? Let's go! 🚀**

For detailed setup and configuration, see [SETUP.md](SETUP.md)