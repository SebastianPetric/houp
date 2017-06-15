//
//  DBViews.swift
//  Houp
//
//  Created by Sebastian on 27.03.17.
//  Copyright © 2017 SP. All rights reserved.
//

import Foundation

extension DBConnection{
    
    func viewUserByUsername(db: CBLDatabase) -> CBLView{
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

    
    func viewUserByEmail(db: CBLDatabase) -> CBLView{
        let viewUserByEmail = db.viewNamed("viewByEmail")
        if (viewUserByEmail.mapBlock == nil) {
            let mapBlock: CBLMapBlock = { (doc,emit) in
                if let type = doc["type"] as? String{
                    if type == "User" {
                        emit(doc["email"], nil)
                    }
                }
            }
            viewUserByEmail.setMapBlock(mapBlock, version: "1")
        }
        return viewUserByEmail
    }
    
    func viewThreadByGroupID(db: CBLDatabase) -> CBLView{
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

    
    func viewThreadByAuthorID(db: CBLDatabase) -> CBLView{
        let viewThreadByAuthorID = db.viewNamed("viewByThreadByAuthorID")
        if (viewThreadByAuthorID.mapBlock == nil) {
            let mapBlock: CBLMapBlock = { (doc,emit) in
                if let type = doc["type"] as? String{
                    if type == "Thread" {
                        emit(doc["authorID"], nil)
                    }
                }
            }
            viewThreadByAuthorID.setMapBlock(mapBlock, version: "1")
        }
        return viewThreadByAuthorID
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
    
    func viewByInactiveActivityForGroup(db: CBLDatabase) -> CBLView{
        let viewByInactiveActivityForGroup = db.viewNamed("viewByInactiveActivityForGroup")
        if (viewByInactiveActivityForGroup.mapBlock == nil) {
            let mapBlock: CBLMapBlock = { (doc,emit) in
                if let type = doc["type"] as? String, let isInProcess = doc["isInProcess"] as? Bool{
                    if (type == "DailyActivity" && isInProcess == false) {
                        emit(doc["groupID"], nil)
                    }
                }
            }
            viewByInactiveActivityForGroup.setMapBlock(mapBlock, version: "1")
        }
        return viewByInactiveActivityForGroup
    }


    
    func viewCommentByThreadID(db: CBLDatabase) -> CBLView{
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
    
    func viewCommentByDailyActivityID(db: CBLDatabase) -> CBLView{
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
