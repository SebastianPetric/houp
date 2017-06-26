//
//  CompareAndSaveGroup.swift
//  Houp
//
//  Created by Sebastian on 26.06.17.
//  Copyright © 2017 SP. All rights reserved.
//

import UIKit

extension TempStorageAndCompare{

    //---------------------------------------------------------------------------------------
    // Hier werden neue Gruppen verglichen, und gespeichert falls sich was geändert hat etc
    //---------------------------------------------------------------------------------------
    
    func compareAndSaveGroups(group: PrivateGroup){
        if (getAllPrivateGroupsSync().count != 0) {
            var oldList: [PrivateGroup] = getAllPrivateGroupsSync()
            if let index = oldList.index(where: { (item) -> Bool in
                item.pgid == group.pgid
            }){
                // check if revision changed, if yes then hasbeenupdated = true
                if((oldList[index].rev != group.rev) || anyThreadOfGroupWasUpdated(group: oldList[index])){
                    if(getUserID() == group.adminID){
                        checkIfRequestHasBeenMade(oldGroup: oldList[index], newGroup: group)
                    }
                    checkIfNewThreadHasBeenOpened(oldGroup: oldList[index], newGroup: group)
                    group.hasBeenUpdated = true
                    oldList[index] = group
                    saveGroupList(groupList: sortGroups(groups: oldList))
                }
            }else{
                group.hasBeenUpdated = true
                oldList.append(group)
                saveGroupList(groupList: sortGroups(groups: oldList))
            }
        }else{
            group.hasBeenUpdated = true
            saveGroupList(groupList: [group])
        }
    }
    
    func getAllPrivateGroupsSync() -> [PrivateGroup] {
        var oldPrivateGroupsList: [PrivateGroup] = [PrivateGroup]()
        if let oldList  = self.userDefaults.object(forKey: "privateGroupsSync\(getUserID())") as? Data{
            oldPrivateGroupsList = NSKeyedUnarchiver.unarchiveObject(with: oldList) as! [PrivateGroup]
        }
        return oldPrivateGroupsList
    }
    
    func checkIfRequestHasBeenMade(oldGroup: PrivateGroup, newGroup: PrivateGroup){
        let tempOld = oldGroup.groupRequestIDs!.sorted()
        let tempNew = newGroup.groupRequestIDs!.sorted()
        
        for user in tempNew {
            if(!(tempOld.contains(user))) {
                print("hier es gibt eine neue anfrage")
                HoupNotifications.shared.setUpNewRequestArrivedNotification(groupDetails: newGroup)
            }
        }
    }
    
    func checkIfNewThreadHasBeenOpened(oldGroup: PrivateGroup, newGroup: PrivateGroup){
        let oldThreadList = oldGroup.threadIDs!.sorted()
        let newThreadList = newGroup.threadIDs!.sorted()
        
        for thread in newThreadList{
            if(!oldThreadList.contains(thread)){
                HoupNotifications.shared.setUpNewThreadToGroupNotification(groupDetails: newGroup)
            }
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
    
    func sortGroups(){
        var oldPrivateGroupsList: [PrivateGroup] = [PrivateGroup]()
        if let oldList  = self.userDefaults.object(forKey: "privateGroupsSync\(getUserID())") as? Data{
            oldPrivateGroupsList = NSKeyedUnarchiver.unarchiveObject(with: oldList) as! [PrivateGroup]
        }
        oldPrivateGroupsList.sort(by:
            { $0.createdAt?.compare($1.createdAt!) == ComparisonResult.orderedDescending }
        )
        saveGroupList(groupList: oldPrivateGroupsList)
    }
    
    func sortGroups(groups: [PrivateGroup]) -> [PrivateGroup]{
        var oldGroupsList: [PrivateGroup] = groups
        oldGroupsList.sort(by:
            { $0.createdAt?.compare($1.createdAt!) == ComparisonResult.orderedDescending }
        )
        return oldGroupsList
    }
    
    func saveGroupList(groupList: [PrivateGroup]){
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: groupList)
        self.userDefaults.set(encodedData, forKey: "privateGroupsSync\(getUserID())")
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
    
    func setHasBeenUpdatedStatusOfGroup(groupID: String, hasBeenUpdated: Bool){
        if let index = getAllPrivateGroupsSync().index(where: { (item) -> Bool in
            item.pgid == groupID
        }){
            getAllPrivateGroupsSync()[index].hasBeenUpdated = hasBeenUpdated
        }
    }
    
    func saveSingleGroup(group: PrivateGroup, hasBeenUpdated: Bool){
        var oldPrivateGroupsList: [PrivateGroup] = [PrivateGroup]()
        if let oldList  = self.userDefaults.object(forKey: "privateGroupsSync\(getUserID())") as? Data{
            oldPrivateGroupsList = NSKeyedUnarchiver.unarchiveObject(with: oldList) as! [PrivateGroup]
        }
        if let index = oldPrivateGroupsList.index(where: { (item) -> Bool in
            item.pgid == group.pgid
        }){
            let tempGroup = group
            group.hasBeenUpdated = hasBeenUpdated
            oldPrivateGroupsList[index] = tempGroup
            let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: oldPrivateGroupsList)
            self.userDefaults.set(encodedData, forKey: "privateGroupsSync\(getUserID())")
            self.userDefaults.synchronize()
        }
    }
    
    func saveSingleGroup(groupID: String, hasBeenUpdated: Bool){
        var oldPrivateGroupsList: [PrivateGroup] = [PrivateGroup]()
        if let oldList  = self.userDefaults.object(forKey: "privateGroupsSync\(getUserID())") as? Data{
            oldPrivateGroupsList = NSKeyedUnarchiver.unarchiveObject(with: oldList) as! [PrivateGroup]
        }
        if let index = oldPrivateGroupsList.index(where: { (item) -> Bool in
            item.pgid == groupID
        }){
            oldPrivateGroupsList[index].hasBeenUpdated = hasBeenUpdated
            
            let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: oldPrivateGroupsList)
            self.userDefaults.set(encodedData, forKey: "privateGroupsSync\(getUserID())")
            self.userDefaults.synchronize()
        }
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
    
    func deleteGroup(groupID: String){
        var tempGroupsWithThreads: [String: [Thread]] = [String: [Thread]]()
        var tempGroupsList: [PrivateGroup] = [PrivateGroup]()
        var newTempGroupsWithThreads: [String: [Thread]] = [String: [Thread]]()
        
        if let oldListOfGroupsWithThreads  = self.userDefaults.object(forKey: "groupsWithThreadsSync\(getUserID())") as? Data{
            tempGroupsWithThreads = NSKeyedUnarchiver.unarchiveObject(with: oldListOfGroupsWithThreads) as! [String : [Thread]]
            
            tempGroupsWithThreads.removeValue(forKey: groupID)
            newTempGroupsWithThreads = tempGroupsWithThreads
            
            let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: newTempGroupsWithThreads)
            self.userDefaults.set(encodedData, forKey: "groupsWithThreadsSync\(getUserID())")
            self.userDefaults.synchronize()
        }
        
        if let oldListOfGroups  = self.userDefaults.object(forKey: "privateGroupsSync\(getUserID())") as? Data{
            tempGroupsList = NSKeyedUnarchiver.unarchiveObject(with: oldListOfGroups) as! [PrivateGroup]
            
            for (index, group) in tempGroupsList.enumerated() {
                if(group.pgid == groupID){
                    tempGroupsList.remove(at: index)
                    let encodedDataGroups: Data = NSKeyedArchiver.archivedData(withRootObject: tempGroupsList)
                    self.userDefaults.set(encodedDataGroups, forKey: "privateGroupsSync\(getUserID())")
                    self.userDefaults.synchronize()
                }
            }
        }
        self.privateGroupCollectionDelegate?.privateGroupsCollection.reloadData()
    }
    //---------------------------------------------------------------------------------------
    //---------------------------------------------------------------------------------------
}
