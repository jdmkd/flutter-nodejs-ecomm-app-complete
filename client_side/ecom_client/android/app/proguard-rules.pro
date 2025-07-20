# --- Flutter Core & Plugin Entrypoints ---
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# --- Google Play Services ---
-keep class com.google.android.gms.** { *; }
-keep class com.google.android.apps.nbu.paisa.** { *; }
-keep class com.google.android.play.core.** { *; }

# --- Google Play Core Split Install (required for Flutter) ---
-keep class com.google.android.play.core.splitcompat.** { *; }
-keep class com.google.android.play.core.splitinstall.** { *; }
-keep class com.google.android.play.core.tasks.** { *; }

# --- Google Crypto Tink ---
-keep class com.google.crypto.tink.** { *; }

# --- Stripe SDK ---
-keep class com.stripe.android.** { *; }
-keepclassmembers class com.stripe.android.** { *; }

# --- Razorpay SDK ---
-keep class com.razorpay.** { *; }
-keepclassmembers class com.razorpay.** { *; }
-keep interface com.razorpay.** { *; }

# --- OneSignal SDK ---
-keep class com.onesignal.** { *; }
-keepclassmembers class com.onesignal.** { *; }

# --- PDF/Printing ---
-keep class org.apache.pdfbox.** { *; }
-keep class com.itextpdf.** { *; }
-keep class com.tom_roush.pdfbox.** { *; }

# --- BouncyCastle (handle conflicts) ---
-keep class org.bouncycastle.** { *; }
-keepclassmembers class org.bouncycastle.** { *; }
-dontwarn org.bouncycastle.**

# --- Flutter Plugins ---
-keep class io.flutter.plugins.get.** { *; }
-keep class io.flutter.plugins.getstorage.** { *; }
-keep class io.flutter.plugins.provider.** { *; }
-keep class io.flutter.plugins.fluttercart.** { *; }
-keep class io.flutter.plugins.deviceframeplus.** { *; }

# --- Custom App Classes ---
-keep class com.example.ecotte.** { *; }

# --- General Android/Flutter Reflection Support ---
-keepattributes *Annotation*
-keepattributes Signature,InnerClasses,EnclosingMethod,SourceFile,LineNumberTable

# --- JSON Serialization ---
-keep class com.google.gson.** { *; }
-keepclassmembers class * {
    @com.google.gson.annotations.SerializedName <fields>;
}

# --- Android Components ---
-keep class * extends android.app.Application { *; }
-keep class * extends android.app.Activity { *; }
-keep class * extends android.app.Service { *; }
-keep class * extends android.content.BroadcastReceiver { *; }
-keep class * extends android.content.ContentProvider { *; }

# --- Native Methods ---
-keepclasseswithmembernames class * {
    native <methods>;
}

# --- Enums ---
-keepclassmembers enum * { *; }

# --- Public Methods and Fields ---
-keepclassmembers class * {
    public <methods>;
    public <fields>;
}

# --- Exception Classes ---
-keep public class * extends java.lang.Exception

# --- Enum Classes ---
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

# --- Parcelable Classes ---
-keep class * implements android.os.Parcelable {
    public static final android.os.Parcelable$Creator *;
}

# --- Serializable Classes ---
-keepclassmembers class * implements java.io.Serializable {
    static final long serialVersionUID;
    private static final java.io.ObjectStreamField[] serialPersistentFields;
    private void writeObject(java.io.ObjectOutputStream);
    private void readObject(java.io.ObjectInputStream);
    java.lang.Object writeReplace();
    java.lang.Object readResolve();
}

# --- R Classes ---
-keep class **.R$* {
    public static <fields>;
}

# --- WebView ---
-keepclassmembers class * {
    @android.webkit.JavascriptInterface <methods>;
}

# --- NimbusDS JOSE ---
-keep class com.nimbusds.** { *; }
-keepclassmembers class com.nimbusds.** { *; }

# --- React Native Stripe SDK ---
-keep class com.reactnativestripesdk.** { *; }
-keepclassmembers class com.reactnativestripesdk.** { *; }

# --- ProGuard Annotations ---
-keep @proguard.annotation.Keep class * { *; }
-keepclassmembers class * {
    @proguard.annotation.Keep *;
}
-keepclassmembers class * {
    @proguard.annotation.KeepClassMembers *;
}

# --- Missing Classes Handling ---
-dontwarn com.google.android.apps.nbu.paisa.**
-dontwarn com.google.android.play.core.splitcompat.**
-dontwarn com.google.android.play.core.splitinstall.**
-dontwarn com.google.android.play.core.tasks.**
-dontwarn com.stripe.android.pushProvisioning.**
-dontwarn proguard.annotation.**
