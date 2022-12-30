//
//  AppDelegate.swift
//  CoppelMovies
//
//  Created by Aldair Carrillo on 28/12/22.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        if #available(iOS 15, *) {
            UINavigationBar.appearance().tintColor = .white
        }
        
        window = UIWindow(frame: UIScreen.main.bounds) // 2
        let splashView = SplashRouter.createSplashModule()
        window?.rootViewController = splashView
        window?.makeKeyAndVisible() //
        
        return true
    }

}

