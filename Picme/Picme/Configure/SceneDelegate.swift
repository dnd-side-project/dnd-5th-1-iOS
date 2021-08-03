//
//  SceneDelegate.swift
//  dnd-5th-1-iOS
//
//  Created by taeuk on 2021/07/11.
//

import UIKit
import KakaoSDKAuth

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
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)

        let vc = OnboardingViewController()
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
        
        // MARK: Init TabBar
        
        // 윈도우 객체와 연결된 루트뷰컨트롤러 가져오기
        if let tbc = self.window?.rootViewController as? UITabBarController {
            
            // 현재 선택된 아이템 색 지정
            tbc.tabBar.tintColor = .white
            
            // 탭바 색
            tbc.tabBar.barTintColor = UIColor.solidColor(.solid16)
            
            // 탭바 아이템
            if let tbItems = tbc.tabBar.items {
                tbItems[0].title = "홈"
                
                // 원본 이미지 적용하기 (탭바의 이미지 디폴트는 색상은 무시되고 단순히 alpha값만 사용함)
                let image = UIImage(named: "tabBarHome")?.withRenderingMode(.alwaysOriginal)
                tbItems[0].image = image
                tbItems[0].selectedImage = #imageLiteral(resourceName: "tabBarHome")
                
                // 탭바 아이템 타이틀 설정 - proxy객체 사용 : for문으로 접근하지 않아도 가능
                // 탭바 아이템에 일일이 할 필요 없이, 일괄적 적용
                let tbItemProxy = UITabBarItem.appearance()
                tbItemProxy.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.textColor(.text100)], for: .selected)
                tbItemProxy.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.solidColor(.solid32)], for: .disabled)
                tbItemProxy.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)], for: .normal)
            }
        }
        
        guard let _ = (scene as? UIWindowScene) else { return }
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
