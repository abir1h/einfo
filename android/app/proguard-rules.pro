# flutter_inappwebview rules
-keep class com.pichillilorenzo.flutter_inappwebview.** { *; }
-dontwarn com.pichillilorenzo.flutter_inappwebview.**

# firebase_messaging rules
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**

# Flutter engine
-keep class io.flutter.embedding.** { *; }

# Needed for annotations and reflection
-keepattributes *Annotation*
