//
//  SceneDelegate.swift
//  dnd-5th-1-iOS
//
//  Created by taeuk on 2021/07/11.
//

import UIKit
import KakaoSDKAuth
import AuthenticationServices

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            if (AuthApi.isKakaoTalkLoginUrl(url)) {
                _ = AuthController.handleOpenUrl(url: url)
            }
        }
    }
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let mainViewController = mainStoryboard.instantiateViewController(withIdentifier:
                                                                            "TabBarController")
        mainViewController.modalPresentationStyle = .fullScreen
        self.window?.rootViewController = mainViewController
        self.window?.makeKeyAndVisible()
        
//        let appleIDProvider = ASAuthorizationAppleIDProvider()
//        guard let readKeyChain = KeyChainModel.shared.readUserInfo(),
//              let userIdentifier = readKeyChain.userIdentifier else { return }
//
//        appleIDProvider.getCredentialState(forUserID: userIdentifier) { (credentialState, error) in
//            switch credentialState {
//            case .authorized:
//
//                print("Apple Login연동 OK, U go homeTab")
//                DispatchQueue.main.async {
//                    let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
//                    let mainViewController = mainStoryboard.instantiateViewController(withIdentifier:
//                                                                                        "TabBarController")
//                    mainViewController.modalPresentationStyle = .fullScreen
//                    self.window?.rootViewController = mainViewController
//                    self.window?.makeKeyAndVisible()
//                }
//
//            case .revoked, .notFound:
//                print("Apple Login연동 No")
//                DispatchQueue.main.async {
//                    let loginStoryboard = UIStoryboard(name: "Login", bundle: nil)
//                    let loginViewController = loginStoryboard.instantiateViewController(withIdentifier:
//                                                                                        "LoginViewController")
//                    loginViewController.modalPresentationStyle = .fullScreen
//                    self.window?.rootViewController = loginViewController
//                    self.window?.makeKeyAndVisible()
//                }
//
//            default:
//                break
//            }
//        }
        
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead)
    
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
}
