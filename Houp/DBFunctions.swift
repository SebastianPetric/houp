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
            let query = self.viewUserByUsername!.createQuery()
            // Ein array von keys. beim view wird zwar auch ein array emittet, jedoch wird hier verglichen ob nur ein key zu dem emitteten key passt. wenn also beim view ein array emitted wird, so zählt das array als ein key-wert
            query.keys = [username]
            let result = try query.run()
            let count = Int(result.count)
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
            if let view = self.viewUserByEmail{
                let query = view.createQuery()
                query.keys = [email]
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
    
    func getAllThreadsOfGroup(groupID: String) -> [Thread]{
        var threads = [Thread]()
        do{
            if let view = self.viewThreadByGroupID{
            let query = view.createQuery()
                query.keys = [groupID]
            let result = try query.run()
                while let row = result.nextRow() {
                    if let props = row.document!.properties {
                        var userName: String?
                        if let authorUserName = row.document?["authorID"] as? String{
                            let queryForUsername = DBConnection.shared.getDBConnection()?.createAllDocumentsQuery()
                            queryForUsername?.allDocsMode = CBLAllDocsMode.allDocs
                            queryForUsername?.keys = [authorUserName]
                            let result = try queryForUsername?.run()
                            while let row = result?.nextRow() {
                                userName = row.document?["username"] as? String
                            }
                        }
                        let thread = Thread(props: props)
                        thread.userName = userName
                        //let thread = Thread(rev: row.documentRevisionID, tid: row.documentID,originalID: row.document?["originalID"] as? String, authorID: row.document?["authorID"] as? String, authorUsername: userName, groupID: row.document?["groupID"] as? String, title: row.document?["title"] as? String, message: row.document?["message"] as? String, date: nil, dateString: row.document?["date"] as? String ,commentIDs: row.document?["commentIDs"] as? [String])
                        threads.append(thread)
                    }
                }
            }
        }catch{
        return [Thread]()
        }
        return threads
    }
    
    func checkIfUsernameAlreadyExists(username: String) -> Bool{
        do{
            if let view = self.viewUserByUsername{
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
                let userID = UserDefaults.standard.string(forKey: GetString.userID.rawValue)
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
                        if let props = row.document!.properties {
                            let privateGroup = PrivateGroup(props: props)
                            
                            //let privateGroup = PrivateGroup(rev: row.documentRevisionID, pgid: row.documentID, adminID: row.document?["adminID"] as? String, nameOfGroup: row.document?["nameOfGroup"] as? String, location: row.document?["location"] as? String, dayOfMeeting: row.document?["dayOfMeeting"] as? String, timeOfMeeting: nil, timeOfMeetingString: row.document?["timeOfMeeting"] as? String, secretID: row.document?["secretID"] as? String, threadIDs: row.document?["threadIDs"] as? [String], memberIDs: row.document?["memberIDs"] as? [String], dailyActivityIDs: row.document?["dailyActivityIDs"] as? [String], groupRequestIDs: row.document?["groupRequestIDs"] as? [String], createdAt: nil, createdAtString: row.document?["createdAt"] as? String)
                            privateGroupList.append(privateGroup)
                        }
                    }
                }
        }catch{
        return [PrivateGroup]()
        }
        return privateGroupList
    }
    
    func getAllPrivateGroupsFirstTime() -> [PrivateGroup] {
        var privateGroupList: [PrivateGroup] = [PrivateGroup]()
        
        do{
                let userID = UserDefaults.standard.string(forKey: GetString.userID.rawValue)
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
                        if let props = row.document!.properties {
                            let privateGroup = PrivateGroup(props: props)
                            
                            //let privateGroup = PrivateGroup(rev: row.documentRevisionID ,pgid: row.documentID, adminID: row.document?["adminID"] as? String, nameOfGroup: row.document?["nameOfGroup"] as? String, location: row.document?["location"] as? String, dayOfMeeting: row.document?["dayOfMeeting"] as? String, timeOfMeeting: nil, timeOfMeetingString: row.document?["timeOfMeeting"] as? String ,secretID: row.document?["secretID"] as? String, threadIDs: row.document?["threadIDs"] as? [String], memberIDs: row.document?["memberIDs"] as? [String], dailyActivityIDs: row.document?["dailyActivityIDs"] as? [String], groupRequestIDs: row.document?["groupRequestIDs"] as? [String], createdAt: nil, createdAtString: row.document?["createdAt"] as? String)
                            privateGroupList.append(privateGroup)
                        }
                    }
                }
                
                var threads: [Thread]?
                
                for group in privateGroupList {
                    threads = [Thread]()
                    if let groupThreadIDsCount = group.threadIDs?.count{
                        if(groupThreadIDsCount > 0){
                            query?.keys = group.threadIDs
                            let threadsList = try query?.run()
                            while let row = threadsList?.nextRow(){
                                if let props = row.document!.properties {
                                    let thread = Thread(props: props)
                                    //let thread = Thread(rev: row.documentRevisionID, tid: row.documentID,originalID: row.document?["originalID"] as? String, authorID: row.document?["authorID"] as? String, authorUsername: nil, groupID: row.document?["groupID"] as? String, title: row.document?["title"] as? String, message: row.document?["message"] as? String, date: nil, dateString: row.document?["date"] as? String ,commentIDs: row.document?["commentIDs"] as? [String])
                                    threads!.append(thread)
                                }
                            }
                        }
                    }
                    group.threads = threads
                }
        }catch{
            return [PrivateGroup]()
        }
        
        let userDefaults = UserDefaults.standard
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: privateGroupList)
        userDefaults.set(encodedData, forKey: "privateGroupsList")
        userDefaults.synchronize()
        return privateGroupList
    }

    
    
    func getAllPrivateGroupsUpdate() -> [PrivateGroup] {
        var privateGroupList: [PrivateGroup] = [PrivateGroup]()
        var oldPrivateGroupsList: [PrivateGroup] = [PrivateGroup]()
        
        if let oldList  = UserDefaults.standard.object(forKey: "privateGroupsList") as? Data{
                        oldPrivateGroupsList = NSKeyedUnarchiver.unarchiveObject(with: oldList) as! [PrivateGroup]
        }
        
        
        do{
                let userID = UserDefaults.standard.string(forKey: GetString.userID.rawValue)
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
                        if let props = row.document!.properties {
                            let privateGroup = PrivateGroup(props: props)
                            //let privateGroup = PrivateGroup(rev: row.documentRevisionID ,pgid: row.documentID, adminID: row.document?["adminID"] as? String, nameOfGroup: row.document?["nameOfGroup"] as? String, location: row.document?["location"] as? String, dayOfMeeting: row.document?["dayOfMeeting"] as? String, timeOfMeeting: nil, timeOfMeetingString: row.document?["timeOfMeeting"] as? String, secretID: row.document?["secretID"] as? String, threadIDs: row.document?["threadIDs"] as? [String], memberIDs: row.document?["memberIDs"] as? [String], dailyActivityIDs: row.document?["dailyActivityIDs"] as? [String], groupRequestIDs: row.document?["groupRequestIDs"] as? [String], createdAt: nil, createdAtString: row.document?["createdAt"] as? String)
                            
                            let result = oldPrivateGroupsList.filter { $0.pgid == privateGroup.pgid }
                            if result.count == 1{
                                privateGroup.threads = result[0].threads
                            }
                            privateGroupList.append(privateGroup)
                        }
                    }
                }
                
                var oldThreads: [Thread]?
                
                for group in privateGroupList {
                   var threads = [Thread]()
                   oldThreads = group.threads
                    
                    if let groupThreadIDsCount = group.threadIDs?.count{
                        if(groupThreadIDsCount > 0){
                            query?.keys = group.threadIDs
                            let threadsList = try query?.run()
                            
                            while let row = threadsList?.nextRow(){
                                if let props = row.document!.properties {
                                    let thread = Thread(props: props)
                                    //let thread = Thread(rev: row.documentRevisionID, tid: row.documentID, originalID: row.document?["authorID"] as? String ,authorID: row.document?["authorID"] as? String, authorUsername: nil, groupID: row.document?["groupID"] as? String, title: row.document?["title"] as? String, message: row.document?["message"] as? String, date: nil, dateString: row.document?["date"] as? String, commentIDs: row.document?["commentIDs"] as? [String])
                                    
                                    if let result = oldThreads{
                                        let threadExists = result.filter({ $0.tid == thread.tid })
                                        if threadExists.count == 1{
                                            if(threadExists[0].rev != thread.rev){
                                                group.hasBeenUpdated = true
                                                thread.hasBeenUpdated = true
                                            }
                                        }else{
                                            thread.hasBeenUpdated = true
                                            group.hasBeenUpdated = true
                                        }
                                    }
                                    threads.append(thread)
                                }
                            }
                            group.threads = threads
                        }
                    }
                }
        }catch{
            return [PrivateGroup]()
        }
        let userDefaults = UserDefaults.standard
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: privateGroupList)
        userDefaults.set(encodedData, forKey: "privateGroupsList")
        userDefaults.synchronize()
        return privateGroupList
    }
    


    func addUserWithProperties(properties: [String: Any]) -> String?{
        do{
        if let con = DBConnection.shared.getDBConnection(){
            let doc = con.createDocument()
            print(doc.documentID)
            try doc.putProperties(properties)
            if User.shared.profileImage != nil{
                    let rev = doc.currentRevision?.createRevision()
                    rev?.setAttachmentNamed("\(User.shared.getUserID())_profileImage.jpeg", withContentType: "image/jpeg", content: User.shared.profileImage)
                    try rev?.save()
                }
            UserDefaults.standard.set(doc.documentID, forKey: GetString.userID.rawValue)
        }else {
            return GetString.errorWithConnection.rawValue
        }
        }catch{
            return GetString.errorWithConnection.rawValue
        }
        return nil
    }
    
    func editUser(user: User) -> String?{
        do{
            if let con = DBConnection.shared.getDBConnection(){
                let doc = con.document(withID: user.getUserID())
                    try doc?.update({ (rev) -> Bool in
                        if(user.name != nil){
                            rev["name"] = user.name!

                        }
                        if(user.prename != nil){
                         rev["prename"] = user.prename!
                        }
                        if(user.birthday != nil){
                            let dateformatter = DateFormatter()
                            dateformatter.dateFormat = "dd MM YYYY"
                            rev["birthday"] = dateformatter.string(from: user.birthday!)
                        }
                        
                        if(user.gender != nil){
                        rev["gender"] = user.gender!
                        }
                        return true
                    })
                
                if(user.profileImage != nil){
                    let rev = doc?.currentRevision?.createRevision()
                    rev?.setAttachmentNamed("\(user.getUserID())_profileImage.jpeg", withContentType: "image/jpeg", content: user.profileImage)
                    try rev?.save()
                }
            }else {
                return GetString.errorWithConnection.rawValue
            }
        }catch{
            return GetString.errorWithConnection.rawValue
        }
        return nil
    }

    
    func createCommentWithProperties(properties: Comment) -> String?{
        do{
            if let con = DBConnection.shared.getDBConnection(){
                    let doc = con.createDocument()
                    try doc.putProperties(properties.getPropertyPackageCreateComment())
                    
                    let threadID = properties.threadID
                    var commentIDs: [String] = [String]()
                    let docU = con.document(withID: threadID!)
                    try docU?.update({ (rev) -> Bool in
                        if let curArray = rev["commentIDs"] as! [String]?{
                            commentIDs = curArray
                            commentIDs.append(doc.documentID)
                            rev["commentIDs"] = commentIDs
                        }
                        return true
                    })
            }else {
                return GetString.errorWithConnection.rawValue
            }
        }catch{
            return GetString.errorWithConnection.rawValue
        }
        return nil
    }

    func createCommentForActivityWithProperties(properties: Comment) -> String?{
        do{
            if let con = DBConnection.shared.getDBConnection(){
                let doc = con.createDocument()
                try doc.putProperties(properties.getPropertyPackageCreateComment())
                let activityID = properties.dailyActivityID
                var commentIDs: [String] = [String]()
                let docU = con.document(withID: activityID!)
                try docU?.update({ (rev) -> Bool in
                    if let curArray = rev["commentIDs"] as! [String]?{
                        commentIDs = curArray
                        commentIDs.append(doc.documentID)
                        rev["commentIDs"] = commentIDs
                    }
                    return true
                })
            }else {
                return GetString.errorWithConnection.rawValue
            }
        }catch{
            return GetString.errorWithConnection.rawValue
        }
        return nil
    }
    
    func likeComment(cID: String) -> String?{
        do{
            if let userID = UserDefaults.standard.string(forKey: GetString.userID.rawValue){
                if let con = DBConnection.shared.getDBConnection(){
                    let query = con.createAllDocumentsQuery()
                    
                    query.allDocsMode = CBLAllDocsMode.allDocs
                    query.keys = [cID]
                    let result = try query.run()
                    var likeIDs: [String] = [String]()
                    
                    while let row = result.nextRow(){
                        likeIDs = row.document?["likeIDs"] as! [String]
                    }
                    
                    if(!likeIDs.contains(userID)){
                        var likes: [String] = [String]()
                        let docU = con.document(withID: cID)
                        try docU?.update({ (rev) -> Bool in
                                if let curArray = rev["likeIDs"] as! [String]?{
                                    likes = curArray
                                    likes.append(userID)
                                    rev["likeIDs"] = likes
                                }
                                return true
                        })
                    }
                }else{
                    return GetString.errorWithConnection.rawValue
                }
            }else{
            return GetString.errorWithConnection.rawValue
            }
        }catch{
            return GetString.errorWithConnection.rawValue
        }
        return nil
    }
    
    func dislikeComment(cID: String) -> String?{
        do{
            if let userID = UserDefaults.standard.string(forKey: GetString.userID.rawValue){
                if let con = DBConnection.shared.getDBConnection(){
                    let query = con.createAllDocumentsQuery()
                    
                    query.allDocsMode = CBLAllDocsMode.allDocs
                    query.keys = [cID]
                    let result = try query.run()
                    var likeIDs: [String] = [String]()
                    
                    while let row = result.nextRow(){
                        likeIDs = row.document?["likeIDs"] as! [String]
                    }
                    
                    if(likeIDs.contains(userID)){
                        var likes: [String] = [String]()
                        let docU = con.document(withID: cID)
                        try docU?.update({ (rev) -> Bool in
                            if let curArray = rev["likeIDs"] as! [String]?{
                                likes = curArray
                                if let index = likes.index(of: userID) {
                                    likes.remove(at: index)
                                }
                                rev["likeIDs"] = likes
                            }
                            return true
                        })
                    }
                }else{
                    return GetString.errorWithConnection.rawValue
                }
            }else{
                return GetString.errorWithConnection.rawValue
            }
        }catch{
            return GetString.errorWithConnection.rawValue
        }
        return nil
    }
    
    
    func likeActivity(aID: String) -> String?{
        do{
            if let userID = UserDefaults.standard.string(forKey: GetString.userID.rawValue){
                if let con = DBConnection.shared.getDBConnection(){
                    let query = con.createAllDocumentsQuery()
                    
                    query.allDocsMode = CBLAllDocsMode.allDocs
                    query.keys = [aID]
                    let result = try query.run()
                    var likeIDs: [String] = [String]()
                    
                    while let row = result.nextRow(){
                        likeIDs = row.document?["likeIDs"] as! [String]
                    }
                    
                    if(!likeIDs.contains(userID)){
                        var likes: [String] = [String]()
                        let docU = con.document(withID: aID)
                        try docU?.update({ (rev) -> Bool in
                            if let curArray = rev["likeIDs"] as! [String]?{
                                likes = curArray
                                likes.append(userID)
                                rev["likeIDs"] = likes
                            }
                            return true
                        })
                    }
                }else{
                    return GetString.errorWithConnection.rawValue
                }
            }else{
                return GetString.errorWithConnection.rawValue
            }
        }catch{
            return GetString.errorWithConnection.rawValue
        }
        return nil
    }
    
    func dislikeActivity(aID: String) -> String?{
        do{
            if let userID = UserDefaults.standard.string(forKey: GetString.userID.rawValue){
                if let con = DBConnection.shared.getDBConnection(){
                    let query = con.createAllDocumentsQuery()
                    
                    query.allDocsMode = CBLAllDocsMode.allDocs
                    query.keys = [aID]
                    let result = try query.run()
                    var likeIDs: [String] = [String]()
                    
                    while let row = result.nextRow(){
                        likeIDs = row.document?["likeIDs"] as! [String]
                    }
                    
                    if(likeIDs.contains(userID)){
                        var likes: [String] = [String]()
                        let docU = con.document(withID: aID)
                        try docU?.update({ (rev) -> Bool in
                            if let curArray = rev["likeIDs"] as! [String]?{
                                likes = curArray
                                if let index = likes.index(of: userID) {
                                    likes.remove(at: index)
                                }
                                rev["likeIDs"] = likes
                            }
                            return true
                        })
                    }
                }else{
                    return GetString.errorWithConnection.rawValue
                }
            }else{
                return GetString.errorWithConnection.rawValue
            }
        }catch{
            return GetString.errorWithConnection.rawValue
        }
        return nil
    }

    
    
    func acceptRequest(uID: String, gID: String) -> String?{
        do{
                if let con = DBConnection.shared.getDBConnection(){
                    var memList = [String]()
                    var reqList = [String]()
                    let doc = con.document(withID: gID)
                    try doc?.update({ (rev) -> Bool in
                        if let memArray = rev["memberIDs"] as! [String]?, let reqArray =  rev["groupRequestIDs"] as! [String]?{
                            memList = memArray
                            reqList = reqArray
                            memList.append(uID)
                            rev["memberIDs"] = memList
                            reqList.remove(at: reqList.index(of: uID)!)
                            rev["groupRequestIDs"] = reqList
                        }
                        return true
                    })
                    
                    let docU = con.document(withID: uID)
                    var groupIDs = [String]()
                    try docU?.update({ (rev) -> Bool in
                        if let groupArray = rev["groupIDs"] as! [String]?{
                            groupIDs = groupArray
                            groupIDs.append(gID)
                            rev["groupIDs"] = groupIDs
                        }
                        return true
                    })
                }else{
                    return GetString.errorWithConnection.rawValue
                }
        }catch{
            return GetString.errorWithConnection.rawValue
        }
        return nil
    }

    func denyRequest(uID: String, gID: String) -> String?{
        do{
            if let con = DBConnection.shared.getDBConnection(){
                var reqList = [String]()
                let doc = con.document(withID: gID)
                try doc?.update({ (rev) -> Bool in
                    if let reqArray =  rev["groupRequestIDs"] as! [String]?{
                        print(reqArray)
                        reqList = reqArray
                         reqList.remove(at: reqList.index(of: uID)!)
                        rev["groupRequestIDs"] = reqList
                    }
                    return true
                })
            }else{
                return GetString.errorWithConnection.rawValue
            }
        }catch{
            return GetString.errorWithConnection.rawValue
        }
        return nil
    }
    
    func leaveGroup(uID: String, gID: String) -> String?{
        do{
            if let con = DBConnection.shared.getDBConnection(){
                var memList = [String]()
                let doc = con.document(withID: gID)
                try doc?.update({ (rev) -> Bool in
                    if let memArray = rev["memberIDs"] as! [String]?{
                        memList = memArray
                        memList.remove(at: memList.index(of: uID)!)
                        rev["memberIDs"] = memList
                    }
                    return true
                })
                
                let docU = con.document(withID: uID)
                var groupIDs = [String]()
                try docU?.update({ (rev) -> Bool in
                    if let groupArray = rev["groupIDs"] as! [String]?{
                        groupIDs = groupArray
                        groupIDs.remove(at: groupIDs.index(of: gID)!)
                        rev["groupIDs"] = groupIDs
                    }
                    return true
                })
            }else{
                return GetString.errorWithConnection.rawValue
            }
        }catch{
            return GetString.errorWithConnection.rawValue
        }
        return nil
    }
    
    
    func getAllCommentsByID(threadID: String) -> [Comment] {
        var comments = [Comment]()
        do{
            if let view = self.viewCommentByThreadID{
                let query = view.createQuery()
                query.keys = [threadID]
                let result = try query.run()
                while let row = result.nextRow() {
                    if let props = row.document!.properties {
                        var userName: String?
                        if let authorUserName = row.document?["authorID"] as? String{
                            let queryForUsername = DBConnection.shared.getDBConnection()?.createAllDocumentsQuery()
                            queryForUsername?.allDocsMode = CBLAllDocsMode.allDocs
                            queryForUsername?.keys = [authorUserName]
                            let result = try queryForUsername?.run()
                            while let row = result?.nextRow() {
                                userName = row.document?["username"] as? String
                            }
                        }
                        let comment = Comment(propsForThread: props)
                        //let comment = Comment(rev: row.documentRevisionID, cid: row.documentID, authorID: row.document?["authorID"] as? String, authorUsername: userName, groupID: row.document?["groupID"] as? String,dailyActivityID: row.document?["dailyActivityID"] as? String,threadID: row.document?["threadID"] as? String, message: row.document?["message"] as? String, date: nil, dateString: row.document?["date"] as? String, likeIDs: row.document?["likeIDs"] as? [String])
                        comments.append(comment)
                    }
                }
            }
        }catch{
            return [Comment]()
        }
        return comments
    }
    
//    func getAllCommentsByID(activityID: String) -> [Comment] {
//        var comments = [Comment]()
//        do{
//            if let view = self.viewCommentByDailyActivityID{
//                let query = view.createQuery()
//                query.keys = [activityID]
//                let result = try query.run()
//                while let row = result.nextRow() {
//                    
//                    var userName: String?
//                    if let authorUserName = row.document?["authorID"] as? String{
//                        let queryForUsername = DBConnection.shared.getDBConnection()?.createAllDocumentsQuery()
//                        queryForUsername?.allDocsMode = CBLAllDocsMode.allDocs
//                        queryForUsername?.keys = [authorUserName]
//                        let result = try queryForUsername?.run()
//                        while let row = result?.nextRow() {
//                            userName = row.document?["username"] as? String
//                        }
//                    }
//                    let comment = Comment(rev: row.documentRevisionID, cid: row.documentID, authorID: row.document?["authorID"] as? String, authorUsername: userName, groupID: row.document?["groupID"] as? String,dailyActivityID: row.document?["dailyActivityID"] as? String,threadID: row.document?["threadID"] as? String, message: row.document?["message"] as? String, date: nil, dateString: row.document?["date"] as? String, likeIDs: row.document?["likeIDs"] as? [String])
//                    comments.append(comment)
//                }
//            }
//        }catch{
//            return [Comment]()
//        }
//        return comments
//    }


    func createThreadWithProperties(properties: [Thread]) -> String?{
        do{

            if let con = DBConnection.shared.getDBConnection(){
            
            var i = 0
            var originalID: String = ""
                
            for thread in properties {
            if(i == 0){
                let doc = con.createDocument()
                try doc.putProperties(thread.getPropertyPackageCreateThreadWithoutOriginalID())
                originalID = doc.documentID
                
                let docU = con.document(withID: originalID)
                try docU?.update({ (rev) -> Bool in
                        rev["originalID"] = originalID
                    return true
                })
                
                let groupID = thread.groupID
                var tIDs: [String] = [String]()
                let docX = con.document(withID: groupID!)
                try docX?.update({ (rev) -> Bool in
                    if let curArray = rev["threadIDs"] as! [String]?{
                        tIDs = curArray
                        tIDs.append(doc.documentID)
                        rev["threadIDs"] = tIDs
                    }
                    return true
                })
                i = 1
            }else{
                let doc = con.createDocument()
                thread.originalID = originalID
                try doc.putProperties(thread.getPropertyPackageCreateThreadWithOriginalID())
                
                let groupID = thread.groupID
                var tIDs: [String] = [String]()
                let docU = con.document(withID: groupID!)
                try docU?.update({ (rev) -> Bool in
                    if let curArray = rev["threadIDs"] as! [String]?{
                        tIDs = curArray
                        tIDs.append(doc.documentID)
                        rev["threadIDs"] = tIDs
                    }
                    return true
                })
                }
            }
            }else {
                return GetString.errorWithConnection.rawValue
            }
        }catch{
            return GetString.errorWithConnection.rawValue
        }
        return nil
    }
    
    
    func createActivityWithProperties(properties: Activity) -> String?{
        do{
            if let con = DBConnection.shared.getDBConnection(){
                    let doc = con.createDocument()
                    try doc.putProperties(properties.getPropertyPackageCreateActivity())
                    var activityArray = [String]()
                    let docU = con.document(withID: UserDefaults.standard.string(forKey: GetString.userID.rawValue)!)
                    try docU?.update({ (rev) -> Bool in
                        if let curArray = rev["dailyFormIDs"] as! [String]?{
                            activityArray = curArray
                            activityArray.append(doc.documentID)
                            rev["dailyFormIDs"] = activityArray
                        }
                        return true
                    })
            }else {
                return GetString.errorWithConnection.rawValue
            }
        }catch{
            return GetString.errorWithConnection.rawValue
        }
        return nil
    }
    
    func shareActivityWithGroups(properties: Activity) -> String?{
    do{
        if let con = DBConnection.shared.getDBConnection(){
    
            var userName: String?
            var groupIDs: [String] = [String]()
            let queryForUsername = DBConnection.shared.getDBConnection()?.createAllDocumentsQuery()
            queryForUsername?.allDocsMode = CBLAllDocsMode.allDocs
            queryForUsername?.keys = [properties.authorID]
            let result = try queryForUsername?.run()
            while let row = result?.nextRow() {
                userName = row.document?["username"] as? String
                groupIDs = (row.document?["groupIDs"] as? [String])!
            }
            print("Share mit folgenden Gruppen: \(groupIDs)")
            if(groupIDs.count > 0){
            let queryForActivity = DBConnection.shared.getDBConnection()?.createAllDocumentsQuery()
            queryForActivity?.allDocsMode = CBLAllDocsMode.allDocs
            queryForActivity?.keys = [properties.aid]
            let result1 = try queryForActivity?.run()
            while let row = result1?.nextRow() {
                if let props = row.document!.properties {
                    for groupID in groupIDs{
                        let activity = Activity(props: props)
                        activity.groupID = groupID
                        //let activity = Activity(rev: row.documentRevisionID, aid: row.documentID, authorID: row.document?["authorID"] as? String, authorUsername: userName, groupID: groupID, activity: row.document?["activity"] as? String, activityText: row.document?["activityText"] as? String, locationOfActivity: row.document?["locationOfActivity"] as? String, isInProcess: row.document?["isInProcess"] as? Bool, status: row.document?["status"] as? Int, wellBeingState: row.document?["wellBeingState"] as? Int, wellBeingText: row.document?["wellBeingText"] as? String, addictionState: row.document?["addictionState"] as? Int, addictionText: row.document?["addictionText"] as? String, dateObject: nil, timeObject: nil,dateString: row.document?["date"] as? String, timeString: row.document?["time"] as! String, commentIDs: row.document?["commentIDs"] as? [String], likeIDs: row.document?["likeIDs"] as? [String])
                        let docUpdate = con.createDocument()
                        try docUpdate.putProperties(activity.getUpdatedPropertyPackageActivity())
                        
                        var activityArray = [String]()
                        let docU = con.document(withID: groupID)
                        try docU?.update({ (rev) -> Bool in
                            if let curArray = rev["dailyActivityIDs"] as! [String]?{
                                activityArray = curArray
                                activityArray.append(docUpdate.documentID)
                                rev["dailyActivityIDs"] = activityArray
                            }
                            return true
                        })
                    }
                }
            }
        }
        }else{
            return GetString.errorWithDB.rawValue
        }
    }catch{
        return GetString.errorWithDB.rawValue
    }
        return nil
    }
    
    
    func getPersonalActivities(userID: String) -> [Activity]{
        var activityList: [Activity] = [Activity]()
        do{
                if let view = DBConnection.shared.viewByActiveActivityForUser{
                    let query = view.createQuery()
                    query.keys = [userID]
                    let result = try query.run()
            
                    while let row = result.nextRow() {
                            if let props = row.document!.properties {
                                let activity = Activity(props: props)
                                activity.rev = row.documentRevisionID
                                activity.aid = row.documentID
                                activityList.append(activity)
                            }
                    }
                    activityList.sort(by:
                        { $0.dateObject?.compare($1.dateObject!) == ComparisonResult.orderedAscending }
                    )
                }else{
                    return [Activity]()
            }
        }catch{
            return [Activity]()
        }
        return activityList
    }

    
    
    func updateActivityAfterForm(properties: Activity) -> String?{
        do{
            if let con = DBConnection.shared.getDBConnection(){
                let doc = con.document(withID: properties.aid!)
                try doc?.update({ (rev) -> Bool in
                    rev["status"] = properties.status!
                    rev["activityText"] = properties.activityText!
                    rev["wellBeingState"] = properties.wellBeingState!
                    rev["wellBeingText"] = properties.wellBeingText!
                    rev["addictionState"] = properties.addictionState!
                    rev["addictionText"] = properties.addictionText!
                    rev["isInProcess"] = properties.isInProcess
                    return true
                })
            }else {
                return GetString.errorWithConnection.rawValue
            }
        }catch{
            return GetString.errorWithConnection.rawValue
        }
        return nil
    }
    
    func editActivity(activity: Activity) -> String?{
        do{
            if let con = DBConnection.shared.getDBConnection(){
                let doc = con.document(withID: activity.aid!)
                try doc?.update({ (rev) -> Bool in
                    rev["time"] = activity.timeString
                    rev["activity"] = activity.activity
                    rev["locationOfActivity"] = activity.locationOfActivity
                    return true
                })
            }else {
                return GetString.errorWithConnection.rawValue
            }
        }catch{
            return GetString.errorWithConnection.rawValue
        }
        return nil
    }



    func updatePrivateGroup(properties: PrivateGroup) -> String?{
        do{
            if let con = DBConnection.shared.getDBConnection(){
                let doc = con.document(withID: properties.pgid!)
                try doc?.update({ (rev) -> Bool in
                    //nameOfGroup location dayOfMeeting timeOfMeeting
                    rev["nameOfGroup"] = properties.nameOfGroup
                    rev["location"] = properties.location
                    rev["dayOfMeeting"] = properties.dayOfMeeting
                    
                    let dateformatter = DateFormatter()
                    dateformatter.dateFormat = "HH:mm"
                    let timeOfMeetingString = dateformatter.string(from: properties.timeOfMeeting!)
                    
                    rev["timeOfMeeting"] = timeOfMeetingString
                    return true
                })
            }else {
                return GetString.errorWithConnection.rawValue
            }
        }catch{
            return GetString.errorWithConnection.rawValue
        }
        return nil
    }

    func updateThread(properties: Thread) -> String?{
        do{
            var threadIDs:[String] = [String]()
            
            if let view = DBConnection.shared.viewThreadByOriginalID{
                let query = view.createQuery()
                query.keys = [properties.originalID]
                let result = try query.run()
                
                while let row = result.nextRow() {
                        threadIDs.append(row.documentID!)
                }
                
                for thread in threadIDs{
                if let con = DBConnection.shared.getDBConnection(){
                    let doc = con.document(withID: thread)
                    try doc?.update({ (rev) -> Bool in
                        rev["title"] = properties.title
                        rev["message"] = properties.message
                        return true
                    })
                }else {
                    return GetString.errorWithConnection.rawValue
                }
                }
            }else{
                return GetString.errorWithConnection.rawValue
            }
//            if let con = DBConnection.shared.getDBConnection(){
//                let doc = con.document(withID: properties.tid!)
//                try doc?.update({ (rev) -> Bool in
//                    rev["title"] = properties.title
//                    rev["message"] = properties.message
//                    return true
//                })
//            }else {
//                return GetString.errorWithConnection.rawValue
//            }
        }catch{
            return GetString.errorWithConnection.rawValue
        }
        return nil
    }

    
    
    func makeRequestToPrivateGroup(secretID: String) -> String?{
        do{
        if let con = DBConnection.shared.getDBConnection(){
            if let userID = UserDefaults.standard.string(forKey: GetString.userID.rawValue){
                if let view = self.viewPrivateGroupBySecretID{
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
                                    reqIDs.append(userID)
                                    rev["groupRequestIDs"] = reqIDs
                                }
                            }
                            return true
                            })
                        }
                        return nil
                    }else{
                    return "Gruppe existiert nicht."
                    }
                }
            }else{
            return "Nicht mehr eingelogged."
            }
        }else{
        return GetString.errorWithConnection.rawValue
        }
        }catch{
            return "Du hast bereits eine Anfrage gesendet oder bist schon Mitglied der Gruppe."
        }
        return nil
    }
    
    
    func createPrivateGroup(properties: [String: Any]) -> String?{
    do{
        if let con = DBConnection.shared.getDBConnection(){
                let doc = con.createDocument()
            
                try doc.putProperties(properties)
                    if let userID = UserDefaults.standard.string(forKey: GetString.userID.rawValue){
                        let docU = con.document(withID: userID)
                        var groupIDs: [String] = [String]()
                        try docU?.update({ (rev) -> Bool in
                            if let curArray = rev["groupIDs"] as! [String]?{
                                groupIDs = curArray
                                groupIDs.append(doc.documentID)
                                rev["groupIDs"] = groupIDs
                            }
                            return true
                        })
                    }
        }else {
            return GetString.errorWithConnection.rawValue
        }
    }catch{
    return GetString.errorWithConnection.rawValue
    }
    return nil
    }
}
