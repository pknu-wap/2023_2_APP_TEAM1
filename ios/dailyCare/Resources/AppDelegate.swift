//
//  AppDelegate.swift
//  dailyCare
//
//

import UIKit
import KakaoSDKCommon
import KakaoSDKAuth
import FirebaseCore
import FirebaseAuth
import GoogleSignIn


@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        // 카카오 key값
        FirebaseApp.configure()
        if let nativeAppKey = Bundle.main.infoDictionary?["KAKAO_NATIVE_APP_KEY"] as? String {
            KakaoSDK.initSDK(appKey: nativeAppKey)
        } else {
            print("KAKAO_NATIVE_APP_KEY not found in infoDictionary.")
        }
        
        
        
        // Google 로그인 초기화 (수정 전)
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if (AuthApi.isKakaoTalkLoginUrl(url)) {
            return AuthController.handleOpenUrl(url: url)
        }
        // Google 로그인 URL 핸들링
        if (GIDSignIn.sharedInstance.handle(url)){
            return GIDSignIn.sharedInstance.handle(url)
        }
        return false
        
    }

    

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        
        // Firebase 연동
        FirebaseApp.configure()
        
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    
}


