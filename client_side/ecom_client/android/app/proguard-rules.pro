# Flutter Stripe SDK
-keep class com.stripe.android.** { *; }
-keepclassmembers class com.stripe.android.** { *; }
-dontwarn com.stripe.android.**

# Razorpay SDK
-keep class com.razorpay.** { *; }
-keepclassmembers class com.razorpay.** { *; }
-dontwarn com.razorpay.**

# Required by Razorpay to work with annotations
-keep class proguard.annotation.Keep { *; }
-keep class proguard.annotation.KeepClassMembers { *; }
-dontwarn proguard.annotation.**

# OneSignal
-keep class com.onesignal.** { *; }
-dontwarn com.onesignal.**
