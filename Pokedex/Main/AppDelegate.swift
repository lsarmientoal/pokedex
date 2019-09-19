//
//  AppDelegate.swift
//  Pokedex
//
//  Created by Laura Sarmiento on 17/09/19.
//  Copyright © 2019 Medrar. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var navigationController: UINavigationController?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        
        let wireframe = PokeListWireframe()
        let navigationController = UINavigationController(rootViewController: wireframe.viewController)
        navigationController.navigationBar.prefersLargeTitles = true
        window.rootViewController = navigationController
        
        self.navigationController = navigationController
        self.window = window
        
        window.makeKeyAndVisible()
        return true
    }
}

