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
        let signUpController = makeSignUpController(addAccount: addAccount)
        let authentication = makeRemoteAuthentication(httpClient: httpClient)
        let loginViewController = makeLoginController(authentication: authentication)
        let navigationController = NavigationController(rootViewController: loginViewController)

        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}
