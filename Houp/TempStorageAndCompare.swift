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
    var timerObject: TimerObject?
    var privateGroupCollectionDelegate: PrivateGroupCollectionViewController?
    var privateGroupsWithThreadsDelegate: PrivateGroupWithThreadsController?
    var publicGroupsWithThreadsControllerDelegate: PublicGroupThreadsController?
    var publicGroupThreadWithCommentsDelegate: PublicGroupThreadWithComments?
    var activityWithCommentsDelegate: ActivitiesCommentsController?
    var activityWeekCollectionDelegate: ActivityWeekCollection?
    var activityCommentsDelegate: ActivitiesCommentsController?
    var activitiesInPrivateGroupDelegate: ShowActivitiesInPrivateGroupController?
    var liveQueryUser: CBLLiveQuery?
    var liveQueryGroups: CBLLiveQuery?
    var liveQueryThreadsOfUser: CBLLiveQuery?
    var liveQueryPublicThreads: CBLLiveQuery?
    var liveQueryPrivateThreads: CBLLiveQuery?
    var liveQueryActiveActivities: CBLLiveQuery?
    var liveQueryInactiveActivities: CBLLiveQuery?
    
    var tempGroupList: [String] = [String]()
    var tempActivityIDList: [String] = [String]()
    var userID: String?
    
    func initialiseNotificationQueries(userID: String){
        self.userID = userID
        getTopicUser(userID: userID)
        getTopicThreads(authorID: userID)
        getTopicThreadsOfPublicGroup()
        //getTopicActiveActivitiesOfUser()
        }
    
    func deinitialiseNotificationQueries(){
        self.liveQueryThreadsOfUser?.removeObserver(self, forKeyPath: "rows")
        self.liveQueryUser?.removeObserver(self, forKeyPath: "rows")
        self.liveQueryPublicThreads?.removeObserver(self, forKeyPath: "rows")
//        self.liveQueryActiveActivities?.removeObserver(self, forKeyPath: "rows")
//        self.liveQueryActiveActivities = nil
        if(self.liveQueryPrivateThreads != nil){
            self.liveQueryPrivateThreads?.removeObserver(self, forKeyPath: "rows")
            self.liveQueryPrivateThreads = nil
        }
        if(self.liveQueryInactiveActivities != nil){
            self.liveQueryInactiveActivities?.removeObserver(self, forKeyPath: "rows")
            self.liveQueryInactiveActivities = nil
        }
        self.liveQueryPublicThreads = nil
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
        self.privateGroupCollectionDelegate?.privateGroupsCollection.reloadData()
        }
        
        if(liveQueryPrivateThreads != nil){
            self.liveQueryPrivateThreads?.removeObserver(self, forKeyPath: "rows")
        }
        if(groupIDs.count != 0){
            getPrivateGroupsTopicThreads(groupIDs: groupIDs)
        }else{
            liveQueryPrivateThreads = nil
            self.privateGroupCollectionDelegate?.privateGroupsCollection.reloadData()
            self.privateGroupsWithThreadsDelegate?.threadsCollectionView.reloadData()
        }
        if(liveQueryInactiveActivities != nil){
            self.liveQueryInactiveActivities?.removeObserver(self, forKeyPath: "rows")
        }
        if(groupIDs.count != 0){
            getTopicInactiveActivitiesOfGroups(groupIDs: groupIDs)
        }else{
            liveQueryInactiveActivities = nil
            self.activitiesInPrivateGroupDelegate?.activityCollectionView.reloadData()
//            self.privateGroupCollectionDelegate?.privateGroupsCollection.reloadData()
//            self.privateGroupsWithThreadsDelegate?.threadsCollectionView.reloadData()
        }
    }
    
    func getTopicActiveActivitiesOfUser(){
        if let view = DBConnection.shared.viewByActiveActivityForUser{
            let query = view.createQuery()
            query.keys = [getUserID()]
            liveQueryActiveActivities = query.asLive()
            liveQueryActiveActivities?.addObserver(self, forKeyPath: "rows", options: .new, context: nil)
            liveQueryActiveActivities?.start()
        }
    }
    
    func getTopicInactiveActivitiesOfGroups(groupIDs: [String]){
        if let view = DBConnection.shared.viewByInactiveActivityForGroup{
            let query = view.createQuery()
            query.keys = groupIDs
            liveQueryInactiveActivities = query.asLive()
            liveQueryInactiveActivities?.addObserver(self, forKeyPath: "rows", options: .new, context: nil)
            liveQueryInactiveActivities?.start()
        }
    }
    
    func getUserID() -> String{
    return self.userDefaults.string(forKey: GetString.userID.rawValue)!
    }
    
    func getPrivateGroupsTopicThreads(groupIDs: [String]){
        if let view = DBConnection.shared.viewThreadByGroupID{
            let query = view.createQuery()
            query.keys = groupIDs
            liveQueryPrivateThreads = query.asLive()
            liveQueryPrivateThreads?.addObserver(self, forKeyPath: "rows", options: .new, context: nil)
            liveQueryPrivateThreads?.start()
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
    
    func getTopicThreadsOfPublicGroup(){
        if let view = DBConnection.shared.viewThreadByGroupID{
            let query = view.createQuery()
            query.keys = ["0"]
            liveQueryPublicThreads = query.asLive()
            liveQueryPublicThreads?.addObserver(self, forKeyPath: "rows", options: .new, context: nil)
            liveQueryPublicThreads?.start()
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
        if let view = DBConnection.shared.viewThreadByAuthorID{
        let query = view.createQuery()
            query.keys = [authorID]
            liveQueryThreadsOfUser = query.asLive()
            liveQueryThreadsOfUser?.addObserver(self, forKeyPath: "rows", options: .new, context: nil)
            liveQueryThreadsOfUser?.start()
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
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
                            let thread = Thread(props: props)
                            thread.userName = userName
                            compareAndSaveThreads(groupID: thread.groupID!, thread: thread)
                        }
                    }
//                    if(thread != nil){
//                    sortGroupsWithThreads(groupID: (thread?.groupID)!)
//                    }
                    self.privateGroupCollectionDelegate?.privateGroupsCollection.reloadData()
                    self.privateGroupsWithThreadsDelegate?.threadsCollectionView.reloadData()
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
                    self.privateGroupCollectionDelegate?.privateGroupsCollection.reloadData()
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
                            self.tempGroupList = groupIDs
                            compareAndSaveUsers(user: user)
                            //self.groupCollectionDelegate?.privateGroupsCollection.reloadData()
//                            //self.tempGroupList = groupIDs
//                            groupsChangedOnDB(groupIDs: self.tempGroupList)
                        }
                    }
                }
            }else if(object as! NSObject == self.liveQueryPublicThreads){
                if let rows = liveQueryPublicThreads?.rows {
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
                            let thread = Thread(props: props)
                            thread.userName = userName
                            compareAndSaveThreads(groupID: "0", thread: thread)
                            //compareAndSavePublicThreads(thread: thread)
                        }
                    }
                    self.publicGroupsWithThreadsControllerDelegate?.threadsCollectionView.reloadData()
                }
            }else if(object as! NSObject == self.liveQueryPrivateThreads){
                if let rows = liveQueryPrivateThreads?.rows {
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
                            let thread = Thread(props: props)
                            thread.userName = userName
                            compareAndSaveThreads(groupID: thread.groupID!, thread: thread)
                            //compareAndSavePublicThreads(thread: thread)
                        }
                    }
                    self.privateGroupsWithThreadsDelegate?.threadsCollectionView.reloadData()
                    self.privateGroupCollectionDelegate?.privateGroupsCollection.reloadData()
                }
            }else if (object as! NSObject == self.liveQueryActiveActivities){
                print("liveQueryActiveActivities")
                if let rows = liveQueryActiveActivities?.rows {
                    while let row = rows.nextRow() {
                        if let props = row.document!.properties {
                           let activity = Activity(props: props)
                            compareAndSaveActivities(activity: activity)
                        }
                    }
                    self.activityWeekCollectionDelegate?.activityCollectionView.reloadData()
                }
            }
            else if (object as! NSObject == self.liveQueryInactiveActivities){
                if let rows = liveQueryInactiveActivities?.rows {
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

                            let activity = Activity(props: props)
                            activity.userName = userName
                            compareAndSaveActivities(activity: activity)
                        }
                    }
                    self.activitiesInPrivateGroupDelegate?.activityCollectionView.reloadData()
                }
            }
        }catch{
            print("Fehler")
        }
    }

    func compareAndSaveGroups(group: PrivateGroup){
        if (getAllPrivateGroupsSync().count != 0) {
        var oldList: [PrivateGroup] = getAllPrivateGroupsSync()
        if let index = oldList.index(where: { (item) -> Bool in
            item.pgid == group.pgid
        }){
            // check if revision changed, if yes then hasbeenupdated = true
            if((oldList[index].rev != group.rev) || anyThreadOfGroupWasUpdated(group: oldList[index])){
                if(self.userID == group.adminID){
                    checkIfRequestHasBeenMade(oldGroup: oldList[index], newGroup: group)
                }
                group.hasBeenUpdated = true
                oldList[index] = group
                let temp = sortGroups(groups: oldList)
                saveGroupList(groupList: sortGroups(groups: oldList))
            }
        }else{
            group.hasBeenUpdated = true
            oldList.append(group)
            saveGroupList(groupList: sortGroups(groups: oldList))
        }
        }else{
            saveGroupList(groupList: [group])
        }
    }
    
    func compareAndSaveActivities(activity: Activity){
        if (getAllActivities().count != 0) {
            var oldList: [Activity] = getAllActivities()
            if let index = oldList.index(where: { (item) -> Bool in
                item.aid == activity.aid
            }){
                // check if revision changed, if yes then hasbeenupdated = true
                if(oldList[index].rev != activity.rev){
                    print("rev hat sich geändert")
                    activity.hasBeenUpdated = true
                    oldList[index] = activity
                    self.activityWithCommentsDelegate?.activityObject = activity
                    saveActivityList(activityList: oldList)
                }
            }else{
                activity.hasBeenUpdated = true
                oldList.append(activity)
                saveActivityList(activityList: oldList)
            }
        }else{
            saveActivityList(activityList: [activity])
        }
    }
    
    func saveActivityList(activityList: [Activity]){
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: sortActivities(activities: activityList))
        self.userDefaults.set(encodedData, forKey: "activitiesOfUser\(self.userID!)")
        self.userDefaults.synchronize()
    }

    
    func getAllActivities() -> [Activity]{
        var oldActivitiesList: [Activity] = [Activity]()
        if let oldList  = self.userDefaults.object(forKey: "activitiesOfUser\(self.userID!)") as? Data{
            oldActivitiesList = NSKeyedUnarchiver.unarchiveObject(with: oldList) as! [Activity]
        }
        return oldActivitiesList
    }
    
    func getActiveActivitiesOfUser() -> [Activity]{
        var oldActivitiesList: [Activity] = [Activity]()
        var newList: [Activity] = [Activity]()
        if let oldList  = self.userDefaults.object(forKey: "activitiesOfUser\(self.userID!)") as? Data{
            oldActivitiesList = NSKeyedUnarchiver.unarchiveObject(with: oldList) as! [Activity]
            for activity in oldActivitiesList{
                if(activity.isInProcess){
                    newList.append(activity)
                }
            }
            newList = sortActivities(activities: newList)
        }
        return newList
    }
    
    func getActivitiesOfGroup(groupID: String) -> [Activity]{
        var oldActivitiesList: [Activity] = [Activity]()
        var newList: [Activity] = [Activity]()
        if let oldList  = self.userDefaults.object(forKey: "activitiesOfUser\(self.userID!)") as? Data{
            oldActivitiesList = NSKeyedUnarchiver.unarchiveObject(with: oldList) as! [Activity]
            for activity in oldActivitiesList{
                if(!activity.isInProcess){
                    if let activityGroupID = activity.groupID{
                        if(activityGroupID == groupID){
                         newList.append(activity)
                        }
                    }
                }
            }
            newList = sortActivities(activities: newList)
        }
        return newList
    }

    
//    func compareAndSavePublicThreads(thread: Thread){
//        if (getAllPublicGroupThreads().count != 0) {
//            var oldList: [Thread] = getAllPublicGroupThreads()
//            if let index = oldList.index(where: { (item) -> Bool in
//                item.tid == thread.tid
//            }){
//                // check if revision changed, if yes then hasbeenupdated = true
//                if(oldList[index].rev != thread.rev){
//                    thread.hasBeenUpdated = true
//                    oldList[index] = thread
//                    savePublicThreads(threadsList: oldList)
//                    publicGroupThreadWithCommentsDelegate?.thread = thread
//                }
//            }else{
//                thread.hasBeenUpdated = true
//                oldList.append(thread)
//                savePublicThreads(threadsList: oldList)
//            }
//        }else{
//            savePublicThreads(threadsList: [thread])
//        }
//    }

    func savePublicThreads(threadsList: [Thread]){
        var tempThreads = threadsList
        tempThreads.sort(by:
            { $0.dateObject?.compare($1.dateObject!) == ComparisonResult.orderedDescending }
        )
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: tempThreads)
        self.userDefaults.set(encodedData, forKey: "publicGroupThreads\(self.userID!)")
        self.userDefaults.synchronize()
        self.publicGroupsWithThreadsControllerDelegate?.threadsCollectionView.reloadData()
    }
    
    
    
    func getAllPublicGroupThreads() -> [Thread]{
        var oldPublicThreadsList: [Thread] = [Thread]()
        if let oldList  = self.userDefaults.object(forKey: "publicGroupThreads\(self.userID!)") as? Data{
            oldPublicThreadsList = NSKeyedUnarchiver.unarchiveObject(with: oldList) as! [Thread]
        }
        return oldPublicThreadsList
    }
    
    func saveAllThreadsOfPublicGroup(thread: Thread, index: Int){
        var oldGroupsThreadsList: [Thread] = [Thread]()
        var oldList = getAllPublicGroupThreads()
        
        if(oldList.count != 0){
            oldGroupsThreadsList = oldList
            oldGroupsThreadsList[index] = thread
            oldGroupsThreadsList.sort(by:
                { $0.dateObject?.compare($1.dateObject!) == ComparisonResult.orderedDescending }
            )
        }
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: oldGroupsThreadsList)
        self.userDefaults.set(encodedData, forKey: "publicGroupThreads\(self.userID!)")
        self.userDefaults.synchronize()
        self.publicGroupsWithThreadsControllerDelegate?.threadsCollectionView.reloadData()
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
        if(thread.groupID != "0"){
        if(getAllGroupsWithThreads().count != 0){
            var oldList = getAllGroupsWithThreads()
            if let groupExists = oldList[groupID]{
                if let index = oldList[groupID]?.index(where: { (item) -> Bool in
                    item.tid == thread.tid
                }){
                    // check if revision changed, if yes then hasbeenupdated = true
                    if(oldList[groupID]?[index].rev != thread.rev){
                        if(isUserAdmin(id: thread.authorID!)){
                            print("Eine neue reaktion auf deinen Thread \(thread.title)")
                        }
                        thread.hasBeenUpdated = true
                        oldList[groupID]?[index] = thread
                        oldList[groupID] = sortThreads(threads: oldList[groupID]!)
                        saveGroupsWithThreads(groupsWithThreads: oldList)
                    }
                }else{
                    thread.hasBeenUpdated = true
                    oldList[groupID]?.append(thread)
                    oldList[groupID] = sortThreads(threads: oldList[groupID]!)
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
        }else{
            if (getAllPublicGroupThreads().count != 0) {
                var oldList: [Thread] = getAllPublicGroupThreads()
                if let index = oldList.index(where: { (item) -> Bool in
                    item.tid == thread.tid
                }){
                    // check if revision changed, if yes then hasbeenupdated = true
                    if(oldList[index].rev != thread.rev){
                        if(isUserAdmin(id: thread.authorID!)){
                        print("Eine neue reaktion auf deinen Thread \(thread.title)")
                        }
                        thread.hasBeenUpdated = true
                        oldList[index] = thread
                        savePublicThreads(threadsList: sortThreads(threads: oldList))
                        publicGroupThreadWithCommentsDelegate?.thread = thread
                    }
                }else{
                    thread.hasBeenUpdated = true
                    oldList.append(thread)
                    savePublicThreads(threadsList: sortThreads(threads: oldList))
                }
            }else{
                savePublicThreads(threadsList: [thread])
            }
        }
    }
    
    func isUserAdmin(id: String) -> Bool{
        return self.userDefaults.string(forKey: GetString.userID.rawValue) == id
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
    
    func checkIfRequestHasBeenMade(oldGroup: PrivateGroup, newGroup: PrivateGroup){
    let tempOld = oldGroup.groupRequestIDs!.sorted()
    let tempNew = newGroup.groupRequestIDs!.sorted()
        
        for user in tempNew {
            if(!(tempOld.contains(user))) {
                //Hier Notification triggern
            }
        }
    }
    
    func deleteGroup(groupID: String){
        var tempGroupsWithThreads: [String: [Thread]] = [String: [Thread]]()
        var tempGroupsList: [PrivateGroup] = [PrivateGroup]()
        var newTempGroupsWithThreads: [String: [Thread]] = [String: [Thread]]()
        
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
                    tempGroupsList.remove(at: index)
                    let encodedDataGroups: Data = NSKeyedArchiver.archivedData(withRootObject: tempGroupsList)
                    self.userDefaults.set(encodedDataGroups, forKey: "privateGroupsSync\(self.userID!)")
                    self.userDefaults.synchronize()
                }
            }
        }
    self.privateGroupCollectionDelegate?.privateGroupsCollection.reloadData()
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
        
//        for activityID in newGroups.dailyFormIDs! {
//            if(!(oldGroups.dailyFormIDs?.contains(activityID))!) {
//                self.tempActivityIDList = newGroups.dailyFormIDs!
//            }
//        }
        
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
                    //checkTopicGroupsOfUser(oldGroups: oldList[index], newGroups: user, tempList: oldList, index: index)

                if(oldList[index].rev != user.rev){
                    checkTopicGroupsOfUser(oldGroups: oldList[index], newGroups: user, tempList: oldList, index: index)
                }else{
                    groupsChangedOnDB(groupIDs: user.groupIDs!)
                }
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
        self.privateGroupsWithThreadsDelegate?.threadsCollectionView.reloadData()
        //self.publicGroupsWithThreadsControllerDelegate?.threadsCollectionView.reloadData()
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
    
    func sortActivities(activities: [Activity]) -> [Activity]{
        var oldActivitiesList: [Activity] = activities
        if(oldActivitiesList.count > 1){
            oldActivitiesList.sort(by:
                { $0.dateObject?.compare($1.dateObject!) == ComparisonResult.orderedDescending }
            )
        }
        return oldActivitiesList
    }
    
    func sortActivitiesForWeek(activities: [Activity]) -> [Activity]{
        var oldActivitiesList: [Activity] = activities
        if(oldActivitiesList.count > 1){
            oldActivitiesList.sort(by:
                { $0.dateObject?.compare($1.dateObject!) == ComparisonResult.orderedAscending }
            )
        }
        return oldActivitiesList
    }

    func sortGroups(groups: [PrivateGroup]) -> [PrivateGroup]{
        var oldGroupsList: [PrivateGroup] = groups
        oldGroupsList.sort(by:
            { $0.createdAt?.compare($1.createdAt!) == ComparisonResult.orderedDescending }
        )
        return oldGroupsList
    }
    
    func sortThreads(threads: [Thread]) -> [Thread]{
        var oldThreadList: [Thread] = threads
        oldThreadList.sort(by:
            { $0.dateObject?.compare($1.dateObject!) == ComparisonResult.orderedDescending }
        )
        return oldThreadList
    }
    
    func saveGroupList(groupList: [PrivateGroup]){
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: groupList)
        self.userDefaults.set(encodedData, forKey: "privateGroupsSync\(self.userID!)")
        self.userDefaults.synchronize()
        
        if(self.privateGroupsWithThreadsDelegate != nil){
            for group in getAllPrivateGroupsSync(){
                if(group.pgid == self.privateGroupsWithThreadsDelegate?.privateGroup?.pgid){
                    self.privateGroupsWithThreadsDelegate?.privateGroup = group
                }
            }
            self.privateGroupsWithThreadsDelegate?.threadsCollectionView.reloadData()
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
            self.userDefaults.removeObject(forKey: "publicGroupThreads\(item)")
            self.userDefaults.removeObject(forKey: "activitiesOfUser\(item)")
        }
    }
    func deleteEverythingWithoutUserID(){
        self.userDefaults.removeObject(forKey:"groupsWithThreadsSync")
        self.userDefaults.removeObject(forKey:"privateGroupsSync")
    }
}
