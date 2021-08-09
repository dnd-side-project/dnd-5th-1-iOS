//
//  AppDelegate.swift
//  dnd-5th-1-iOS
//
//  Created by taeuk on 2021/07/11.
//

import UIKit
import KakaoSDKCommon
import AuthenticationServices

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UITabBarControllerDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        KakaoSDKCommon.initSDK(appKey: "d1705396377c942afa5628eba176683f")
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    //MARK: - 투표만들기 Tab Bar Prenset
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
//        if viewController is OnboardingViewController {
//            if let newVC = tabBarController.storyboard?.instantiateViewController(withIdentifier: "OnBoarding") {
//                tabBarController.present(newVC, animated: true)
//                return false
//            }
//        }
        
        if #available(iOS 14, *) {
            if viewController is ImageUploadViewContoller {
                if let newVC = tabBarController.storyboard?.instantiateViewController(withIdentifier: "ImageUpload") {
                    tabBarController.present(newVC, animated: true)
                    return false
                }
            }
        } else {
            // Fallback on earlier versions
        }
        
        return true
    }
}
