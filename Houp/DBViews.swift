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
    
    func viewPrivateGroupBySecretID(db: CBLDatabase) -> CBLView{
        let viewPrivateGroupBySecretID = db.viewNamed("viewByPrivateGroup")
        if (viewPrivateGroupBySecretID.mapBlock == nil) {
            let mapBlock: CBLMapBlock = { (doc,emit) in
                if let type = doc["type"] as? String{
                    if type == "PrivateGroup" {
                        emit(doc["secretID"], nil)
                    }
                }
            }
            viewPrivateGroupBySecretID.setMapBlock(mapBlock, version: "1")
        }
        return viewPrivateGroupBySecretID
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
    
    func viewByThread(db: CBLDatabase) -> CBLView{
        let viewByThread = db.viewNamed("viewByThread")
        if (viewByThread.mapBlock == nil) {
            let mapBlock: CBLMapBlock = { (doc,emit) in
                if let type = doc["type"] as? String{
                    if type == "Thread" {
                        emit(doc["groupID"], nil)
                    }
                }
            }
            viewByThread.setMapBlock(mapBlock, version: "1")
        }
        return viewByThread
    }
    
    func viewByComment(db: CBLDatabase) -> CBLView{
        let viewByComment = db.viewNamed("viewByComment")
        if (viewByComment.mapBlock == nil) {
            let mapBlock: CBLMapBlock = { (doc,emit) in
                if let type = doc["type"] as? String{
                    if type == "Comment" {
                        emit(doc["threadID"], nil)
                    }
                }
            }
            viewByComment.setMapBlock(mapBlock, version: "1")
        }
        return viewByComment
    }


}
