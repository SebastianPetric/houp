//
//  HoupNotifications.swift
//  Houp
//
//  Created by Sebastian on 21.06.17.
//  Copyright © 2017 SP. All rights reserved.
//

import UIKit
import UserNotifications

class HoupNotifications: NSObject{

    static var shared: HoupNotifications = HoupNotifications()
    var timerNewRequest = Timer()
    var timerNewAnswer = Timer()
    var timerNewThread = Timer()
    var newThread: PrivateGroup?
    var newAnswer: Thread?
    var newRequest: PrivateGroup?
    
    func setUpNewRequestArrivedNotification(groupDetails: PrivateGroup){
        self.newRequest = groupDetails
        self.timerNewRequest = Timer(fireAt: Date(), interval: 5, target: self, selector: #selector(newRequestToGroupArrived), userInfo: nil, repeats: false)
        RunLoop.main.add(self.timerNewRequest, forMode: RunLoopMode.commonModes)
    }
    
    func setUpNewAnswerToThreadNotification(threadDetails: Thread){
        self.newAnswer = threadDetails
        self.timerNewThread = Timer(fireAt: Date(), interval: 5, target: self, selector: #selector(newAnswerToThreadArrived), userInfo: nil, repeats: false)
        RunLoop.main.add(self.timerNewThread, forMode: RunLoopMode.commonModes)
    }
    
    func setUpNewThreadToGroupNotification(groupDetails: PrivateGroup){
        self.newThread = groupDetails
        self.timerNewThread = Timer(fireAt: Date(), interval: 5, target: self, selector: #selector(newThreadToGroupArrived), userInfo: nil, repeats: false)
        RunLoop.main.add(self.timerNewThread, forMode: RunLoopMode.commonModes)
    }
    
    func newRequestToGroupArrived(){
        let content = UNMutableNotificationContent()
        content.title = "Neue Anfrage!"
        if let name = self.newRequest?.nameOfGroup{
        content.body = "Jemand will der Gruppe: \(name) beitreten."
        }
        
        content.badge = 1
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: "requestNotification", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    func newAnswerToThreadArrived(){
        let content = UNMutableNotificationContent()
        content.title = "Eine Reaktion auf dein Thema:"
        if let title = self.newAnswer?.title{
            content.body = title
        }
        content.badge = 1
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: "newAnswerNotification", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    func newThreadToGroupArrived(){
        let content = UNMutableNotificationContent()
        content.title = "Vielleicht kannst du ja helfen!"
        if let name = self.newThread?.nameOfGroup{
            content.body = "In: \(name) wurde ein neues Thema erstellt."
        }
        content.badge = 1
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: "newThreadNotification", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    func deinitTimer(){
        self.timerNewThread.invalidate()
        self.timerNewAnswer.invalidate()
        self.timerNewRequest.invalidate()
    }
}
