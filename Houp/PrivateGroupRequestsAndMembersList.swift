//
//  PrivateGroupRequestsAndMembersList.swift
//  Houp
//
//  Created by Sebastian on 07.04.17.
//  Copyright © 2017 SP. All rights reserved.
//

import UIKit

class PrivateGroupRequestAndMembersList: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{

    
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
    let membersCellID = "membersCellID"
    let sectionHeaderID = "sectionHeader"
    var adminList = [[UserObject]]()
    
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

    
    lazy var membersCollectionView: UICollectionView = {
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
        view.backgroundColor = .red
        self.title = "Mitglieder"
        getTopicUsers(groupID: (privateGroup?.pgid)!)
        infoContainer.addSubview(nameOfGroup)
        infoContainer.addSubview(locationOfMeeting)
        infoContainer.addSubview(timeOfMeeting)
        infoContainer.addSubview(seperatorText)
        infoContainer.addSubview(dayOfMeeting)
        infoContainer.addSubview(secretGroupID)
        infoContainer.addSubview(editButton)
        view.addSubview(infoContainer)
        view.addSubview(seperatorMembers)
        view.addSubview(membersCollectionView)
        membersCollectionView.register(PrivateGroupRequestsAndMembersCell.self, forCellWithReuseIdentifier: membersCellID)
        membersCollectionView.register(PrivateGroupRequestsAndMembersHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: sectionHeaderID)
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
        membersCollectionView.addConstraintsWithConstants(top: seperatorMembers.bottomAnchor, right: view.rightAnchor, bottom: view.bottomAnchor, left: view.leftAnchor, centerX: nil, centerY: nil, topConstant: 0, rightConstant: 0, bottomConstant: 0, leftConstant: 0, width: 0, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 75)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: membersCellID, for: indexPath) as! PrivateGroupRequestsAndMembersCell
        
        cell.privateGroup = self.privateGroup
            if(self.privateGroup?.adminID == UserDefaults.standard.string(forKey: GetString.userID.rawValue)){
                cell.user = self.adminList[indexPath.section][indexPath.row]
                if(indexPath.section == 0){
                    cell.isMember = false
                }else{
                    cell.isMember = true
                }
            }else{
                cell.user = self.adminList[1][indexPath.row]
                cell.isMember = true
            }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(self.privateGroup?.adminID == UserDefaults.standard.string(forKey: GetString.userID.rawValue)){
        return adminList.count == 0 ? 0 : adminList[section].count
        }else{
        return adminList.count == 0 ? 0 : adminList[1].count
       }
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.privateGroup?.adminID == UserDefaults.standard.string(forKey: GetString.userID.rawValue) ? 2 : 1
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var header: String = ""
        
        if(self.privateGroup?.adminID != UserDefaults.standard.string(forKey: GetString.userID.rawValue)){
        header = "Mitglieder"
        }else{
            if(indexPath.section == 0){
                header = "Anfragen"
            }else{
                header = "Mitglieder"
            }
        }
        let secheader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: sectionHeaderID, for: indexPath) as! PrivateGroupRequestsAndMembersHeader
            secheader.sectionHeader.text = header
            return secheader
       
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 20)
    }
    
    
    
    func getTopicUsers(groupID: String){
        do{
                let query = DBConnection.shared.getDBConnection()?.createAllDocumentsQuery()
                query?.keys = [groupID]
                liveQuery = query?.asLive()
                liveQuery?.addObserver(self, forKeyPath: "rows", options: .new, context: nil)
                liveQuery?.start()
        }catch{
            let alert = CustomViews.shared.getCustomAlert(errorTitle: GetString.errorTitle.rawValue, errorMessage: GetString.errorWithConnection.rawValue, firstButtonTitle: GetString.errorOKButton.rawValue, secondButtonTitle: nil, firstHandler: nil, secondHandler: nil)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        var adminList = [[UserObject]]()
        var reqList = [UserObject]()
        var memList = [UserObject]()
        
        
        if keyPath == "rows" {
            do{
                if var rows = liveQuery!.rows {
                   self.adminList.removeAll()
                    while let row = rows.nextRow() {
                        if let props = row.document!.properties {
                            if(privateGroup?.adminID == UserDefaults.standard.string(forKey: GetString.userID.rawValue)){
                                if let groupRequestIDs = props["groupRequestIDs"] as? [String]{
                                    let queryForRequests = DBConnection.shared.getDBConnection()?.createAllDocumentsQuery()
                                    queryForRequests?.allDocsMode = CBLAllDocsMode.allDocs
                                    queryForRequests?.keys = groupRequestIDs
                                    let result = try queryForRequests?.run()
                                    while let row = result?.nextRow() {
                                        let requestUser = UserObject(rev: row.documentRevisionID, uid: row.documentID, email: row.document?["email"] as? String, userName: row.document?["username"] as? String, prename: row.document?["prename"] as? String, name: row.document?["name"] as? String)
                                        reqList.append(requestUser)
                                    }
                                }
                            }
                            adminList.append(reqList)
                            if let memberIDs = props["memberIDs"] as? [String]{
                                let queryForMembers = DBConnection.shared.getDBConnection()?.createAllDocumentsQuery()
                                queryForMembers?.allDocsMode = CBLAllDocsMode.allDocs
                                queryForMembers?.keys = memberIDs
                                let result = try queryForMembers?.run()
                                while let row = result?.nextRow() {
                                    let requestUser = UserObject(rev: row.documentRevisionID, uid: row.documentID, email: row.document?["email"] as? String, userName: row.document?["username"] as? String, prename: row.document?["prename"] as? String, name: row.document?["name"] as? String)
                                    memList.append(requestUser)
                                }
                            }
                            adminList.append(memList)
                         }
                        self.adminList = adminList
                        self.membersCollectionView.reloadData()
                    }
                }
            }catch{
                
            }
        }
    }
}
