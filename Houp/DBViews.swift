//
//  DBViews.swift
//  Houp
//
//  Created by Sebastian on 27.03.17.
//  Copyright © 2017 SP. All rights reserved.
//

import Foundation

extension DBConnection{
    
    func viewByUsername(db: CBLDatabase) -> CBLView{
        let viewByUsername = db.viewNamed("viewByUsername")
        if (viewByUsername.mapBlock == nil) {
            let mapBlock: CBLMapBlock = { (doc,emit) in
                if let type = doc["type"] as? String{
                    if type == "User" {
                        emit(doc["username"], nil)
                    }
                }
            }
            viewByUsername.setMapBlock(mapBlock, version: "1")
        }
        return viewByUsername
    }
    
    func viewByPrivateGroup(db: CBLDatabase) -> CBLView{
        let viewByPrivateGroup = db.viewNamed("viewByPrivateGroup")
        if (viewByPrivateGroup.mapBlock == nil) {
            let mapBlock: CBLMapBlock = { (doc,emit) in
                if let type = doc["type"] as? String{
                    if type == "PrivateGroup" {
                        emit(doc["secretID"], nil)
                    }
                }
            }
            viewByPrivateGroup.setMapBlock(mapBlock, version: "1")
        }
        return viewByPrivateGroup
    }

    
    func viewByEmail(db: CBLDatabase) -> CBLView{
        let viewByEmail = db.viewNamed("viewByEmail")
        if (viewByEmail.mapBlock == nil) {
            let mapBlock: CBLMapBlock = { (doc,emit) in
                if let type = doc["type"] as? String{
                    if type == "User" {
                        emit(doc["email"], nil)
                    }
                }
            }
            viewByEmail.setMapBlock(mapBlock, version: "1")
        }
        return viewByEmail
    }
}
