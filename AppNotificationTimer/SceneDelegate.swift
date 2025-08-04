//
//  SceneDelegate.swift
//  AppNotificationTimer
//
//  Created by Test on 05/07/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var navigationcontroller : UINavigationController?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
     
        guard let seen = (scene as? UIWindowScene) else { return }
        navigationcontroller = UINavigationController()
        navigationcontroller?.viewControllers.append( MainViewController())
        self.window = UIWindow(windowScene: seen)
        self.window?.rootViewController = navigationcontroller
        self.window?.makeKeyAndVisible()
        
        
        
        
    }

    func sceneDidDisconnect(_ scene: UIScene) {
      print("")
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        NotificationCenter.default.post(name: .notificationBackCheck, object: nil)
    }

    func sceneWillResignActive(_ scene: UIScene) {
       
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
       
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
       
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
    
    


}

