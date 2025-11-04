//
//  SceneDelegate.swift
//  OnboardingApp
//
//  Created by Ivan Petrov on 03.11.2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window: UIWindow = UIWindow(windowScene: windowScene)
        let rootVC: RootViewController = RootViewController()
        
        window.rootViewController = rootVC
        window.makeKeyAndVisible()
        
        self.window = window
    }
}
