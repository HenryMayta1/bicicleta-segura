plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")

    // ✅ AÑADIDO: Plugin de Firebase
    id("com.google.gms.google-services")
}

android {
    namespace = "com.example.bicicleta_segura"
    compileSdk = flutter.compileSdkVersion

    // ✅ AÑADIDO: forzar versión compatible de NDK
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.bicicleta_segura"

        // ✅ CAMBIADO: minSdk ahora es 23 como requiere firebase_auth
        minSdk = 23
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // ✅ AÑADIDO: BoM de Firebase
    implementation(platform("com.google.firebase:firebase-bom:33.14.0"))

    // ✅ AÑADIDO: SDKs de Firebase necesarios
    implementation("com.google.firebase:firebase-auth")
    implementation("com.google.firebase:firebase-firestore")

    // (Opcionales)
    // implementation("com.google.firebase:firebase-database")
    // implementation("com.google.firebase:firebase-analytics")
}
