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
    
    func viewByThreadByAuthorID(db: CBLDatabase) -> CBLView{
        let viewByThreadByAuthorID = db.viewNamed("viewByThreadByAuthorID")
        if (viewByThreadByAuthorID.mapBlock == nil) {
            let mapBlock: CBLMapBlock = { (doc,emit) in
                if let type = doc["type"] as? String{
                    if type == "Thread" {
                        emit(doc["authorID"], nil)
                    }
                }
            }
            viewByThreadByAuthorID.setMapBlock(mapBlock, version: "1")
        }
        return viewByThreadByAuthorID
    }

    
    func viewThreadByOriginalID(db: CBLDatabase) -> CBLView{
        let viewThreadByOriginalID = db.viewNamed("viewThreadByOriginalID")
        if (viewThreadByOriginalID.mapBlock == nil) {
            let mapBlock: CBLMapBlock = { (doc,emit) in
                if let type = doc["type"] as? String{
                    if type == "Thread" {
                        emit(doc["originalID"], nil)
                    }
                }
            }
            viewThreadByOriginalID.setMapBlock(mapBlock, version: "1")
        }
        return viewThreadByOriginalID
    }

    
    func viewByAllActivityInGroup(db: CBLDatabase) -> CBLView{
        let viewByActiveActivityInGroup = db.viewNamed("viewByActiveActivityInGroup")
        if (viewByActiveActivityInGroup.mapBlock == nil) {
            let mapBlock: CBLMapBlock = { (doc,emit) in
                if let type = doc["type"] as? String, let isInProcess = doc["isInProcess"] as? Bool, let groupID = doc["groupID"] as? String{
                    if (type == "DailyActivity" && isInProcess == false) {
                        emit(doc["groupID"], nil)
                    }
                }
            }
            viewByActiveActivityInGroup.setMapBlock(mapBlock, version: "1")
        }
        return viewByActiveActivityInGroup
    }
    
    func viewByActiveActivityForUser(db: CBLDatabase) -> CBLView{
        let viewByActiveActivityForUser = db.viewNamed("viewByActiveActivityForUser")
        if (viewByActiveActivityForUser.mapBlock == nil) {
            let mapBlock: CBLMapBlock = { (doc,emit) in
                if let type = doc["type"] as? String, let isInProcess = doc["isInProcess"] as? Bool{
                    if (type == "DailyActivity" && isInProcess == true) {
                        emit(doc["authorID"], nil)
                    }
                }
            }
            viewByActiveActivityForUser.setMapBlock(mapBlock, version: "1")
        }
        return viewByActiveActivityForUser
    }
    
    func viewByInactiveActivityForUser(db: CBLDatabase) -> CBLView{
        let viewByInactiveActivityForUser = db.viewNamed("viewByInactiveActivityForUser")
        if (viewByInactiveActivityForUser.mapBlock == nil) {
            let mapBlock: CBLMapBlock = { (doc,emit) in
                if let type = doc["type"] as? String, let isInProcess = doc["isInProcess"] as? Bool{
                    if (type == "DailyActivity" && isInProcess == false) {
                        emit(doc["authorID"], nil)
                    }
                }
            }
            viewByInactiveActivityForUser.setMapBlock(mapBlock, version: "1")
        }
        return viewByInactiveActivityForUser
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
    
    func viewByCommentOfActivity(db: CBLDatabase) -> CBLView{
        let viewByCommentOfActivity = db.viewNamed("viewByCommentOfActivity")
        if (viewByCommentOfActivity.mapBlock == nil) {
            let mapBlock: CBLMapBlock = { (doc,emit) in
                if let type = doc["type"] as? String{
                    if type == "Comment" {
                        emit(doc["dailyActivityID"], nil)
                    }
                }
            }
            viewByCommentOfActivity.setMapBlock(mapBlock, version: "1")
        }
        return viewByCommentOfActivity
    }



}
