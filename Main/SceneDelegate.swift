//
//  SceneDelegate.swift
//  Main
//
//  Created by Cora on 12/03/24.
//

import UIKit
import UI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        let httpClient = makeAlamofireAdapter()
        let addAccount = makeRemoteAddAccount(httpClient: httpClient)
        let signUpController = makeSignUpComtroller(addAccount: addAccount)
        let navigationController = NavigationController(rootViewController: signUpController)

        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}
