plugins {
    id("com.android.application")
    id("kotlin-android") // स्क्रीनशॉट के अनुसार सही किया गया
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services") // Firebase प्लगइन
}

android {
    namespace = "com.example.coaching_app"
    compileSdk = flutter.compileSdkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = "17"
    }

    defaultConfig {
        applicationId = "com.example.coaching_app"
        minSdk = 21 
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        getByName("release") {
            // हमने यहाँ डिबग की (key) सेट की है ताकि बिल्ड न रुके
            signingConfig = signingConfigs.getByName("debug")
            isMinifyEnabled = false
            isShrinkResources = false
        }
    }
}

flutter {
    source = "../.."
}

// --- यहाँ 'implementation' सही काम करेगा ---
dependencies {
    implementation(platform("com.google.firebase:firebase-bom:32.8.0"))
    implementation("com.google.firebase:firebase-analytics")
    implementation("androidx.multidex:multidex:2.0.1")
}
