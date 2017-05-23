//
//  Timer.swift
//  Houp
//
//  Created by Sebastian on 20.05.17.
//  Copyright © 2017 SP. All rights reserved.
//

import UIKit
import UserNotifications

class TimerObject{
    
    static let shared: TimerObject = TimerObject()
    
    var tabContr: UITabBarController?
    var activityCollection: ActivityWeekCollection?
    var timer: Timer = Timer()
    var timerToDelay: Timer = Timer()
    var tryLaterAgain = false
    
    //jede stunde nach 20 Uhr des nächsten Tages Notification raushauen, in welcher gesagt wird dass man doch das formular ausfüllen soll. wenn man darauf klickt, wird die app geöffnet und sofort das formular gestartet. wenn man das formular fertig ausgefüllt hat, kann man den timer neu setzen
    @objc func fireTimer(){
        let state = UIApplication.shared.applicationState
        if state == .background {
            let content = UNMutableNotificationContent()
            content.title = "Hey! Wie ging es dir heute?"
            content.body = "Bitte schenke Uns wenige Minuten deiner Zeit um über den heutigen Tag zu reden :)"
            content.badge = 1
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            let request = UNNotificationRequest(identifier: "timerDone", content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
            // Wenn im Hintergrund dann Notification
        }else if state == .active {
            if(self.tabContr?.selectedIndex != 2){
                self.tabContr?.selectedIndex = 2
            }else{
            self.activityCollection?.updateController()
            }
            // Wenn im Fordergrund, dann Activity öffnen
        }
    }
    
    func setUpTimerImmediately(){
        self.timer = Timer(fireAt: Date(), interval: 3600, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
        RunLoop.main.add(self.timer, forMode: RunLoopMode.commonModes)
    }
    
    func setUpTimer(date: Date){
        self.timer = Timer(fireAt: Date().checkIfActivityAlreadyOver(date: date), interval: 3600, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
        RunLoop.main.add(self.timer, forMode: RunLoopMode.commonModes)
    }
    
    //wenn er gerade keine zeit hat die formulare auszufüllen
    func setUpTimerToDelayForms(){
        self.timerToDelay = Timer(fireAt: Date(), interval: 200, target: self, selector: #selector(tryAgain), userInfo: nil, repeats: true)
        RunLoop.main.add(self.timerToDelay, forMode: RunLoopMode.commonModes)
    }
    
    @objc func tryAgain(){
        self.tryLaterAgain = false
        invalidateDelayTimer()
    }
    
    //invalidieren, wenn die Aktivität endlich erledigt worden ist, ansonsten, jede stunde fragen
    func invalidateTimer(){
        self.timer.invalidate()
    }
    
    func invalidateDelayTimer(){
        self.timerToDelay.invalidate()
    }
    

}
