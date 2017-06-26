//
//  CompareAndSaveThreads.swift
//  Houp
//
//  Created by Sebastian on 26.06.17.
//  Copyright © 2017 SP. All rights reserved.
//

import UIKit

extension TempStorageAndCompare{

    //---------------------------------------------------------------------------------------
    // Hier werden Public Threads verglichen, und gespeichert falls sich was geändert hat etc
    //---------------------------------------------------------------------------------------
    
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
                                checkIfNewAnswerHasBeenMade(oldThread: (oldList[groupID]?[index])!, newThread: thread)
                            }
                            thread.hasBeenUpdated = true
                            oldList[groupID]?[index] = thread
                            oldList[groupID] = sortThreads(threads: oldList[groupID]!)
                            saveGroupsWithThreads(groupsWithThreads: oldList)
                            saveSingleGroup(groupID: thread.groupID!, hasBeenUpdated: true)
                            self.privateGroupCollectionDelegate?.privateGroupsCollection.reloadData()
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
                            checkIfNewAnswerHasBeenMade(oldThread: oldList[index], newThread: thread)
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
    
    func checkIfNewAnswerHasBeenMade(oldThread: Thread, newThread: Thread){
        let tempOld = oldThread.commentIDs!.sorted()
        let tempNew = newThread.commentIDs!.sorted()
        
        for comment in tempNew {
            if(!(tempOld.contains(comment))) {
                print("hier es gibt eine neue Antwort auf deinen Thread")
                HoupNotifications.shared.setUpNewAnswerToThreadNotification(threadDetails: newThread)
            }
        }
    }
    
    
    func getAllGroupsWithThreads() -> [String : [Thread]]{
        var oldGroupsThreadsList: [String : [Thread]] = [String : [Thread]]()
        if let oldList  = self.userDefaults.object(forKey: "groupsWithThreadsSync\(getUserID())") as? Data{
            oldGroupsThreadsList = NSKeyedUnarchiver.unarchiveObject(with: oldList) as! [String : [Thread]]
        }
        return oldGroupsThreadsList
    }
    
    func sortThreads(threads: [Thread]) -> [Thread]{
        var oldThreadList: [Thread] = threads
        oldThreadList.sort(by:
            { $0.dateObject?.compare($1.dateObject!) == ComparisonResult.orderedDescending }
        )
        return oldThreadList
    }
    
    func saveGroupsWithThreads(groupsWithThreads: [String : [Thread]]){
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: groupsWithThreads)
        self.userDefaults.set(encodedData, forKey: "groupsWithThreadsSync\(getUserID())")
        self.userDefaults.synchronize()
    }
    
    func getAllPublicGroupThreads() -> [Thread]{
        var oldPublicThreadsList: [Thread] = [Thread]()
        if let oldList  = self.userDefaults.object(forKey: "publicGroupThreads\(getUserID())") as? Data{
            oldPublicThreadsList = NSKeyedUnarchiver.unarchiveObject(with: oldList) as! [Thread]
        }
        return oldPublicThreadsList
    }
    
    func savePublicThreads(threadsList: [Thread]){
        var tempThreads = threadsList
        tempThreads.sort(by:
            { $0.dateObject?.compare($1.dateObject!) == ComparisonResult.orderedDescending }
        )
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: tempThreads)
        self.userDefaults.set(encodedData, forKey: "publicGroupThreads\(getUserID())")
        self.userDefaults.synchronize()
        self.publicGroupsWithThreadsControllerDelegate?.threadsCollectionView.reloadData()
    }
    
    func saveAllThreadsOfGroup(groupID: String, threads: [Thread]){
        var oldGroupsThreadsList: [String : [Thread]] = [String : [Thread]]()
        if let oldList  = self.userDefaults.object(forKey: "groupsWithThreadsSync\(getUserID())") as? Data{
            oldGroupsThreadsList = NSKeyedUnarchiver.unarchiveObject(with: oldList) as! [String : [Thread]]
            oldGroupsThreadsList[groupID]! = threads
            oldGroupsThreadsList[groupID]?.sort(by:
                { $0.dateObject?.compare($1.dateObject!) == ComparisonResult.orderedDescending }
            )
            let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: oldGroupsThreadsList)
            self.userDefaults.set(encodedData, forKey: "groupsWithThreadsSync\(getUserID())")
            self.userDefaults.synchronize()
        }
        self.privateGroupsWithThreadsDelegate?.threadsCollectionView.reloadData()
        //self.publicGroupsWithThreadsControllerDelegate?.threadsCollectionView.reloadData()
    }
    
    func sortGroupsWithThreads(groupID: String){
        var oldGroupsThreadsList: [String : [Thread]] = [String : [Thread]]()
        if let oldList  = self.userDefaults.object(forKey: "groupsWithThreadsSync\(getUserID())") as? Data{
            oldGroupsThreadsList = NSKeyedUnarchiver.unarchiveObject(with: oldList) as! [String : [Thread]]
            oldGroupsThreadsList[groupID]?.sort(by:
                { $0.dateObject?.compare($1.dateObject!) == ComparisonResult.orderedDescending }
            )
        }
        saveGroupsWithThreads(groupsWithThreads: oldGroupsThreadsList)
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
        self.userDefaults.set(encodedData, forKey: "publicGroupThreads\(getUserID())")
        self.userDefaults.synchronize()
        self.publicGroupsWithThreadsControllerDelegate?.threadsCollectionView.reloadData()
    }
    
    func getAllThreadsOfGroup(groupID: String) -> [Thread]{
        var oldGroupsThreadsList: [String : [Thread]] = [String : [Thread]]()
        if let oldList  = self.userDefaults.object(forKey: "groupsWithThreadsSync\(getUserID())") as? Data{
            oldGroupsThreadsList = NSKeyedUnarchiver.unarchiveObject(with: oldList) as! [String : [Thread]]
            if let temp = oldGroupsThreadsList[groupID]{
                return temp
            }else{
                return [Thread]()
            }
        }
        return [Thread]()
    }
    //---------------------------------------------------------------------------------------
    //---------------------------------------------------------------------------------------
}
