//
//  TempStorageAndCompare.swift
//  Houp
//
//  Created by Sebastian on 29.05.17.
//  Copyright © 2017 SP. All rights reserved.
//

import Foundation

class TempStorageAndCompare{

    static let shared: TempStorageAndCompare = TempStorageAndCompare()
    
    var groups: [PrivateGroup] = [PrivateGroup]()
    var threads: [String : [Thread]] = [String : [Thread]]()
    
    var groupsWithThreads: [PrivateGroup : [Thread]] = [PrivateGroup : [Thread]]()

    func compareAndSaveGroups(group: PrivateGroup){
        if let index = groups.index(where: { (item) -> Bool in
            item.pgid == group.pgid
        }){
            // check if revision changed, if yes then hasbeenupdated = true
            if(groups[index].rev != group.rev){
                groups[index].hasBeenUpdated = true
                //hier eventuell event triggern und collection view updaten
            }
        }else{
            group.hasBeenUpdated = true
            groups.append(group)
        }
        print(group.hasBeenUpdated)
    }
    
    func compareAndSaveThreads(groupID: String, thread: Thread){
        
        if let groupExists = threads[groupID]{
            if let index = threads[groupID]?.index(where: { (item) -> Bool in
                                item.tid == thread.tid
                            }){
                                // check if revision changed, if yes then hasbeenupdated = true
                            if(threads[groupID]?[index].rev != thread.rev){
                            threads[groupID]?[index].hasBeenUpdated = true
                                }
                            }else{
                                thread.hasBeenUpdated = true
                                threads[groupID]?.append(thread)
                            }
        }else{
            thread.hasBeenUpdated = true
            threads[groupID] = [thread]
        }
        
        
//        if let indexGroup = threads.index(where: { (item) -> Bool in
//            true
//        }){
//            if let index = threads[indexGroup].index(where: { (item) -> Bool in
//                item.tid == thread.tid
//            }){
//                // check if revision changed, if yes then hasbeenupdated = true
//                if(threads[indexGroup].rev != thread.rev){
//                    threads[indexGroup].hasBeenUpdated = true
//                }
//            }else{
//                thread.hasBeenUpdated = true
//                threads[indexGroup].append(thread)
//            }
//        }
//        
//        
//        if let index = threads.index(where: { (item) -> Bool in
//            item.tid == thread.tid
//        }){
//            // check if revision changed, if yes then hasbeenupdated = true
//            if(threads[index].rev != thread.rev){
//                threads[index].hasBeenUpdated = true
//            }
//        }else{
//            thread.hasBeenUpdated = true
//            threads.append(thread)
//        }
    }
    
    func setHasBeenUpdatedStatusOfThread(groupID: String, threadID: String, hasBeenUpdated: Bool){
        if let index = threads[groupID]?.index(where: { (item) -> Bool in
            item.tid == threadID
        }){
            threads[groupID]?[index].hasBeenUpdated = hasBeenUpdated
        }
    }
    
    func setHasBeenUpdatedStatusOfGroup(groupID: String, hasBeenUpdated: Bool){
        if let index = groups.index(where: { (item) -> Bool in
            item.pgid == groupID
        }){
            groups[index].hasBeenUpdated = hasBeenUpdated
        }
    }
}
