//
//  DBViews.swift
//  Houp
//
//  Created by Sebastian on 27.03.17.
//  Copyright © 2017 SP. All rights reserved.
//

import Foundation

extension DBConnection{

    func createViewByUsernamePassword(db: CBLDatabase) -> CBLView{
        let viewByUsernamePassword = db.viewNamed("viewByUsernamePassword")
        //if (viewByUsernamePassword.mapBlock == nil) {
            let mapBlock: CBLMapBlock = { (doc,emit) in
                if let type = doc["type"] as? String{
                    if type == "User" {
                        emit([doc["username"],doc["password"]], nil)
                    }
                }
            }
            viewByUsernamePassword.setMapBlock(mapBlock, version: "2")
       // }
        return viewByUsernamePassword
    }
    
    func createViewByUsername(db: CBLDatabase) -> CBLView{
        let createViewByUsername = db.viewNamed("viewByUsername")
        if (createViewByUsername.mapBlock == nil) {
            let mapBlock: CBLMapBlock = { (doc,emit) in
                if let type = doc["type"] as? String{
                    if type == "User" {
                        emit(doc["username"], nil)
                    }
                }
            }
            createViewByUsername.setMapBlock(mapBlock, version: "1")
        }
        return createViewByUsername
    }
    
    func createViewByEmail(db: CBLDatabase) -> CBLView{
        let createViewByEmail = db.viewNamed("viewByEmail")
        if (createViewByEmail.mapBlock == nil) {
            let mapBlock: CBLMapBlock = { (doc,emit) in
                if let type = doc["type"] as? String{
                    if type == "User" {
                        emit(doc["email"], nil)
                    }
                }
            }
            createViewByEmail.setMapBlock(mapBlock, version: "1")
        }
        return createViewByEmail
    }


}
