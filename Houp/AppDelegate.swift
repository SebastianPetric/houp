//
//  AppDelegate.swift
//  Houp
//
//  Created by Sebastian on 17.03.17.
//  Copyright © 2017 SP. All rights reserved.
//

import UIKit
import CoreData


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var userDefaults: UserDefaults?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
//        if let connection = DBConnection.shared.getDBConnection(){
//            print(connection)
//        }else{
//            DBConnection.shared.setUpDBConnection()
//            let root = CustomNavigationBarController.shared.getCustomNavControllerWithNameAndImage(customController: LoginViewController(),navBarTitle: GetString.appName.rawValue, barItemTitle: "", image: "")
//            window?.rootViewController = root
//        }

        DBConnection.shared.setUpDBConnection()
        let root = CustomNavigationBarController.shared.getCustomNavControllerWithNameAndImage(customController: LoginViewController(),navBarTitle: GetString.appName.rawValue, barItemTitle: "", image: "")
        window?.rootViewController = root
        
//        if(UserDefaults.standard.string(forKey: GetString.userID.rawValue) == nil){
//            let root = CustomNavigationBarController.shared.getCustomNavControllerWithNameAndImage(customController: LoginViewController(),navBarTitle: GetString.appName.rawValue, barItemTitle: "", image: "")
//            window?.rootViewController = root
//        }else{
//            window?.rootViewController = CustomTabBarController()
//        }
        UIApplication.shared.statusBarStyle = .lightContent
        return true
    }
    
   func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
    return .portrait
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        print("wieder aktiv")
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        print("im background")
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        print("will enter foreground")
        
//        if let connection = DBConnection.shared.getDBConnection(){
//            print("alles ok")
//        }else{
//            DBConnection.shared.setUpDBConnection()
//            let root = CustomNavigationBarController.shared.getCustomNavControllerWithNameAndImage(customController: LoginViewController(),navBarTitle: GetString.appName.rawValue, barItemTitle: "", image: "")
//            window?.rootViewController = root
//        }
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
//        if let connection = DBConnection.shared.getDBConnection(){
//            print(connection)
//        }else{
//            DBConnection.shared.setUpDBConnection()
//            let root = CustomNavigationBarController.shared.getCustomNavControllerWithNameAndImage(customController: LoginViewController(),navBarTitle: GetString.appName.rawValue, barItemTitle: "", image: "")
//            window?.rootViewController = root
//        }
        print("did become Active")
        //DBConnection.shared.setUpDBConnection()
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        print("will terminate")
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Houp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        
        if(DBConnection.shared.getDBConnection() != nil){
            if(notification.alertTitle! == "Hey! Wie ging es dir heute?"){
                let controller = CustomTabBarController()
                controller.selectedIndex = 2
                window?.rootViewController = controller
            }
        }else{
            let root = CustomNavigationBarController.shared.getCustomNavControllerWithNameAndImage(customController: LoginViewController(),navBarTitle: GetString.appName.rawValue, barItemTitle: "", image: "")
            window?.rootViewController = root
        }
        
    }

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

