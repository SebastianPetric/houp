//
//  ActivityWeekCollection.swift
//  Houp
//
//  Created by Sebastian on 07.05.17.
//  Copyright © 2017 SP. All rights reserved.
//

import UIKit
import UserNotifications

class ActivityWeekCollection: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource{

    let activityCellID = "activityCellID"
    let activityCellHighlightedID = "activityCellHighlightedID"
    var widthHeightOfImageViews: CGFloat = 20
    var activityList: [Activity] = [Activity]()
    var liveQuery: CBLLiveQuery?
    var timer: Timer?
    var timerToDelay: Timer?
    var timerReset: Bool = false
    var tryLaterAgain: Bool = false
    
    lazy var activityCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        let activity = UICollectionView(frame: .zero, collectionViewLayout: layout)
        activity.dataSource = self
        activity.delegate = self
        activity.backgroundColor = .white
        return activity
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let userID = UserDefaults.standard.string(forKey: GetString.userID.rawValue){
            if(liveQuery == nil){
                getTopicActivities(userID: userID)
            }
        }
        
        if(self.activityList.count > 0){
            if(Date().checkIfActivityAlreadyOver(date: self.activityList[0].dateObject!) <= Date()){
                setUpTimerToday()
            }else{
                setUpTimer(date: self.activityList[0].dateObject!)
            }
        }
        
        view.addSubview(activityCollectionView)
        self.activityCollectionView.register(ActivityWeekCollectionCell.self, forCellWithReuseIdentifier: activityCellID)
        self.activityCollectionView.register(ActivityWeekHighlightedCell.self, forCellWithReuseIdentifier: activityCellHighlightedID)
        handleNavBarItem()
        setUpSubViews()
    }
    
    func setUpSubViews(){
        activityCollectionView.addConstraintsWithConstants(top: view.topAnchor, right: view.rightAnchor, bottom: view.bottomAnchor, left: view.leftAnchor, centerX: nil, centerY: nil, topConstant: 0, rightConstant: 0, bottomConstant: 0, leftConstant: 0, width: 0, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if(indexPath.row == 0){
        return CGSize(width: view.frame.width, height: 150)
        }else{
        return CGSize(width: view.frame.width, height: 75)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(indexPath.row == 0){
        let cellHighlighted = collectionView.dequeueReusableCell(withReuseIdentifier: activityCellHighlightedID, for: indexPath) as! ActivityWeekHighlightedCell
            cellHighlighted.activityObject = self.activityList[indexPath.row]
        return cellHighlighted
        }else{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: activityCellID, for: indexPath) as! ActivityWeekCollectionCell
            cell.activityObject = self.activityList[indexPath.row]
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.activityList.count
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("will load \(self.activityList.count)")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if(self.activityList.count == 0){
            if (!self.tryLaterAgain){
                self.timerToDelay?.invalidate()
                self.timer?.invalidate()
                handleActivityForm()
            }else{
                setUpTimerToDelayForms()
            }
            
            //wenn die aktivität heute stattfindet
        }else if(self.activityList[0].dateObject?.getDatePart() == Date().getDatePart()){
            //Wenn es nach 20 Uhr ist
            if(Date() >= Date().getDateForTimer()){
                if (!self.tryLaterAgain){
                    self.timerToDelay?.invalidate()
                    handleUpdateActivity()
                }else{
                    setUpTimerToDelayForms()
                }
            }
        }
    }

    //jede stunde nach 20 Uhr des nächsten Tages Notification raushauen, in welcher gesagt wird dass man doch das formular ausfüllen soll. wenn man darauf klickt, wird die app geöffnet und sofort das formular gestartet. wenn man das formular fertig ausgefüllt hat, kann man den timer neu setzen
    func fireTimer(){
        let state = UIApplication.shared.applicationState
        if state == .background {
            let content = UNMutableNotificationContent()
            content.title = "Hey! Wie ging es dir heute?"
            content.body = "Bitte beantworte kurz ein paar Fragen zu heute :)"
            content.badge = 1
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            let request = UNNotificationRequest(identifier: "timerDone", content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
            // Wenn im Hintergrund dann Notification
        }
        else if state == .active {
            if(self.tabBarController?.selectedIndex == 2){
            handleUpdateActivity()
            }else{
            self.tabBarController?.selectedIndex = 2
            }
            // Wenn im Fordergrund, dann Activity öffnen
        }
    }
    
    func setUpTimerToday(){
        self.timer = Timer(fireAt: Date(), interval: 3600, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
        RunLoop.main.add(self.timer!, forMode: RunLoopMode.commonModes)
    }
    
    func setUpTimer(date: Date){
        self.timer = Timer(fireAt: Date().checkIfActivityAlreadyOver(date: date), interval: 3600, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
        RunLoop.main.add(self.timer!, forMode: RunLoopMode.commonModes)
    }

    
    
    //wenn er gerade keine zeit hat die formulare auszufüllen
    func setUpTimerToDelayForms(){
        self.timerToDelay = Timer(fireAt: Date(), interval: 200, target: self, selector: #selector(tryAgain), userInfo: nil, repeats: true)
        RunLoop.main.add(self.timerToDelay!, forMode: RunLoopMode.commonModes)
    }
    
    func tryAgain(){
    self.tryLaterAgain = false
    invalidateDelayTimer()
    }

    
    //invalidieren, wenn die Aktivität endlich erledigt worden ist, ansonsten, jede stunde fragen
    func invalidateTimer(){
        self.timer?.invalidate()
    }
    
    func invalidateDelayTimer(){
        self.timerToDelay?.invalidate()
    }
}
