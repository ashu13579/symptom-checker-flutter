# Setup Guide

Complete guide to set up and run the Symptom Checker Flutter app.

## Prerequisites

### Required Software

1. **Flutter SDK** (>=3.0.0)
   ```bash
   # Check installation
   flutter --version
   
   # If not installed, visit:
   # https://docs.flutter.dev/get-started/install
   ```

2. **Dart SDK** (>=3.0.0)
   - Comes with Flutter SDK

3. **Python** (3.9+) for backend
   ```bash
   python --version
   # or
   python3 --version
   ```

4. **IDE** (Choose one)
   - Android Studio (recommended for Android development)
   - VS Code with Flutter extension
   - IntelliJ IDEA

5. **Platform-Specific Tools**
   
   **For Android:**
   - Android Studio
   - Android SDK
   - Android Emulator or physical device
   
   **For iOS (macOS only):**
   - Xcode
   - CocoaPods
   - iOS Simulator or physical device

## Installation Steps

### 1. Clone the Repository

```bash
git clone https://github.com/ashu13579/symptom-checker-flutter.git
cd symptom-checker-flutter
```

### 2. Flutter Setup

#### Install Dependencies

```bash
flutter pub get
```

#### Verify Installation

```bash
flutter doctor
```

Fix any issues reported by `flutter doctor`.

#### Run Code Generation (if needed)

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 3. Backend Setup

#### Navigate to Backend Directory

```bash
cd backend
```

#### Create Virtual Environment (Recommended)

```bash
# Create virtual environment
python -m venv venv

# Activate virtual environment
# On macOS/Linux:
source venv/bin/activate
# On Windows:
venv\Scripts\activate
```

#### Install Python Dependencies

```bash
pip install -r requirements.txt
```

#### Configure Environment Variables

Create a `.env` file in the `backend` directory:

```bash
# backend/.env
OPENAI_API_KEY=your_openai_api_key_here
GEMINI_API_KEY=your_gemini_api_key_here
ENVIRONMENT=development
```

**Note**: API keys are optional for development. The app works with local analysis logic.

### 4. Configuration

#### Update API Endpoint (if needed)

If running backend on a different host/port, update:

`lib/data/datasources/remote_data_source.dart`:
```dart
static const String baseUrl = 'http://localhost:8000/api';
// Change to your backend URL
```

#### Android Configuration

No additional configuration needed for basic setup.

#### iOS Configuration (macOS only)

```bash
cd ios
pod install
cd ..
```

## Running the Application

### Option 1: Flutter App Only (Recommended for Testing)

The app works without the backend using local analysis logic.

```bash
# Run on connected device/emulator
flutter run

# Run on specific device
flutter devices  # List available devices
flutter run -d <device_id>

# Run in release mode
flutter run --release
```

### Option 2: Full Stack (Flutter + Backend)

#### Terminal 1: Start Backend

```bash
cd backend
source venv/bin/activate  # Activate virtual environment
python main.py
```

Backend will run on `http://localhost:8000`

#### Terminal 2: Run Flutter App

```bash
flutter run
```

### Option 3: Web Version

```bash
flutter run -d chrome
```

## Development Workflow

### Hot Reload

While the app is running:
- Press `r` to hot reload
- Press `R` to hot restart
- Press `q` to quit

### Debugging

#### VS Code
1. Open project in VS Code
2. Set breakpoints
3. Press F5 or Run > Start Debugging

#### Android Studio
1. Open project
2. Set breakpoints
3. Click Debug button

### Running Tests

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/symptom_bloc_test.dart

# Run with coverage
flutter test --coverage
```

## Building for Production

### Android APK

```bash
# Build APK
flutter build apk --release

# Build App Bundle (for Play Store)
flutter build appbundle --release
```

Output: `build/app/outputs/flutter-apk/app-release.apk`

### iOS IPA (macOS only)

```bash
# Build for iOS
flutter build ios --release

# Archive in Xcode for App Store
open ios/Runner.xcworkspace
# Then: Product > Archive
```

### Web

```bash
flutter build web --release
```

Output: `build/web/`

## Backend Deployment

### Docker Deployment

Create `backend/Dockerfile`:

```dockerfile
FROM python:3.9-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 8000

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
```

Build and run:

```bash
cd backend
docker build -t symptom-checker-backend .
docker run -p 8000:8000 -e OPENAI_API_KEY=your_key symptom-checker-backend
```

### Cloud Deployment

#### Heroku

```bash
# Install Heroku CLI
# Create Procfile in backend/
echo "web: uvicorn main:app --host 0.0.0.0 --port \$PORT" > Procfile

# Deploy
heroku create symptom-checker-api
git subtree push --prefix backend heroku main
```

#### AWS/GCP/Azure

Follow platform-specific guides for deploying FastAPI applications.

## Troubleshooting

### Common Issues

#### 1. Flutter Doctor Issues

```bash
flutter doctor -v
# Follow instructions to fix each issue
```

#### 2. Dependency Conflicts

```bash
flutter clean
flutter pub get
```

#### 3. iOS Build Fails

```bash
cd ios
pod deintegrate
pod install
cd ..
flutter clean
flutter run
```

#### 4. Android Build Fails

```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter run
```

#### 5. Backend Won't Start

```bash
# Check if port 8000 is in use
lsof -i :8000  # macOS/Linux
netstat -ano | findstr :8000  # Windows

# Kill process or use different port
python main.py --port 8001
```

#### 6. API Connection Issues

- Check backend is running: `curl http://localhost:8000/health`
- Verify API URL in `remote_data_source.dart`
- Check firewall settings
- For Android emulator, use `10.0.2.2` instead of `localhost`

### Getting Help

1. Check existing issues: https://github.com/ashu13579/symptom-checker-flutter/issues
2. Create new issue with:
   - Flutter doctor output
   - Error messages
   - Steps to reproduce
   - Platform (Android/iOS/Web)

## Development Tips

### Code Organization

```
lib/
├── core/           # App-wide utilities
├── data/           # Data layer (models, repositories)
├── domain/         # Business logic
└── presentation/   # UI layer (pages, widgets, BLoC)
```

### State Management

Using BLoC pattern:
- Events: User actions
- States: UI states
- BLoC: Business logic

### Adding New Features

1. Create models in `data/models/`
2. Add business logic in `domain/usecases/`
3. Update BLoC in `presentation/bloc/`
4. Create UI in `presentation/pages/` or `presentation/widgets/`

### Code Style

```bash
# Format code
flutter format .

# Analyze code
flutter analyze

# Fix common issues
dart fix --apply
```

## Environment-Specific Configuration

### Development

```dart
// lib/core/config/app_config.dart
class AppConfig {
  static const String apiUrl = 'http://localhost:8000/api';
  static const bool enableLogging = true;
  static const bool useMockData = false;
}
```

### Production

```dart
class AppConfig {
  static const String apiUrl = 'https://api.symptomchecker.com/api';
  static const bool enableLogging = false;
  static const bool useMockData = false;
}
```

## Performance Optimization

### Flutter

```bash
# Build with optimization
flutter build apk --release --split-per-abi

# Analyze app size
flutter build apk --analyze-size
```

### Backend

- Use caching for common symptom patterns
- Implement rate limiting
- Use connection pooling
- Enable gzip compression

## Security Checklist

- [ ] API keys in environment variables, not code
- [ ] HTTPS in production
- [ ] Input validation on all endpoints
- [ ] Rate limiting enabled
- [ ] CORS properly configured
- [ ] No sensitive data in logs
- [ ] Medical disclaimers prominent

## Next Steps

1. Review [ARCHITECTURE.md](ARCHITECTURE.md) for system design
2. Read [MEDICAL_SAFETY.md](MEDICAL_SAFETY.md) for safety guidelines
3. Check [AI_INTEGRATION.md](AI_INTEGRATION.md) for AI setup
4. Start developing!

## Support

For questions or issues:
- GitHub Issues: https://github.com/ashu13579/symptom-checker-flutter/issues
- Documentation: https://github.com/ashu13579/symptom-checker-flutter/wiki

---

**Remember**: This is an educational health tool. Always prioritize medical safety in development.