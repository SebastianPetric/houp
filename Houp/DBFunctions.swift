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
            let query = self.viewByName!.createQuery()
            // Ein array von keys. beim view wird zwar auch ein array emittet, jedoch wird hier verglichen ob nur ein key zu dem emitteten key passt. wenn also beim view ein array emitted wird, so zählt das array als ein key-wert
            query.keys = [[username, password]]
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
            if (count == 1) {
                if let userID = result.nextRow()?.documentID{
                return userID
                }
            }else{
            return nil
            }
            
        }catch{
            print("upps")
        }
        return nil
    }
    
    func checkIfUsernameOrEmailAlreadyExists(view: CBLView, usernameOrEmail: String) -> Bool{
        do{
            let query = view.createQuery()
            query.keys = [usernameOrEmail]
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
        }catch{
            print("upps")
        }
        return false
    }
    
    
    func getAllPrivateGroups() throws -> [PrivateGroup] {
       var privateGroupList: [PrivateGroup] = [PrivateGroup]()
        if let userID = UserDefaults.standard.string(forKey: GetString.userID.rawValue){
                let query = DBConnection.shared.getDBConnection()?.createAllDocumentsQuery()
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
                        
                    let privateGroup = PrivateGroup(pgid: row.documentID, adminID: row.document?["adminID"] as? String, nameOfGroup: row.document?["nameOfGroup"] as? String, location: row.document?["location"] as? String, dayOfMeeting: row.document?["dayOfMeeting"] as? Int, timeOfMeeting: formatter.date(from: timeDate), secretID: row.document?["secretID"] as? String, threadIDs: nil, memberIDs: nil, dailyActivityIDs: nil, groupRequestIDs: nil)
                       privateGroupList.append(privateGroup)
                    }
                    
                }
            }
        return privateGroupList
    }


    func addUserWithProperties(properties: [String: String]) throws{
        if let con = DBConnection.shared.getDBConnection(){
            let doc = con.createDocument()
            try doc.putProperties(properties)
                if User.shared.profileImage != nil{
                    let rev = doc.currentRevision?.createRevision()
                    rev?.setAttachmentNamed("\(User.shared.username!)_profileImage.jpeg", withContentType: "image/jpeg", content: User.shared.profileImage)
                    try rev?.save()
                }
        }else {
            print("Keine Verbindung zur Datenbank möglich.")
        }
    }
    
    func createPrivateGroup(properties: [String: Any]) throws{
        if let con = DBConnection.shared.getDBConnection(){
            con.inTransaction({ () -> Bool in
                do{
                let doc = con.createDocument()
                try doc.putProperties(properties)
                    if let userID = UserDefaults.standard.string(forKey: GetString.userID.rawValue){
                        let docU = con.document(withID: userID)
                        var array: [String] = [String]()
                        try docU?.update({ (rev) -> Bool in
                            if let curArray = rev["groupIDs"]{
                                array = curArray as! [String]
                                array.append(doc.documentID)
                                rev["groupIDs"] = array
                            }else{
                                array.append(doc.documentID)
                                rev["groupIDs"] = array
                            }
                            return true
                        })
                    }
                }catch{
                    return false
                }
                return true
            })
        }else {
            print("Keine Verbindung zur Datenbank möglich.")
        }
    }
}
