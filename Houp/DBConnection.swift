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
    var viewUserByUsername: CBLView?
    var viewUserByEmail: CBLView?
    var viewPrivateGroupBySecretID: CBLView?
    var viewCommentByThreadID: CBLView?
    var viewByAllActivityInGroup: CBLView?
    var viewByActiveActivityForUser: CBLView?
    var viewByInactiveActivityForUser: CBLView?
    var viewCommentByDailyActivityID: CBLView?
    var viewThreadByOriginalID: CBLView?
    var viewThreadByAuthorID: CBLView?
    var viewThreadByGroupID: CBLView?
    var viewByInactiveActivityForGroup: CBLView?
    
    func setUpDBConnection(){
        do {
//           try manager.databaseNamed("couchbaseevents").delete()
//            TempStorageAndCompare.shared.deleteEverything(userIDs: ["-LtFxm_LD-jcVRbahq2327n","-msIknyRFO3GBdqdyZd3mCc"])
            //cH7gNM
            self.DBCon = try manager.databaseNamed("couchbaseevents")
            
            if let dbCon = self.DBCon{
                self.viewUserByUsername = viewUserByUsername(db: dbCon)
                self.viewUserByEmail = viewUserByEmail(db: dbCon)
                self.viewPrivateGroupBySecretID = viewPrivateGroupBySecretID(db: dbCon)
                self.viewCommentByThreadID = viewCommentByThreadID(db: dbCon)
                self.viewByAllActivityInGroup = viewByAllActivityInGroup(db: dbCon)
                self.viewByActiveActivityForUser = viewByActiveActivityForUser(db: dbCon)
                self.viewByInactiveActivityForUser = viewByInactiveActivityForUser(db: dbCon)
                self.viewCommentByDailyActivityID = viewCommentByDailyActivityID(db: dbCon)
                self.viewThreadByOriginalID = viewThreadByOriginalID(db: dbCon)
                self.viewThreadByAuthorID = viewThreadByAuthorID(db: dbCon)
                self.viewThreadByGroupID = viewThreadByGroupID(db: dbCon)
                self.viewByInactiveActivityForGroup = viewByInactiveActivityForGroup(db: dbCon)
                
                self.pushToDB = dbCon.createPushReplication(kSyncGatewayUser! as URL)
                self.pullFromDB = dbCon.createPullReplication(kSyncGatewayUser! as URL)
                
                
                if let push = self.pushToDB, let pull = self.pullFromDB{
                    push.continuous = true
                    pull.continuous = true
                    
                    var auth: CBLAuthenticatorProtocol?
                    auth = CBLAuthenticator.basicAuthenticator(withName: "sync_users", password: "BJCphrD6")
                    push.authenticator = auth
                    pull.authenticator = auth
                    
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
