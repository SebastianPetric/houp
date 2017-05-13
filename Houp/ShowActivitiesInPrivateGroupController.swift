//
//  ShowActivitiesInPrivateGroupController.swift
//  Houp
//
//  Created by Sebastian on 13.05.17.
//  Copyright © 2017 SP. All rights reserved.
//

import UIKit

class ShowActivitiesInPrivateGroupController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    
    deinit {
        liveQuery?.removeObserver(self, forKeyPath: "rows")
    }
    
    var liveQuery: CBLLiveQuery?
    
    var privateGroup: PrivateGroup?{
        didSet{
            if let name = privateGroup?.nameOfGroup{
                nameOfGroup.text = name
            }
            if let location = privateGroup?.location{
                locationOfMeeting.text = location
            }
            if let secretID = privateGroup?.secretID{
                secretGroupID.text = "GeheimID: \(secretID)"
            }
            if let time = privateGroup?.timeOfMeeting{
                self.timeOfMeeting.text = "\(Date().getFormattedStringFromDate(time: time)) Uhr"
            }
            if let dayOfMeeting = privateGroup?.dayOfMeeting{
                self.dayOfMeeting.text = dayOfMeeting
            }
            if let name = privateGroup?.nameOfGroup{
                nameOfGroup.text = name
            }
        }
    }
    
    
    var widthHeightOfImageViews: CGFloat = 20
    let activityCellID = "activityCellID"
    
    var activityList = [Activity]()
    
    let infoContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    let seperatorText = CustomViews.shared.getCustomSeperator(color: .black)
    let nameOfGroup = CustomViews.shared.getCustomLabel(text: "AA Regionalgruppe", fontSize: 14, numberOfLines: 1, isBold: true, textAlignment: .left, textColor: nil)
    let locationOfMeeting = CustomViews.shared.getCustomLabel(text: "Weingarten, Siemensstraße 28", fontSize: 12, numberOfLines: 2, isBold: false, textAlignment: .left, textColor: nil)
    let dayOfMeeting = CustomViews.shared.getCustomLabel(text: "Jeden 3. Donnerstag im geraden Monat", fontSize: 12, numberOfLines: 1, isBold: false, textAlignment: .left, textColor: nil)
    let timeOfMeeting = CustomViews.shared.getCustomLabel(text: "19:30 Uhr", fontSize: 12, numberOfLines: 1, isBold: false, textAlignment: .left, textColor: nil)
    let secretGroupID = CustomViews.shared.getCustomLabel(text: "#GeheimeID", fontSize: 12, numberOfLines: 1, isBold: true, textAlignment: .left, textColor: nil)
    let editButton = CustomViews.shared.getCustomImageView(imageName: "edit_icon", cornerRadius: 0, isUserInteractionEnabled: false, imageColor: nil, borderColor: .white)
    let seperatorMembers = CustomViews.shared.getCustomSeperator(color: UIColor().getSecondColor())
    
    
    lazy var activityCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        let members = UICollectionView(frame: .zero, collectionViewLayout: layout)
        members.dataSource = self
        members.delegate = self
        members.backgroundColor = .white
        return members
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getTopicActivities(groupID: (privateGroup?.pgid)!)
        infoContainer.addSubview(nameOfGroup)
        infoContainer.addSubview(locationOfMeeting)
        infoContainer.addSubview(timeOfMeeting)
        infoContainer.addSubview(seperatorText)
        infoContainer.addSubview(dayOfMeeting)
        infoContainer.addSubview(secretGroupID)
        infoContainer.addSubview(editButton)
        view.addSubview(infoContainer)
        view.addSubview(seperatorMembers)
        view.addSubview(activityCollectionView)
        activityCollectionView.register(ShowActivitiesInPrivateGroupCell.self, forCellWithReuseIdentifier: activityCellID)
        setUpSubViews()
    }
    
    func setUpSubViews(){
        infoContainer.addConstraintsWithConstants(top: view.topAnchor, right: view.rightAnchor, bottom: nil, left: view.leftAnchor, centerX: nil, centerY: nil, topConstant: 0, rightConstant: 0, bottomConstant: 0, leftConstant: 0, width: 0, height: 105)
        editButton.addConstraintsWithConstants(top: infoContainer.topAnchor, right: infoContainer.rightAnchor, bottom: nil, left: nil, centerX: nil, centerY: nil, topConstant: 15, rightConstant: 15, bottomConstant: 0, leftConstant: 0, width: self.widthHeightOfImageViews, height: self.widthHeightOfImageViews)
        nameOfGroup.addConstraintsWithConstants(top: infoContainer.topAnchor, right: nil, bottom: nil, left: infoContainer.leftAnchor, centerX: nil, centerY: nil, topConstant: 15, rightConstant: 0, bottomConstant: 0, leftConstant: 15, width: 200, height: 15)
        locationOfMeeting.addConstraintsWithConstants(top: nameOfGroup.bottomAnchor, right: editButton.leftAnchor, bottom: nil, left: infoContainer.leftAnchor, centerX: nil, centerY: nil, topConstant: 5, rightConstant: 0, bottomConstant: 0, leftConstant: 15, width: 0, height: 15)
        timeOfMeeting.addConstraintsWithConstants(top: locationOfMeeting.bottomAnchor, right: nil, bottom: nil, left: infoContainer.leftAnchor, centerX: nil, centerY: nil, topConstant: 5, rightConstant: 0, bottomConstant: 0, leftConstant: 15, width: 60, height: 15)
        seperatorText.addConstraintsWithConstants(top: locationOfMeeting.bottomAnchor, right: nil, bottom: nil, left: timeOfMeeting.rightAnchor, centerX: nil, centerY: nil, topConstant: 5, rightConstant: 0, bottomConstant: 0, leftConstant: 0, width: 0.5, height: 15)
        dayOfMeeting.addConstraintsWithConstants(top: locationOfMeeting.bottomAnchor, right: editButton.leftAnchor, bottom: nil, left: seperatorText.leftAnchor, centerX: nil, centerY: nil, topConstant: 5, rightConstant: 0, bottomConstant: 0, leftConstant: 5, width: 0, height: 15)
        secretGroupID.addConstraintsWithConstants(top: timeOfMeeting.bottomAnchor, right: nil, bottom: nil, left: infoContainer.leftAnchor, centerX: nil, centerY: nil, topConstant: 5, rightConstant: 0, bottomConstant: 0, leftConstant: 15, width: 130.5, height: 15)
        seperatorMembers.addConstraintsWithConstants(top: infoContainer.bottomAnchor, right: infoContainer.rightAnchor, bottom: nil, left: view.leftAnchor, centerX: nil, centerY: nil, topConstant: 0, rightConstant: 0, bottomConstant: 0, leftConstant: 0, width: 0, height: 1)
        activityCollectionView.addConstraintsWithConstants(top: seperatorMembers.bottomAnchor, right: view.rightAnchor, bottom: view.bottomAnchor, left: view.leftAnchor, centerX: nil, centerY: nil, topConstant: 0, rightConstant: 0, bottomConstant: 0, leftConstant: 0, width: 0, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: activityCellID, for: indexPath) as! ShowActivitiesInPrivateGroupCell
        cell.activityObject = self.activityList[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return activityList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = ActivitiesCommentsController()
        controller.activityObject = activityList[indexPath.row]
        controller.titleNav = (self.privateGroup?.nameOfGroup)!
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func getTopicActivities(groupID: String){
        do{
            if let view = DBConnection.shared.viewByAllActivityInGroup{
                let query = view.createQuery()
                query.keys = [groupID]
                liveQuery = query.asLive()
                liveQuery?.addObserver(self, forKeyPath: "rows", options: .new, context: nil)
                liveQuery?.start()
            }
        }catch{
            let alert = CustomViews.shared.getCustomAlert(errorTitle: GetString.errorTitle.rawValue, errorMessage: GetString.errorWithConnection.rawValue, firstButtonTitle: GetString.errorOKButton.rawValue, secondButtonTitle: nil, firstHandler: nil, secondHandler: nil)
            self.present(alert, animated: true, completion: nil)
        }
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == "rows" {
            do{
                if let rows = liveQuery?.rows {
                    self.activityList.removeAll()
                    while let row = rows.nextRow() {
                        if let props = row.document!.properties {
                                                            var userName: String?
                                                            let queryForUsername = DBConnection.shared.getDBConnection()?.createAllDocumentsQuery()
                                                            queryForUsername?.allDocsMode = CBLAllDocsMode.allDocs
                                                            queryForUsername?.keys = [UserDefaults.standard.string(forKey: GetString.userID.rawValue)]
                                                            let result = try queryForUsername?.run()
                                                            while let row = result?.nextRow() {
                                                                userName = row.document?["username"] as? String
                                                            }
                            let activitytime = props["time"] as! String
                            let formatter = DateFormatter()
                            formatter.dateFormat = "HH:mm"
                            
                            var activitydate: Date?
                            if let activityDate = props["date"] as? String{
                                activitydate = Date(dateString: activityDate)
                            }
                            
                            let activity = Activity(rev: row.documentRevisionID, aid: row.documentID, authorID: props["authorID"] as! String?, authorUsername: userName, groupID: props["groupID"] as! String?, activity: props["activity"] as! String?, activityText: props["activityText"] as! String?, locationOfActivity: props["locationOfActivity"] as! String?, isInProcess: props["isInProcess"] as! Bool?, status: props["status"] as! Int?, wellBeingState: props["wellBeingState"] as! Int?, wellBeingText: props["wellBeingText"] as! String?, addictionState: props["addictionState"] as! Int?, addictionText: props["addictionText"] as! String?, dateObject: activitydate, timeObject: formatter.date(from: activitytime), commentIDs: props["commentIDs"] as! [String]?, likeIDs: props["likeIDs"] as! [String]?)
                            self.activityList.append(activity)
                        }
                        self.activityList.sort(by:
                            { $0.dateObject?.compare($1.dateObject!) == ComparisonResult.orderedAscending }
                        )
                        self.activityCollectionView.reloadData()
                    }
                }
            }catch{
                let alert = CustomViews.shared.getCustomAlert(errorTitle: GetString.errorTitle.rawValue, errorMessage: GetString.errorWithConnection.rawValue, firstButtonTitle: GetString.errorOKButton.rawValue, secondButtonTitle: nil, firstHandler: nil, secondHandler: nil)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}

