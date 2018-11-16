//
//  AppDelegate.swift
//  Todoo
//
//  Created by Asgedom Teklu on 10/30/18.
//  Copyright © 2018 Asgedom Y. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
       // print(Realm.Configuration.defaultConfiguration.fileURL)
       
        do {
            _ = try Realm()
        } catch {
            print("Error Initialising Realm. \(error)")
        }
        
        return true
    }
    
    // MARK: - Core Data stack


}

