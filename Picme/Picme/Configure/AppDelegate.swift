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
        sleep(2)
        
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
    
    //MARK: - Tab Bar Should Select
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        guard let indexOfTab = tabBarController.viewControllers?.firstIndex(of: viewController) else {
            return true
        }
        
        switch indexOfTab {
        // 홈 탭
        case 0:
            if let mainNC = tabBarController.selectedViewController as? UINavigationController,
               let mainVC = mainNC.topViewController as? MainViewController {
                mainVC.mainTableView.scrollToTop()
            }
            
//            if let mainNC = tabBarController.viewControllers?.first as? UINavigationController,
//               let mainVC = mainNC.topViewController as? MainViewController {
//                mainVC.mainTableView.scrollToTop()
//            }
        // 투표 만들기 탭
        case 1:
            if APIConstants.jwtToken != "" { // 로그인 후 탭하면 present로 나타남
                if let uploadImageVC = tabBarController.storyboard?.instantiateViewController(withIdentifier: "UploadImage") {
                    uploadImageVC.modalPresentationStyle = .fullScreen
                    tabBarController.present(uploadImageVC, animated: true)
                    return false
                }
            } else { // 미로그인 시 AlertView
                AlertView.instance.showAlert(using: .logInVote)
                AlertView.instance.actionDelegate = self
            }
        // 마이 페이지 탭
        case 2:
            if APIConstants.jwtToken == "" { // 미로그인 시 AlertView
                AlertView.instance.showAlert(using: .logInMypage)
                AlertView.instance.actionDelegate = self
            }
        default:
            return true
        }
        
        return true
    }
}

// MARK: - Alert View Action Delegate

extension AppDelegate: AlertViewActionDelegate {
    
    func loginTapped() {
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
        loginVC.modalPresentationStyle = .fullScreen
        
        if let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as? SceneDelegate {
            sceneDelegate.window?.rootViewController = loginVC
            
            UIView.transition(with: sceneDelegate.window ?? UIWindow(),
                              duration: 0.3,
                              options: .transitionCrossDissolve,
                              animations: nil,
                              completion: nil)
        }
    }
    
    func moveToHomeTab() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainVC = storyboard.instantiateViewController(withIdentifier: "TabBarController")
        mainVC.modalPresentationStyle = .fullScreen
        
        if let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as? SceneDelegate {
            sceneDelegate.window?.rootViewController = mainVC
        }
    }
}
