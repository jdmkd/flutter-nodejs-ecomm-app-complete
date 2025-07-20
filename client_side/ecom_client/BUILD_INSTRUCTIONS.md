# Flutter E-commerce App - Production Build Instructions

## Prerequisites

1. **Java 21 JDK** - Ensure you have Java 21 installed and configured
2. **Flutter SDK** - Latest stable version
3. **Android Studio** - For Android builds
4. **Gradle** - Latest version (automatically managed by Flutter)

## Setup Instructions

### 1. Generate Production Keystore

Before building for production, you need to generate a keystore:

```bash
# Navigate to android/app directory
cd android/app

# Run the keystore generation script
./generate-keystore.bat
```

This will create `ecotte.keystore` with the following credentials:
- **Store Password**: `ecotte_2024`
- **Key Alias**: `ecotte_key`
- **Key Password**: `ecotte_2024`

### 2. Verify Java Configuration

Ensure your `JAVA_HOME` environment variable points to Java 21:

```bash
# Windows
echo %JAVA_HOME%
# Should show: C:\Java\jdk-21

# Linux/Mac
echo $JAVA_HOME
# Should show: /path/to/jdk-21
```

### 3. Clean and Get Dependencies

```bash
# Clean previous builds
flutter clean

# Get dependencies
flutter pub get
```

## Building for Production

### Release APK Build

```bash
# Build release APK
flutter build apk --release

# Build split APKs for different architectures (recommended for Play Store)
flutter build apk --split-per-abi --release
```

### Release App Bundle (Recommended for Play Store)

```bash
# Build app bundle
flutter build appbundle --release
```

## Build Configurations

### Production Features Enabled

1. **Code Obfuscation**: R8 is enabled for code shrinking and obfuscation
2. **Resource Shrinking**: Unused resources are removed
3. **Java 21**: Modern Java features and optimizations
4. **Security**: Proper signing with production keystore
5. **Performance**: Optimized for production with all optimizations enabled

### Dependencies Added

The following dependencies have been added to resolve missing classes:

- **Google Play Services**: Base, Wallet, Auth
- **Google Play Core**: Split install, app updates, reviews
- **Google Crypto Tink**: Encryption and JWT handling
- **Stripe SDK**: Complete payment processing
- **BouncyCastle**: Additional cryptography support
- **Gson**: JSON serialization

## Troubleshooting

### Common Issues

1. **Java Version Warnings**
   - Ensure Java 21 is installed and configured
   - Check `JAVA_HOME` environment variable
   - Verify gradle.properties has correct Java path

2. **Missing Classes Error**
   - All required dependencies are now included
   - ProGuard rules have been optimized
   - No suppression rules - all classes are properly included

3. **Build Performance**
   - Gradle daemon is enabled
   - Parallel builds are configured
   - Build cache is enabled
   - Memory allocation is optimized

### Build Optimization

The build is configured for maximum performance:

- **Memory**: 8GB allocated to Gradle
- **Parallel Processing**: 8 workers maximum
- **Caching**: All caches enabled
- **Incremental Builds**: Kotlin incremental compilation enabled

## Security Considerations

1. **Keystore Security**: Keep your keystore file secure and backed up
2. **API Keys**: Ensure all API keys are properly configured in `.env` file
3. **Code Obfuscation**: R8 is enabled to protect your code
4. **Network Security**: HTTPS is enforced for all network calls

## Deployment

### Google Play Store

1. Build app bundle: `flutter build appbundle --release`
2. Upload to Google Play Console
3. Test on internal testing track first
4. Release to production

### Direct APK Distribution

1. Build APK: `flutter build apk --release`
2. Test thoroughly on target devices
3. Distribute APK file

## Monitoring and Analytics

The app includes:
- **OneSignal**: Push notifications and analytics
- **Crash Reporting**: Automatic crash detection
- **Performance Monitoring**: Built-in performance tracking

## Future-Proofing

This configuration is designed to be:
- **Upgradeable**: Easy to update dependencies
- **Maintainable**: Clear separation of concerns
- **Scalable**: Ready for app growth
- **Secure**: Production-ready security measures

## Support

For issues or questions:
1. Check the troubleshooting section above
2. Review Flutter and Android documentation
3. Ensure all prerequisites are met
4. Verify Java 21 is properly configured 