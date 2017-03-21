//
//  AppDelegate.swift
//  Houp
//
//  Created by Sebastian on 17.03.17.
//  Copyright © 2017 SP. All rights reserved.
//

import UIKit
import CoreData

let manager = CBLManager.sharedInstance()
typealias CBLDoc = CBLDocument
let kSyncGatewayUser = NSURL(string: "http://127.0.0.1:4984/couchbaseevents")
let kSyncGatewayAdmin = NSURL(string: "http://127.0.0.1:4985/couchbaseevents")
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        let root = UINavigationController(rootViewController: LoginViewController())
        root.navigationBar.isTranslucent = false
        root.navigationBar.topItem?.title = "Houp"
        //root.navigationBar.tintColor = .black
        window?.rootViewController = root
         print(window?.rootViewController?.navigationController?.topViewController)
        
        
        
        do {
            let db = try manager.databaseNamed("couchbaseevents")
            
            
            let properties = [
                "type": "User",
                "name": "Sebastian",
                "email": "sebastian@gmail.com",
                "repo": "swift-couchbaselite-cheatsheet"
            ]
            
            //Fügt User zur Datenbank hinzu
            //try addUserWithProperties(db: db, properties: properties)
            
            
            //Gibt ein View zurück welches nach Namen sucht
           // let viewByName = createViewByName(db: db)
            
            
            // Sucht alle User und löscht sie aus der DB
            //try deleteAllUsers(db: db, view: viewByName)
            
            
            
            //Gibt einen view zurück der nach einem Type sucht
           // let viewByType = createViewByType(db: db)
            
            
            // Sucht nach den registrierten Usern und gibt sie in Konsole aus
            //try checkIfUserExists(db: db, view: viewByType)
            
            //Synchronisiert lokale Datenbank mit online DB
           // syncDatabases(db: db)
            
            
        } catch {
            print(error)
        }
        return true
    }
    
   func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
    if self.window?.rootViewController?.presentedViewController is LoginViewController{
    print("hallo")
    }
    print(self.window?.rootViewController?.navigationController?.topViewController)
    return .portrait
    }
    
    private func checkIfUserExists(db: CBLDatabase, view: CBLView) throws{
        let query = view.createQuery()
        //let query = db.viewNamed("type").createQuery()
        //query.keys = ["mirco.zeiss@gmail.com","Test ohne authentifizierung"]
        let result = try query.run()
        
        let count = Int(result.count)
        
        if (count == 0){
            print("Person kann registriert werden")
        }else{
            for index in 0 ..< count {
                let i = index + 1
                print("User \(i)")
                print("email: \(result.row(at: UInt(index)).key(at: UInt(0))!)")
                print("name: \(result.row(at: UInt(index)).key(at: UInt(1))!)")
                
                /* print(result.row(at: UInt(index)).documentID)
                 if let id = result.row(at: UInt(index)).documentID{
                 try db.document(withID: id)!.delete()
                 }*/
            }
        }
    }
    
    private func syncDatabases(db: CBLDatabase){
        let push = db.createPushReplication(kSyncGatewayUser as! URL)
        let pull = db.createPullReplication(kSyncGatewayUser as! URL)
        push.continuous = true
        pull.continuous = true
        
        var auth: CBLAuthenticatorProtocol?
        auth = CBLAuthenticator.basicAuthenticator(withName: "sync_users", password: "BJCphrD6")
        push.authenticator = auth
        pull.authenticator = auth
        NotificationCenter.default.addObserver(self, selector: #selector(replicationChanged), name: NSNotification.Name.cblReplicationChange, object: push)
        NotificationCenter.default.addObserver(self, selector: #selector(replicationChangedonDB), name: NSNotification.Name.cblReplicationChange, object: pull)
        push.start()
        pull.start()
    }
    
    @objc private func replicationChanged(){
    print("Changed")
    
    }
    
    @objc private func replicationChangedonDB(){
    print("Something changed on Db")
    }
    
    private func createViewByType(db: CBLDatabase) -> CBLView{
        
        let viewByType = db.viewNamed("list/type")
        if !(viewByType.mapBlock != nil) {
            var mapBlock: CBLMapBlock = { (doc,emit) in
                if let type = doc["type"] as? String{
                    if type == "User" {
                        emit([doc["email"],doc["name"]], nil)
                    }
                }
            }
            viewByType.setMapBlock(mapBlock, version: "1")
        }
        return viewByType
    }
    
    
    
    private func createViewByName(db: CBLDatabase) -> CBLView{
        
        let viewByName = db.viewNamed("name")
        if (viewByName.mapBlock != nil) {
            let block: CBLMapBlock = { (doc, emit) in
                emit(doc["name"], nil)
            }
            viewByName.setMapBlock(block, version: "1")
        }
        return viewByName
    }
    
    private func addUserWithProperties(db: CBLDatabase, properties: [String : String]) throws{
        let doc = db.createDocument()
        try doc.putProperties(properties)
    }
    
    
    private func deleteAllUsers(db: CBLDatabase, view: CBLView) throws{
        
        let query = view.createQuery()
        let result = try query.run()
        let count = Int(result.count)
        
        for index in 0 ..< count {
            //print(result.row(at: UInt(index)).document!)
            if let docId = result.row(at: UInt(index)).documentID{
                try db.document(withID: docId)!.delete()
            }
        }
    }


    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
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

