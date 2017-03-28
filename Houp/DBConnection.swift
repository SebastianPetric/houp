//
//  DBConnection.swift
//  Houp
//
//  Created by Sebastian on 23.03.17.
//  Copyright © 2017 SP. All rights reserved.
//

import Foundation

class DBConnection{
    
    static let shared: DBConnection = DBConnection()
    
    let manager = CBLManager.sharedInstance()
    typealias CBLDoc = CBLDocument
    let kSyncGatewayUser = NSURL(string: "http://127.0.0.1:4984/couchbaseevents")
    let kSyncGatewayAdmin = NSURL(string: "http://127.0.0.1:4985/couchbaseevents")
    var DBCon: CBLDatabase?
    var pushToDB: CBLReplication?
    var pullFromDB: CBLReplication?
    var viewByType: CBLView?
    var viewByName: CBLView?
    var viewByUsername: CBLView?
    var viewByEmail: CBLView?
    
    func setUpDBConnection(){
        do {
           // try manager.databaseNamed("couchbaseevents").delete()
            self.DBCon = try manager.databaseNamed("couchbaseevents")
            
            if let dbCon = self.DBCon{
                
                self.pushToDB = dbCon.createPushReplication(kSyncGatewayUser as! URL)
                self.pullFromDB = dbCon.createPullReplication(kSyncGatewayUser as! URL)
                
                
                if let push = self.pushToDB, let pull = self.pullFromDB{
                    push.continuous = true
                    pull.continuous = true
                    
                    var auth: CBLAuthenticatorProtocol?
                    auth = CBLAuthenticator.basicAuthenticator(withName: "sync_users", password: "BJCphrD6")
                    push.authenticator = auth
                    pull.authenticator = auth
//                    NotificationCenter.default.addObserver(self, selector: #selector(replicationChanged), name: NSNotification.Name.cblReplicationChange, object: push)
//                    NotificationCenter.default.addObserver(self, selector: #selector(replicationChangedonDB), name: NSNotification.Name.cblReplicationChange, object: pull)
                    push.start()
                    pull.start()
                    self.pushToDB = push
                    self.pullFromDB = pull
                }
            }
            
            //Hier werden die Views einmalig erzeugt. Dannach können sie einfach nur noch verwendet werden
            self.viewByName = createViewByUsernamePassword(db: getDBConnection())
            self.viewByUsername = createViewByUsername(db: getDBConnection())
            self.viewByEmail = createViewByEmail(db: getDBConnection())
        } catch {
            print(error)
        }
    }
    
    func getDBConnection() -> CBLDatabase{
        return self.DBCon!
    }
}
