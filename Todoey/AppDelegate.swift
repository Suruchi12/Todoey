//
//  AppDelegate.swift
//  Todoey
//
//  Created by Suruchi Singh on 1/15/18.
//  Copyright © 2018 Suruchi Singh. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
       
        // print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! as String)
        
        //print(Realm.Configuration.defaultConfiguration.fileURL)
       // let data = Data()
       // data.name = "Suruchi"
       // data.age = 24
        
        
        do{
           _ = try Realm()
        }
        catch{
            print("Error initialising new realm, \(error)")
        }
        return true
    }

   

}

