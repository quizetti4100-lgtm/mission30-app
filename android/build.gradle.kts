// Top-level build file where you can add configuration options common to all sub-projects/modules.
buildscript {
    extra.apply {
        set("kotlin_version", "1.9.22")
        set("agp_version", "8.2.1")
    }
    
    repositories {
        google()
        mavenCentral()
    }
 
allprojects {
    repositories {
        google()
        mavenCentral()
    }
}
 
// Build directory configuration
rootProject.layout.buildDirectory.set(file("../build"))
 
subprojects {
    project.layout.buildDirectory.set(file("${rootProject.layout.buildDirectory.get()}/${project.name}"))
    
    afterEvaluate {
        if (project.plugins.hasPlugin("com.android.application") || 
            project.plugins.hasPlugin("com.android.library")) {
            
            project.extensions.configure<com.android.build.gradle.BaseExtension> {
                compileSdkVersion(34)
                
                defaultConfig {
                    applicationId = "com.example.coaching_app"
                    minSdk = 24
                    targetSdk = 34
                    versionCode = 1
                    versionName = "1.0.0"
                    multiDexEnabled = true
                }
                
                compileOptions {
                    sourceCompatibility = JavaVersion.VERSION_17
                    targetCompatibility = JavaVersion.VERSION_17
                }
            }
        }
    }
}
 
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
