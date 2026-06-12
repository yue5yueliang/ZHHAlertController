//
//  SceneDelegate.swift
//  ZHHAlertController
//
//  Created by 桃色三岁 on 06/09/2026.
//  Copyright © 2026 桃色三岁. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }

        let window = UIWindow(windowScene: windowScene)
        let rootVC = ZHHHomeViewController()
        let navigation = UINavigationController(rootViewController: rootVC)
        UINavigationBar.appearance().tintColor = .white
        window.rootViewController = navigation
        window.makeKeyAndVisible()
        self.window = window
    }
}
