@echo off
echo Generating production keystore for ecotte...

keytool -genkey -v -keystore ecotte.keystore -alias ecotte_key -keyalg RSA -keysize 2048 -validity 10000 -storetype PKCS12 -storepass ecotte_2024 -keypass ecotte_2024 -dname "CN=ecotte, OU=Development, O=YourCompany, L=YourCity, S=YourState, C=US"

echo.
echo Keystore generated successfully!
echo File: ecotte.keystore
echo Alias: ecotte_key
echo Store Password: ecotte_2024
echo Key Password: ecotte_2024
echo.
echo Please update android/app/build.gradle with these credentials:
echo storeFile file("ecotte.keystore")
echo storePassword "ecotte_2024"
echo keyAlias "ecotte_key"
echo keyPassword "ecotte_2024"
echo.
pause 