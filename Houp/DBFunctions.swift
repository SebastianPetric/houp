//
//  DBFunctions.swift
//  Houp
//
//  Created by Sebastian on 27.03.17.
//  Copyright © 2017 SP. All rights reserved.
//

import Foundation

extension DBConnection{

    func checkUsernamePassword(username: String, password: String) -> Bool{
        do{
            let query = self.viewByName!.createQuery()
            let result = try query.run()
            let count = Int(result.count)
            if count > 0 {
                var i = 0
                repeat{
                    if let row = result.nextRow(){
                        if((row.key(at: 0)) as! String != username || (row.key(at: UInt(1))!) as! String != password){
                            if(i == (count - 1)){
                                return true
                            }
                        }else{
                            //Das ist die einmalige UUID, um den Nutzer zu identifizieren
                            //print(row.documentID)
                            return false
                        }
                    }
                    i = i + 1
                }while(i < count)
            }
        }catch{
            print("upps")
        }
        return true
    }
    
    func checkIfUsernameOrEmailAlreadyExists(view: CBLView, usernameOrEmail: String) -> Bool{
        do{
            let query = view.createQuery()
            let result = try query.run()
            let count = Int(result.count)
            let lastItem = count - 1
            if count > 0 {
                var i = 0
                repeat{
                    if let row = result.nextRow(){
                        if((row.key(at: 0)) as! String != usernameOrEmail){
                            if(i == lastItem){
                                return false
                            }
                        }else{
                            //Das ist die einmalige UUID, um den Nutzer zu identifizieren
                           // print(row.documentID)
                            return true
                        }
                    }
                    i = i + 1
                }while(i < count)
            }
        }catch{
            print("upps")
        }
        return false
    }

    func addUserWithProperties(properties: [String: String]) throws{
        if self.DBCon != nil{
            let doc = self.DBCon?.createDocument()
            do {try doc?.putProperties(properties)
                if User.shared.profileImage != nil{
                    let rev = doc?.currentRevision?.createRevision()
                    rev?.setAttachmentNamed("\(User.shared.username)_profileImage.jpeg", withContentType: "image/jpeg", content: User.shared.profileImage)
                    try rev?.save()
                }
            }catch {
                print("Fehler beim reinschreben in die DB")
            }
        }else {
            print("Keine Verbindung zur Datenbank möglich.")
        }
    }
}
