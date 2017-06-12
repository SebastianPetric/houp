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
    var viewByUsername: CBLView?
    var viewByEmail: CBLView?
    var viewPrivateGroupBySecretID: CBLView?
    var viewByThread: CBLView?
    var viewByComment: CBLView?
    var viewByAllActivityInGroup: CBLView?
    var viewByActiveActivityForUser: CBLView?
    var viewByInactiveActivityForUser: CBLView?
    var viewByCommentOfActivity: CBLView?
    var viewThreadByOriginalID: CBLView?
    var viewByThreadByAuthorID: CBLView?
    
    func setUpDBConnection(){
        do {
//           try manager.databaseNamed("couchbaseevents").delete()
//            TempStorageAndCompare.shared.deleteEverything(userIDs: ["-UTYHRo6BY7RVflxl947Zh8","-wuJg6uJGxmlCye-slluirR","-tksH-P72Q1RhFuRoPeQP1e"])
            //LQd3fC
            //hoG8So
            
            self.DBCon = try manager.databaseNamed("couchbaseevents")
            //self.DBCon = try manager.existingDatabaseNamed("couchbaseevents")
            if let dbCon = self.DBCon{
                //Hier werden die Views einmalig erzeugt. Dannach können sie einfach nur noch verwendet werden
                self.viewByUsername = viewByUsername(db: dbCon)
                self.viewByEmail = viewByEmail(db: dbCon)
                self.viewPrivateGroupBySecretID = viewPrivateGroupBySecretID(db: dbCon)
                self.viewByThread = viewByThread(db: dbCon)
                self.viewByComment = viewByComment(db: dbCon)
                self.viewByAllActivityInGroup = viewByAllActivityInGroup(db: dbCon)
                self.viewByActiveActivityForUser = viewByActiveActivityForUser(db: dbCon)
                self.viewByInactiveActivityForUser = viewByInactiveActivityForUser(db: dbCon)
                self.viewByCommentOfActivity = viewByCommentOfActivity(db: dbCon)
                self.viewThreadByOriginalID = viewThreadByOriginalID(db: dbCon)
                self.viewByThreadByAuthorID = viewByThreadByAuthorID(db: dbCon)
                
                self.pushToDB = dbCon.createPushReplication(kSyncGatewayUser! as URL)
                self.pullFromDB = dbCon.createPullReplication(kSyncGatewayUser! as URL)
                
                
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
        } catch {
            print("Upps")
        }
    }
    
    func getDBConnection() -> CBLDatabase?{
        if let con = self.DBCon{
        return con
        }else{
        return nil
        }
    }
}
