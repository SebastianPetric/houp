//
//  DBFunctions.swift
//  Houp
//
//  Created by Sebastian on 27.03.17.
//  Copyright © 2017 SP. All rights reserved.
//

import Foundation

extension DBConnection{

    func checkUsernamePassword(username: String, password: String) -> String?{
        do{
            let query = self.viewByUsername!.createQuery()
            // Ein array von keys. beim view wird zwar auch ein array emittet, jedoch wird hier verglichen ob nur ein key zu dem emitteten key passt. wenn also beim view ein array emitted wird, so zählt das array als ein key-wert
            query.keys = [username]
            let result = try query.run()
            let count = Int(result.count)
//            if count > 0 {
//                var i = 0
//                repeat{
//                    if let row = result.nextRow(){
//                        if((row.key(at: 0)) as! String != username || (row.key(at: UInt(1))!) as! String != password){
//                            if(i == (count - 1)){
//                                return true
//                            }
//                        }else{
//                            //Das ist die einmalige UUID, um den Nutzer zu identifizieren
//                            //print(row.documentID)
//                            return false
//                        }
//                    }
//                    i = i + 1
//                }while(i < count)
//            }
            if (count > 0) {
                while let row = result.nextRow(){
                    if let passw = row.document?["password"] as? String{
                        if (passw == password){
                            if let userID = row.documentID{
                                return userID
                            }
                        }else{
                        return nil
                        }
                    }else{
                    return nil
                    }
                }
            }else{
            return nil
            }
        }catch{
        return nil
        }
        return nil
    }
    
    func checkIfEmailAlreadyExists(email: String) -> Bool{
        do{
            if let view = self.viewByEmail{
                let query = view.createQuery()
                query.keys = [email]
                let result = try query.run()
                let count = Int(result.count)
                //            let lastItem = count - 1
                //            if count > 0 {
                //                var i = 0
                //                repeat{
                //                    if let row = result.nextRow(){
                //                        if((row.key(at: 0)) as! String != usernameOrEmail){
                //                            if(i == lastItem){
                //                                return false
                //                            }
                //                        }else{
                //                            //Das ist die einmalige UUID, um den Nutzer zu identifizieren
                //                           // print(row.documentID)
                //                            return true
                //                        }
                //                    }
                //                    i = i + 1
                //                }while(i < count)
                //            }
                if(count > 0){
                    return true
                }else{
                    return false
                }
            }
        }catch{
            return true
        }
        return false
    }
    
    func checkIfUsernameAlreadyExists(username: String) -> Bool{
        do{
            if let view = self.viewByUsername{
                let query = view.createQuery()
                query.keys = [username]
                let result = try query.run()
                let count = Int(result.count)
                if(count > 0){
                    return true
                }else{
                    return false
                }
            }
        }catch{
            return true
        }
        return false
    }

    
    
    func getAllPrivateGroups() -> [PrivateGroup] {
       var privateGroupList: [PrivateGroup] = [PrivateGroup]()
    do{
        if let userID = UserDefaults.standard.string(forKey: GetString.userID.rawValue){
                let query = DBConnection.shared.getDBConnection()?.createAllDocumentsQuery()
                //query?.addObserver(self, forKeyPath: "rows", options: nil, context: nil)
                //NotificationCenter.default.addObserver(self, selector: #selector(replicationChanged), name: NSNotification.Name.cblReplicationChange, object: push)
                query?.allDocsMode = CBLAllDocsMode.allDocs
                query?.keys = [userID]
                let result = try query?.run()
                var groupIDs: [String] = [String]()
            
                while let row = result?.nextRow() {
                    if let IDs = row.document?["groupIDs"] as! [String]?{
                    groupIDs = IDs
                    }
                }
                if (groupIDs.count != 0){
                    query?.keys = groupIDs
                    let privateGroups = try query?.run()
                    while let row = privateGroups?.nextRow() {
                    let timeDate = row.document?["timeOfMeeting"] as! String
                    let formatter = DateFormatter()
                        formatter.dateFormat = "HH:mm"
                        
                    let privateGroup = PrivateGroup(pgid: row.documentID, adminID: row.document?["adminID"] as? String, nameOfGroup: row.document?["nameOfGroup"] as? String, location: row.document?["location"] as? String, dayOfMeeting: row.document?["dayOfMeeting"] as? String, timeOfMeeting: formatter.date(from: timeDate), secretID: row.document?["secretID"] as? String, threadIDs: row.document?["threadIDs"] as? [String], memberIDs: row.document?["memberIDs"] as? [String], dailyActivityIDs: row.document?["dailyActivityIDs"] as? [String], groupRequestIDs: row.document?["groupRequestIDs"] as? [String])
                       privateGroupList.append(privateGroup)
                    }
                }
            }
        }catch{
        return [PrivateGroup]()
        }
        return privateGroupList
    }


    func addUserWithProperties(properties: [String: Any]) -> String?{
        do{
        if let con = DBConnection.shared.getDBConnection(){
            let doc = con.createDocument()
            try doc.putProperties(properties)
                if User.shared.profileImage != nil{
                    let rev = doc.currentRevision?.createRevision()
                    rev?.setAttachmentNamed("\(User.shared.username!)_profileImage.jpeg", withContentType: "image/jpeg", content: User.shared.profileImage)
                    try rev?.save()
                }
        }else {
            return GetString.errorWithConnection.rawValue
        }
        }catch{
            return GetString.errorWithConnection.rawValue
        }
        return GetString.errorWithConnection.rawValue
    }
    
    func makeRequestToPrivateGroup(secretID: String) -> String?{
        
        do{
        if let con = DBConnection.shared.getDBConnection(){
            if let userID = UserDefaults.standard.string(forKey: GetString.userID.rawValue){
                if let view = self.viewByPrivateGroup{
                let query = view.createQuery()
                query.keys = [secretID]
                let result = try query.run()
                let count = Int(result.count)
                    var memIDs: [String] = [String]()
                    var reqIDs: [String] = [String]()
                    if(count == 1){
                        while let row = result.nextRow() {
                            let docU = con.document(withID: row.documentID!)
                            try docU?.update({ (rev) -> Bool in
                            if let adminID = row.document?["adminID"] as! String?, let requestIDs = row.document?["groupRequestIDs"] as! [String]?, let memberIDs = row.document?["memberIDs"] as! [String]?{
                                reqIDs = requestIDs
                                memIDs = memberIDs
                                if(userID != adminID && !reqIDs.contains(userID) && !memIDs.contains(userID)){
                                    print("hier")
                                    reqIDs.append(userID)
                                    rev["groupRequestIDs"] = reqIDs
                                }else {return false}
                            }
                                return true
                            })
                        }
//                        if let adminID = row.document?["adminID"] as! String?, let requestIDs = row.document?["groupRequestIDs"] as! [String]?, let memberIDs = row.document?["memberIDs"] as! [String]?{
//                            reqIDs = requestIDs
//                            memIDs = memberIDs
//                            if(userID != adminID){
//                                if(!reqIDs.contains(userID)){
//                                    if(!memIDs.contains(userID)){
//                                        reqIDs.append(userID)
//                                        let docU = con.document(withID: row.documentID!)
//                                        try docU?.update({ (rev) -> Bool in
//                                            rev["groupRequestIDs"] = reqIDs
//                                            return true
//                                        })
//                                    }else{
//                                        return "Sie sind bereits Mitglied dieser Gruppe."
//                                    }
//                                }else{
//                                    return "Sie haben bereits eine Anfrage versendet"
//                                }
//                            }else{
//                                return "Sie sind bereits Admin der Gruppe"
//                            }
//                        }
//                        
                        
                        
                        
//                        let docU = con.document(withID: row.documentID!)
//                        
//                        try docU?.update({ (rev) -> Bool in
//                            if let adminID = row.document?["adminID"] as! String?, let requestIDs = row.document?["groupRequestIDs"] as! [String]?, let memberIDs = row.document?["memberIDs"] as! [String]?{
//                                reqIDs = requestIDs
//                                memIDs = memberIDs
//                                if(userID != adminID){
//                                    if(!reqIDs.contains(userID)){
//                                        if(!memIDs.contains(userID)){
//                                            reqIDs.append(userID)
//                                        }else{
//                                            return "Sie sind bereits Mitglied dieser Gruppe."
//                                        }
//                                    }else{
//                                        return "Sie haben bereits eine Anfrage versendet"
//                                    }
//                                }else{
//                                    return "Sie sind bereits Admin der Gruppe"
//                                }
//                            }
//                            rev["groupRequestIDs"] = reqIDs
//                            return true
//                        })
//                        

                        
                        
                        
                        return nil
                    }else{
                    return "Gruppe existiert nicht."
                    }
                }else{
                }
            }else{
            return "Nicht mehr eingelogged."
            }
        }else{
        return "Keine Verbindung zur Datenbank möglich."
        }
        }catch{
            return "Du hast bereits eine Anfrage gesendet oder bist schon Mitglied der Gruppe."
        }
        return nil
    }
    
    func createPrivateGroup(properties: [String: Any]) -> String?{
    do{
        if let con = DBConnection.shared.getDBConnection(){
                do{
                let doc = con.createDocument()
                try doc.putProperties(properties)
                    if let userID = UserDefaults.standard.string(forKey: GetString.userID.rawValue){
                        let docU = con.document(withID: userID)
                        var array: [String] = [String]()
                        try docU?.update({ (rev) -> Bool in
                            if let curArray = rev["groupIDs"] as! [String]?{
                                array = curArray
                                array.append(doc.documentID)
                                rev["groupIDs"] = array
                            }
                            return true
                        })
                    }
                }catch{
                    return GetString.errorWithConnection.rawValue
                }
        }else {
            return "Keine Verbindung zur Datenbank möglich."
        }
    }catch{
    return GetString.errorWithConnection.rawValue
    }
    return nil
    }
}
