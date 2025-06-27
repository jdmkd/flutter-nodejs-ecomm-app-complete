# --- Flutter Core & Plugin Entrypoints ---
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# --- Stripe SDK ---
-keep class com.stripe.android.** { *; }
-keepclassmembers class com.stripe.android.** { *; }

# --- Razorpay SDK ---
-keep class com.razorpay.** { *; }
-keepclassmembers class com.razorpay.** { *; }

# --- OneSignal SDK ---
-keep class com.onesignal.** { *; }
-keepclassmembers class com.onesignal.** { *; }

# --- PDF/Printing (pdf, printing) ---
-keep class org.apache.pdfbox.** { *; }
-keep class org.bouncycastle.** { *; }
-keep class org.bouncycastle.jcajce.provider.** { *; }
-keep class org.bouncycastle.jce.provider.** { *; }
-keep class com.itextpdf.** { *; }
-keep class com.tom_roush.pdfbox.** { *; }

# --- GetX, Provider, GetStorage, flutter_cart ---
-keep class io.flutter.plugins.get.** { *; }
-keep class io.flutter.plugins.getstorage.** { *; }
-keep class io.flutter.plugins.provider.** { *; }
-keep class io.flutter.plugins.fluttercart.** { *; }

# --- device_frame_plus (if any native code) ---
-keep class io.flutter.plugins.deviceframeplus.** { *; }

# --- Custom Model Classes (for serialization/deserialization) ---
-keep class com.example.ecom_client.** { *; }

# --- Annotations (for Razorpay, Stripe, etc.) ---
-keep class proguard.annotation.Keep { *; }
-keep class proguard.annotation.KeepClassMembers { *; }

# --- General Android/Flutter Reflection Support ---
-keepattributes *Annotation*
-keepattributes Signature,InnerClasses,EnclosingMethod,SourceFile,LineNumberTable

# --- Keep Gson/JSON Serialization (if used) ---
-keep class com.google.gson.** { *; }
-keepclassmembers class * {
    @com.google.gson.annotations.SerializedName <fields>;
}

# --- Keep Application, Activities, Services, BroadcastReceivers, ContentProviders ---
-keep class * extends android.app.Application { *; }
-keep class * extends android.app.Activity { *; }
-keep class * extends android.app.Service { *; }
-keep class * extends android.content.BroadcastReceiver { *; }
-keep class * extends android.content.ContentProvider { *; }

# --- Keep all native methods (JNI) ---
-keepclasseswithmembernames class * {
    native <methods>;
}

# --- Keep enums (for reflection) ---
-keepclassmembers enum * { *; }

# --- Keep all public methods and fields for classes used via reflection (safe for most Flutter plugins) ---
-keepclassmembers class * {
    public <methods>;
    public <fields>;
}

# --- End of rules ---
