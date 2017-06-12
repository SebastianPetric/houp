//
//  TempStorageAndCompare.swift
//  Houp
//
//  Created by Sebastian on 29.05.17.
//  Copyright © 2017 SP. All rights reserved.
//

import Foundation

class TempStorageAndCompare: NSObject{

    static var shared: TempStorageAndCompare = TempStorageAndCompare()
    let userDefaults = UserDefaults.standard
    var groupCollectionDelegate: PrivateGroupCollectionViewController?
    var groupsWithThreadsControllerDelegate: PrivateGroupWithThreadsController?
    var publicGroupsWithThreadsControllerDelegate: PublicGroupThreadsController?
    var liveQueryUser: CBLLiveQuery?
    var liveQueryGroups: CBLLiveQuery?
    var liveQueryThreadsOfUser: CBLLiveQuery?
    var tempGroupList: [String] = [String]()
    var userID: String?
    
    func initialiseNotificationQueries(userID: String){
        self.userID = userID
        getTopicUser(userID: userID)
        getTopicThreads(authorID: userID)
        }
    
    func deinitialiseNotificationQueries(){
        self.liveQueryThreadsOfUser?.removeObserver(self, forKeyPath: "rows")
        self.liveQueryUser?.removeObserver(self, forKeyPath: "rows")
        self.liveQueryThreadsOfUser = nil
        self.liveQueryUser = nil
        self.tempGroupList = [String]()
        self.userID = nil
        if(self.liveQueryGroups != nil){
        self.liveQueryGroups?.removeObserver(self, forKeyPath: "rows")
        self.liveQueryGroups = nil
        }
    }
    
    func groupsChangedOnDB(groupIDs: [String]){
        if(liveQueryGroups != nil){
            self.liveQueryGroups?.removeObserver(self, forKeyPath: "rows")
        }
        if(groupIDs.count != 0){
        getTopicGroups(groupIDs: groupIDs)
        }else{
        liveQueryGroups = nil
        self.groupCollectionDelegate?.privateGroupsCollection.reloadData()
        }
    }
    
    func getTopicGroups(groupIDs: [String]){
        if let query = DBConnection.shared.getDBConnection()?.createAllDocumentsQuery(){
            query.allDocsMode = CBLAllDocsMode.allDocs
            query.keys = groupIDs
            liveQueryGroups = query.asLive()
            liveQueryGroups?.addObserver(self, forKeyPath: "rows", options: .new, context: nil)
            liveQueryGroups?.start()
        }
    }
    
    func getTopicUser(userID: String){
        if let query = DBConnection.shared.getDBConnection()?.createAllDocumentsQuery(){
            query.allDocsMode = CBLAllDocsMode.allDocs
            query.keys = [userID]
            liveQueryUser = query.asLive()
            liveQueryUser?.addObserver(self, forKeyPath: "rows", options: .new, context: nil)
            liveQueryUser?.start()
        }
    }
    
    func getTopicThreads(authorID: String){
        if let view = DBConnection.shared.viewByThreadByAuthorID{
        let query = view.createQuery()
            query.keys = [authorID]
            liveQueryThreadsOfUser = query.asLive()
            liveQueryThreadsOfUser?.addObserver(self, forKeyPath: "rows", options: .new, context: nil)
            liveQueryThreadsOfUser?.start()
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
         var thread: Thread?
        do{
            if (object as! NSObject == self.liveQueryThreadsOfUser){
                if let rows = liveQueryThreadsOfUser!.rows {
                    while let row = rows.nextRow() {
                        if let props = row.document!.properties {
                            var userName: String?
                            if let authorUserName = props["authorID"] as? String{
                                let queryForUsername = DBConnection.shared.getDBConnection()?.createAllDocumentsQuery()
                                queryForUsername?.allDocsMode = CBLAllDocsMode.allDocs
                                queryForUsername?.keys = [authorUserName]
                                let result = try queryForUsername?.run()
                                while let row = result?.nextRow() {
                                    userName = row.document?["username"] as? String
                                }
                            }
                            thread = Thread(props: props)
                            thread?.userName = userName
                            compareAndSaveThreads(groupID: (thread?.groupID)!, thread: thread!)
                        }
                    }
                    if(thread != nil){
                    sortGroupsWithThreads(groupID: (thread?.groupID)!)
                    }
                    self.groupCollectionDelegate?.privateGroupsCollection.reloadData()
                }
            }else if (object as! NSObject == self.liveQueryGroups){
                var privateGroup: PrivateGroup?
                if let rows = liveQueryGroups?.rows {
                    while let row = rows.nextRow() {
                        if let props = row.document!.properties {
                                    privateGroup = PrivateGroup(props: props)
                                    privateGroup?.pgid = row.documentID
                                    privateGroup?.rev = row.documentRevisionID
                        }
                        compareAndSaveGroups(group: privateGroup!)
                    }
//                    self.groupCollectionDelegate?.privateGroupsCollection.reloadData()
                }
            }else if(object as! NSObject == self.liveQueryUser){
                if let rows = liveQueryUser?.rows {
                    while let row = rows.nextRow() {
                        if let props = row.document!.properties {
                            
                            var groupIDs: [String] = [String]()
                            if let IDs = props["groupIDs"] as! [String]?{
                                groupIDs = IDs
                            }
                            let user = UserObject(props: props)
                            user.uid = row.documentID
                            user.rev = row.documentRevisionID
                            self.tempGroupList = groupIDs
                            compareAndSaveUsers(user: user)
                            //self.groupCollectionDelegate?.privateGroupsCollection.reloadData()
//                            //self.tempGroupList = groupIDs
//                            groupsChangedOnDB(groupIDs: self.tempGroupList)
                        }
                    }
                }
            }
        }catch{
            print("Fehler")
        }
    }

    func compareAndSaveGroups(group: PrivateGroup){
        if (getAllPrivateGroupsSync().count != 0) {
        var oldList: [PrivateGroup] = getAllPrivateGroupsSync()
            for item in oldList{
            }
        if let index = oldList.index(where: { (item) -> Bool in
            item.pgid == group.pgid
        }){
            // check if revision changed, if yes then hasbeenupdated = true
            if((oldList[index].rev != group.rev) || anyThreadOfGroupWasUpdated(group: oldList[index])){
                if(GetString.userID.rawValue == group.adminID){
                    compareOldVsNewArrays(oldGroup: oldList[index], newGroup: group)
                }
                group.hasBeenUpdated = true
                oldList[index] = group
                saveGroupList(groupList: oldList)
            }
        }else{
            group.hasBeenUpdated = true
            oldList.append(group)
            saveGroupList(groupList: oldList)
        }
        }else{
            saveGroupList(groupList: [group])
        }
    }
    
    func anyThreadOfGroupWasUpdated(group: PrivateGroup) -> Bool{
      let temp = getAllThreadsOfGroup(groupID: group.pgid!)
        for thread in temp {
            if(thread.hasBeenUpdated){
                return true
            }
        }
    return false
    }
    
    func anyGroupWasUpdated(group: PrivateGroup) -> Bool{
        let temp = getAllPrivateGroupsSync()
        for group in temp {
            if(group.hasBeenUpdated){
                return true
            }
        }
        return false
    }

    func compareAndSaveThreads(groupID: String, thread: Thread){
        if(getAllGroupsWithThreads().count != 0){
            var oldList = getAllGroupsWithThreads()
            if let groupExists = oldList[groupID]{
                if let index = oldList[groupID]?.index(where: { (item) -> Bool in
                    item.tid == thread.tid
                }){
                    // check if revision changed, if yes then hasbeenupdated = true
                    if(oldList[groupID]?[index].rev != thread.rev){
                        thread.hasBeenUpdated = true
                        oldList[groupID]?[index] = thread
                        saveGroupsWithThreads(groupsWithThreads: oldList)
                    }
                }else{
                    thread.hasBeenUpdated = true
                    oldList[groupID]?.append(thread)
                    saveGroupsWithThreads(groupsWithThreads: oldList)
                }
            }else{
                thread.hasBeenUpdated = true
                oldList[groupID] = [thread]
                saveGroupsWithThreads(groupsWithThreads: oldList)
            }
        }else{
            let newItem = [groupID : [thread]]
            saveGroupsWithThreads(groupsWithThreads: newItem)
        }
    }
    
    func saveGroupsWithThreads(groupsWithThreads: [String : [Thread]]){
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: groupsWithThreads)
        self.userDefaults.set(encodedData, forKey: "groupsWithThreadsSync\(self.userID!)")
        self.userDefaults.synchronize()
    }
    
    func getAllGroupsWithThreads() -> [String : [Thread]]{
        var oldGroupsThreadsList: [String : [Thread]] = [String : [Thread]]()
        if let oldList  = self.userDefaults.object(forKey: "groupsWithThreadsSync\(self.userID!)") as? Data{
            oldGroupsThreadsList = NSKeyedUnarchiver.unarchiveObject(with: oldList) as! [String : [Thread]]
        }
        return oldGroupsThreadsList
    }
    
    func getAllThreadsOfGroup(groupID: String) -> [Thread]{
        var oldGroupsThreadsList: [String : [Thread]] = [String : [Thread]]()
        if let oldList  = self.userDefaults.object(forKey: "groupsWithThreadsSync\(self.userID!)") as? Data{
            oldGroupsThreadsList = NSKeyedUnarchiver.unarchiveObject(with: oldList) as! [String : [Thread]]
            if let temp = oldGroupsThreadsList[groupID]{
                return temp
            }else{
            return [Thread]()
            }
        }
        return [Thread]()
    }
    
    func compareOldVsNewArrays(oldGroup: PrivateGroup, newGroup: PrivateGroup){
    let tempOld = oldGroup.groupRequestIDs!.sorted()
    let tempNew = newGroup.groupRequestIDs!.sorted()
        
        if(tempOld.count < tempNew.count){
            print("Neue Anfrage! Jemand will der Gruppe \(oldGroup.nameOfGroup!) beitreten!")
            //schicke notification
    
        }else if(tempOld.count > tempNew.count){
            for item in tempNew{
                if(!tempOld.contains(item)){
                    print("Neue Anfrage! Jemand will der Gruppe \(oldGroup.nameOfGroup!) beitreten!")
                    //schicke notification
                }
            }
        }else if(tempOld.count == tempNew.count){
            if(tempOld != tempNew){
            print("Neue Anfrage! Jemand will der Gruppe \(oldGroup.nameOfGroup!) beitreten!")
            //schicke notification
            }
        }
    }
    
    func deleteGroup(groupID: String){
        var tempGroupsWithThreads: [String: [Thread]] = [String: [Thread]]()
        var tempGroupsList: [PrivateGroup] = [PrivateGroup]()
        
        var newTempGroupsWithThreads: [String: [Thread]] = [String: [Thread]]()
        var newTempGroupsList: [PrivateGroup] = [PrivateGroup]()
        
        if let oldListOfGroupsWithThreads  = self.userDefaults.object(forKey: "groupsWithThreadsSync\(self.userID!)") as? Data{
            tempGroupsWithThreads = NSKeyedUnarchiver.unarchiveObject(with: oldListOfGroupsWithThreads) as! [String : [Thread]]
            
            tempGroupsWithThreads.removeValue(forKey: groupID)
            newTempGroupsWithThreads = tempGroupsWithThreads
            
            let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: newTempGroupsWithThreads)
            self.userDefaults.set(encodedData, forKey: "groupsWithThreadsSync\(self.userID!)")
            self.userDefaults.synchronize()
        }
        
        if let oldListOfGroups  = self.userDefaults.object(forKey: "privateGroupsSync\(self.userID!)") as? Data{
            tempGroupsList = NSKeyedUnarchiver.unarchiveObject(with: oldListOfGroups) as! [PrivateGroup]
            
            for (index, group) in tempGroupsList.enumerated() {
                if(group.pgid == groupID){
                    print("Welches Item: INdex: \(index) und \(tempGroupsList[index].nameOfGroup)")
                    tempGroupsList.remove(at: index)
                    let encodedDataGroups: Data = NSKeyedArchiver.archivedData(withRootObject: tempGroupsList)
                    self.userDefaults.set(encodedDataGroups, forKey: "privateGroupsSync\(self.userID!)")
                    self.userDefaults.synchronize()
                }
            }
        }
    self.groupCollectionDelegate?.privateGroupsCollection.reloadData()
    }
    
    func checkTopicGroupsOfUser(oldGroups: UserObject, newGroups: UserObject, tempList: [UserObject], index: Int){
        var tempUserList: [UserObject] = [UserObject]()
        
        for groupID in oldGroups.groupIDs! {
            if(!(newGroups.groupIDs?.contains(groupID))!) {
                deleteGroup(groupID: groupID)
            }
        }
        
        for groupID in newGroups.groupIDs! {
            if(!(oldGroups.groupIDs?.contains(groupID))!) {
                self.tempGroupList = newGroups.groupIDs!
            }
        }
        
        tempUserList = tempList
        tempUserList[index] = newGroups
        saveUser(users: tempUserList)
        
        groupsChangedOnDB(groupIDs: self.tempGroupList)
    }
    
    
    func compareAndSaveUsers(user: UserObject){
        if (getUserData().count != 0) {
            var oldList: [UserObject] = getUserData()
            if let index = oldList.index(where: { (item) -> Bool in
                item.uid == user.uid
            }){
                // check if revision changed, if yes then hasbeenupdated = true
                    checkTopicGroupsOfUser(oldGroups: oldList[index], newGroups: user, tempList: oldList, index: index)

//                if(oldList[index].rev != user.rev){
//                    print("rev hat sich geändert")
//                    checkTopicGroupsOfUser(oldGroups: oldList[index], newGroups: user, tempList: oldList, index: index)
//                }else{
//                    print("rev hat sich nicht geändert")
//                    print(user.groupIDs)
//                    groupsChangedOnDB(groupIDs: user.groupIDs!)
//                }
            }else{
                oldList.append(user)
                saveUser(users: oldList)
                self.tempGroupList = user.groupIDs!
                groupsChangedOnDB(groupIDs: user.groupIDs!)
            }
        }else{
            saveUser(users: [user])
            self.tempGroupList = user.groupIDs!
            groupsChangedOnDB(groupIDs: user.groupIDs!)
        }
    }
    
    func getUserData() -> [UserObject]{
        var oldUserList: [UserObject] = [UserObject]()
        if let oldList  = self.userDefaults.object(forKey: "userObjectsSync\(self.userID!)") as? Data{
            oldUserList = NSKeyedUnarchiver.unarchiveObject(with: oldList) as! [UserObject]
        }
        return oldUserList
    }
    
    func saveUser(users: [UserObject]){
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: users)
        self.userDefaults.set(encodedData, forKey: "userObjectsSync\(self.userID!)")
        self.userDefaults.synchronize()
    }
    
    func saveAllThreadsOfGroup(groupID: String, threads: [Thread]){
        var oldGroupsThreadsList: [String : [Thread]] = [String : [Thread]]()
        if let oldList  = self.userDefaults.object(forKey: "groupsWithThreadsSync\(self.userID!)") as? Data{
            oldGroupsThreadsList = NSKeyedUnarchiver.unarchiveObject(with: oldList) as! [String : [Thread]]
            oldGroupsThreadsList[groupID]! = threads
            oldGroupsThreadsList[groupID]?.sort(by:
                { $0.dateObject?.compare($1.dateObject!) == ComparisonResult.orderedDescending }
            )
            let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: oldGroupsThreadsList)
            self.userDefaults.set(encodedData, forKey: "groupsWithThreadsSync\(self.userID!)")
            self.userDefaults.synchronize()
        }
        self.groupsWithThreadsControllerDelegate?.threadsCollectionView.reloadData()
        self.publicGroupsWithThreadsControllerDelegate?.threadsCollectionView.reloadData()
    }

    func sortGroupsWithThreads(groupID: String){
        var oldGroupsThreadsList: [String : [Thread]] = [String : [Thread]]()
        if let oldList  = self.userDefaults.object(forKey: "groupsWithThreadsSync\(self.userID!)") as? Data{
            oldGroupsThreadsList = NSKeyedUnarchiver.unarchiveObject(with: oldList) as! [String : [Thread]]
            oldGroupsThreadsList[groupID]?.sort(by:
                { $0.dateObject?.compare($1.dateObject!) == ComparisonResult.orderedDescending }
            )
        }
        saveGroupsWithThreads(groupsWithThreads: oldGroupsThreadsList)
    }
    
    func sortGroups(){
        var oldPrivateGroupsList: [PrivateGroup] = [PrivateGroup]()
        if let oldList  = self.userDefaults.object(forKey: "privateGroupsSync\(self.userID!)") as? Data{
            oldPrivateGroupsList = NSKeyedUnarchiver.unarchiveObject(with: oldList) as! [PrivateGroup]
        }
        oldPrivateGroupsList.sort(by:
            { $0.createdAt?.compare($1.createdAt!) == ComparisonResult.orderedDescending }
        )
        saveGroupList(groupList: oldPrivateGroupsList)
    }
    
    func saveGroupList(groupList: [PrivateGroup]){
        var tempGroup = groupList
        tempGroup.sort(by:
            { $0.createdAt?.compare($1.createdAt!) == ComparisonResult.orderedDescending }
        )

        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: tempGroup)
        self.userDefaults.set(encodedData, forKey: "privateGroupsSync\(self.userID!)")
        self.userDefaults.synchronize()
        
        if(self.groupsWithThreadsControllerDelegate != nil){
            for group in getAllPrivateGroupsSync(){
                if(group.pgid == self.groupsWithThreadsControllerDelegate?.privateGroup?.pgid){
                    self.groupsWithThreadsControllerDelegate?.privateGroup = group
                }
            }
            self.groupsWithThreadsControllerDelegate?.threadsCollectionView.reloadData()
            self.publicGroupsWithThreadsControllerDelegate?.threadsCollectionView.reloadData()
        }
    }
    
    func saveSingleGroup(group: PrivateGroup, hasBeenUpdated: Bool){
        var oldPrivateGroupsList: [PrivateGroup] = [PrivateGroup]()
        if let oldList  = self.userDefaults.object(forKey: "privateGroupsSync\(self.userID!)") as? Data{
            oldPrivateGroupsList = NSKeyedUnarchiver.unarchiveObject(with: oldList) as! [PrivateGroup]
        }
        if let index = oldPrivateGroupsList.index(where: { (item) -> Bool in
            item.pgid == group.pgid
        }){
            let tempGroup = group
            group.hasBeenUpdated = hasBeenUpdated
            oldPrivateGroupsList[index] = tempGroup
            let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: oldPrivateGroupsList)
            self.userDefaults.set(encodedData, forKey: "privateGroupsSync\(self.userID!)")
            self.userDefaults.synchronize()
        }
    }
    

    func getAllPrivateGroupsSync() -> [PrivateGroup] {
    var oldPrivateGroupsList: [PrivateGroup] = [PrivateGroup]()
    if let oldList  = self.userDefaults.object(forKey: "privateGroupsSync\(self.userID!)") as? Data{
        oldPrivateGroupsList = NSKeyedUnarchiver.unarchiveObject(with: oldList) as! [PrivateGroup]
    }
    return oldPrivateGroupsList
    }

    func setHasBeenUpdatedStatusOfThread(groupID: String, threadID: String, hasBeenUpdated: Bool){
        if let index = getAllThreadsOfGroup(groupID: groupID).index(where: { (item) -> Bool in
            item.tid == threadID
        }){
            let temp = getAllGroupsWithThreads()
            temp[groupID]?[index].hasBeenUpdated = hasBeenUpdated
            saveGroupsWithThreads(groupsWithThreads: temp)
        }
    }
    
    func setHasBeenUpdatedStatusOfGroup(groupID: String, hasBeenUpdated: Bool){
        if let index = getAllPrivateGroupsSync().index(where: { (item) -> Bool in
            item.pgid == groupID
        }){
            getAllPrivateGroupsSync()[index].hasBeenUpdated = hasBeenUpdated
        }
    }
    
    func deleteEverything(userIDs: [String]){
        for item in userIDs {
            self.userDefaults.removeObject(forKey:"groupsWithThreadsSync\(item)")
            self.userDefaults.removeObject(forKey:"privateGroupsSync\(item)")
            self.userDefaults.removeObject(forKey: "userObjectsSync\(item)")
        }
    }
    func deleteEverythingWithoutUserID(){
        self.userDefaults.removeObject(forKey:"groupsWithThreadsSync")
        self.userDefaults.removeObject(forKey:"privateGroupsSync")
    }
}
