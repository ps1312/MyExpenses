//
//  SceneDelegate.swift
//  MyFinancesApp
//
//  Created by Paulo Sergio da Silva Rodrigues on 15/04/21.
//

import UIKit
import MyFinancesiOS
import MyFinances

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).

        guard let _ = (scene as? UIWindowScene) else { return }

        let url = URL(string: "https://my-finances-715d4-default-rtdb.firebaseio.com/expenses.json")!
        let loader = RemoteExpensesLoader(url: url, client: URLSessionHTTPClient())
        let controller = UINavigationController(rootViewController: ExpensesUIComposer.compose(loader: loader))

        window?.rootViewController = controller
    }


}
