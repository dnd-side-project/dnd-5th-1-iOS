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
        
        let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "OnboardingViewController")
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
        // MARK: Init TabBar
        
        /*
        // 윈도우 객체와 연결된 루트뷰컨트롤러 가져오기
        if let tbc = self.window?.rootViewController as? UITabBarController {
            
            // 현재 선택된 아이템 색깔 지정
            tbc.tabBar.tintColor = .green
            
            // 탭바의 색깔
            tbc.tabBar.barTintColor = .blue
            
            // 탭바에 이미지 삽입 방법 (backgoundImage는 색상이 잘 표현 안되는 경우가 생겨서 tint로 사용할 것)
            tbc.tabBar.barTintColor = UIColor(patternImage: UIImage(named: "menubar-bg-mini")!)
            
            
            // bacgroundImage의 장접은 신축성 옵션이 가능
            tbc.tabBar.backgroundImage = UIImage(named: "menubar-bg-mini") // 이미지 크기가 작다면 바둑판형태
            tbc.tabBar.backgroundImage = UIImage(named: "menubar-bg-mini")?.stretchableImage(withLeftCapWidth: 5, topCapHeight: 16) // 좌표를 기준으로 늘이기
            tbc.tabBar.backgroundImage = UIImage(named: "menubar-bg-mini")?.stretchableImage(withLeftCapWidth: 0, topCapHeight: 0) // 균일하게 늘이기
            
            // 큰 이미지 자르기: 이미지가 tabBar보다 큰 경우 밖으로 튀어나옴
            tbc.tabBar.clipsToBounds = true
            
            // 탭바 아이템
            if let tbItems = tbc.tabBar.items {
                tbItems[0].image = UIImage(named: "calendar")
                tbItems[1].image = UIImage(named: "file-tree")
                tbItems[2].image = UIImage(named: "photo")
                
                tbItems[0].title = "calendar"
                tbItems[1].title = "file"
                tbItems[2].title = "photo"
                
                // 원본 이미지 적용하기 (탭바의 이미지 디폴트는 색상은 무시되고 단순히 alpha값만 사용함)
                let image = UIImage(named: "canlendar")?.withRenderingMode(.alwaysOriginal)
                tbItems[0].image = image
                
                // 탭바 아이템의 타이틀 설정
                for tbItem in tbItems {
                    tbItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.gray], for: .disabled)
                    tbItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.red], for: .selected)
                }
                
                // proxy객체 사용 : for문으로 접근하지 않아도 가능
                // 탭바 아이템에 일일이 할 필요 없이, 일괄적 적용
                let tbItemProxy = UITabBarItem.appearance()
                tbItemProxy.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.red], for: .selected)
                tbItemProxy.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.gray], for: .disabled)
                tbItemProxy.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)], for: .normal)
            }
        }
        */
        
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
