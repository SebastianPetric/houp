//
//  GroupCommentsController.swift
//  Houp
//
//  Created by Sebastian on 04.05.17.
//  Copyright © 2017 SP. All rights reserved.
//

import UIKit

class GroupCommentsController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate{
    
    let commentsCellID = "commentsCellID"
    let sectionHeaderID = "sectionHeaderID"
    var widthHeightOfImageViews: CGFloat = 20
    var infoHeight: CGFloat = 0
    var liveQuery: CBLLiveQuery?
    var comments: [Comment] = [Comment]()
    var commentsList: [[Comment]] = [[Comment]]()
    var titleNav = ""
    
    deinit {
        liveQuery?.removeObserver(self, forKeyPath: "rows")
    }
    
    var thread: Thread?{
        didSet{
            if let tit = thread?.title{
                if let title = infoContainer.subviews[0] as? UILabel{
                    title.text = tit
                }
            }
            if let message = thread?.message{
                if let tmessage = infoContainer.subviews[1] as? UITextView{
                    tmessage.text = message
                }
            }
            if let username = thread?.userName{
                if let tusername = infoContainer.subviews[2] as? UILabel{
                    tusername.text = username
                }
            }
            if let date = thread?.dateObject{
                if let tdate = infoContainer.subviews[3] as? UILabel{
                    tdate.text = date.getDatePart()
                }
            }
            if let time = thread?.dateObject{
                if let ttime = infoContainer.subviews[4] as? UILabel{
                    ttime.text = time.getTimePart()
                }
            }
        }
    }
    
    lazy var commentsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        let threads = UICollectionView(frame: .zero, collectionViewLayout: layout)
        threads.backgroundColor = .white
        threads.dataSource = self
        threads.delegate = self
        return threads
    }()
    
    
    lazy var infoContainer: UIView = {
        
        let username = CustomViews.shared.getCustomLabel(text: "Username", fontSize: 12, numberOfLines: 1, isBold: false, textAlignment: .left, textColor: nil)
        let date = CustomViews.shared.getCustomLabel(text: "03.02.2017", fontSize: 12, numberOfLines: 1, isBold: false, textAlignment: .right, textColor: nil)
        let seperator = CustomViews.shared.getCustomSeperator(color: .black)
        let time = CustomViews.shared.getCustomLabel(text: "19:34", fontSize: 12, numberOfLines: 1, isBold: false, textAlignment: .right, textColor: nil)
        let title = CustomViews.shared.getCustomLabel(text: "Hallo leute, also wie gesagt ich hätte folgendes Problem. Und zwar geht es dar", fontSize: 14, numberOfLines: 2, isBold: true, textAlignment: .left, textColor: nil)
        let message = CustomViews.shared.getCustomTextView(text: "Hallo leute, also wie gesagt ich hätte folgendes Problem. Und zwar geht es darum, dass ich nciht weiß was ich machen soll", fontSize: 12, textAlignment: .left, textColor: .black, backGroundColor: UIColor().getThirdColor())
        let editButton = CustomViews.shared.getCustomButtonWithImage(imageName: "edit_icon", backgroundColor: UIColor().getThirdColor(), imageColor: .black, radius: nil, borderColor: UIColor().getThirdColor())
        let seperatorInfo = CustomViews.shared.getCustomSeperator(color: UIColor().getThirdColor())
        
        let view = UIView()
        view.addSubview(title)
        view.addSubview(message)
        view.addSubview(username)
        view.addSubview(date)
        view.addSubview(time)
        view.addSubview(seperator)
        view.addSubview(editButton)
        view.addSubview(seperatorInfo)
        view.backgroundColor = UIColor().getThirdColor()
        
        username.addConstraintsWithConstants(top: view.topAnchor, right: nil, bottom: nil, left: view.leftAnchor, centerX: nil, centerY: nil, topConstant: 5, rightConstant: 0, bottomConstant: 0, leftConstant: 15, width: 100, height: 20)
        editButton.addConstraintsWithConstants(top: view.topAnchor, right: view.rightAnchor, bottom: nil, left: nil, centerX: nil, centerY: nil, topConstant: 5, rightConstant: 15, bottomConstant: 0, leftConstant: 0, width: 20, height: 20)
        time.addConstraintsWithConstants(top: view.topAnchor, right: editButton.leftAnchor, bottom: nil, left: nil, centerX: nil, centerY: nil, topConstant: 5, rightConstant: 5, bottomConstant: 0, leftConstant: 0, width: 35, height: 20)
        seperator.addConstraintsWithConstants(top: view.topAnchor, right: time.leftAnchor, bottom: nil, left: nil, centerX: nil, centerY: nil, topConstant: 5, rightConstant: 5, bottomConstant: 0, leftConstant: 0, width: 1, height: 20)
        date.addConstraintsWithConstants(top: view.topAnchor, right: seperator.leftAnchor, bottom: nil, left: nil, centerX: nil, centerY: nil, topConstant: 5, rightConstant: 5, bottomConstant: 0, leftConstant: 0, width: 70, height: 20)
        title.addConstraintsWithConstants(top: username.bottomAnchor, right: view.rightAnchor, bottom: nil, left: view.leftAnchor, centerX: nil, centerY: nil, topConstant: 5, rightConstant: 15, bottomConstant: 0, leftConstant: 15, width: 0, height: 40)
        message.addConstraintsWithConstants(top: title.bottomAnchor, right: view.rightAnchor, bottom: nil, left: view.leftAnchor, centerX: nil, centerY: nil, topConstant: 5, rightConstant: 15, bottomConstant: 0, leftConstant: 15, width: 0, height: 0)
        seperatorInfo.addConstraintsWithConstants(top: nil, right: view.rightAnchor, bottom: view.bottomAnchor, left: view.leftAnchor, centerX: nil, centerY: nil, topConstant: 0, rightConstant: 0, bottomConstant: 0, leftConstant: 0, width: 0, height: 1)
        
        return view
    }()
    
    let writeCommentContainer = CustomViews.shared.getCustomWriteCommentContainer()
    
    lazy var gestureRecognizer: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        return recognizer
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.titleNav
        if(liveQuery == nil){
            getTopicComments(threadID: (self.thread?.tid)!)
        }
        
        commentsCollectionView.register(PrivateGroupCommentsCell.self, forCellWithReuseIdentifier: commentsCellID)
        let sendButton = writeCommentContainer.subviews[1] as! UIButton
        sendButton.addTarget(self, action: #selector(handleSendComment), for: .touchUpInside)
        let commentTextField = writeCommentContainer.subviews[0] as! UITextField
        commentTextField.delegate = self
        view.addSubview(infoContainer)
        view.addSubview(commentsCollectionView)
        self.commentsCollectionView.register(CommentsSectionHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: sectionHeaderID)
        view.addSubview(writeCommentContainer)
        view.addGestureRecognizer(gestureRecognizer)
        
        addNotificationObserver()
        
        let approximateWidth = view.frame.width - 30
        let sizeTitleMessage = CGSize(width: approximateWidth, height: 1000)
        let attributesMessage = [NSFontAttributeName: UIFont.systemFont(ofSize: 12)]
        let message = infoContainer.subviews[1] as! UITextView
        let estimateMessageHeight = NSString(string: message.text!).boundingRect(with: sizeTitleMessage, options: .usesLineFragmentOrigin, attributes: attributesMessage, context: nil)
        let heightMessage = estimateMessageHeight.height + 89
        self.infoHeight += heightMessage + 45
        setUpSubViews()
    }
    
    func setUpSubViews(){
        infoContainer.addConstraintsWithConstants(top: view.topAnchor, right: view.rightAnchor, bottom: nil, left: view.leftAnchor, centerX: nil, centerY: nil, topConstant: 0, rightConstant: 0, bottomConstant: 0, leftConstant: 0, width: 0, height: self.infoHeight)
        writeCommentContainer.addConstraintsWithConstants(top: nil, right: view.rightAnchor, bottom: view.bottomAnchor, left: view.leftAnchor, centerX: nil, centerY: nil, topConstant: 0, rightConstant: 0, bottomConstant: 0, leftConstant: 0, width: view.frame.width, height: 40)
        commentsCollectionView.addConstraintsWithConstants(top: infoContainer.bottomAnchor, right: view.rightAnchor, bottom: view.bottomAnchor, left: view.leftAnchor, centerX: nil, centerY: nil, topConstant: 0, rightConstant: 0, bottomConstant: 0, leftConstant: 0, width: 0, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let string = self.comments[indexPath.row].message
//        let approximateWidth = view.frame.width - 55
//        let sizeTitleMessage = CGSize(width: approximateWidth, height: 1000)
//        let attributesMessage = [NSFontAttributeName: UIFont.systemFont(ofSize: 12)]
//        let estimateMessageHeight = NSString(string: string!).boundingRect(with: sizeTitleMessage, options: .usesLineFragmentOrigin, attributes: attributesMessage, context: nil)
//        let heightMessage = estimateMessageHeight.height + 66
//        return CGSize(width: view.frame.width, height: heightMessage)
        return CGSize(width: view.frame.width, height: 75)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: commentsCellID, for: indexPath) as! PrivateGroupCommentsCell
        cell.comment = self.commentsList[indexPath.section][indexPath.row]
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return self.comments.count
//    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var header: String = ""
        if(indexPath.section == 0){
            header = "Top Antwort"
        }else{
            header = "Kommentare"
        }
        let secheader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: sectionHeaderID, for: indexPath) as! CommentsSectionHeader
        secheader.sectionHeader.text = header
        return secheader
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return commentsList.count == 0 ? 0 : commentsList[section].count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.writeCommentContainer.frame = CGRect(x: 0, y: self.view.frame.height, width: self.writeCommentContainer.frame.width, height: self.writeCommentContainer.frame.height)
        }, completion: nil)
    }
    
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        UIView.animate(withDuration: 0.5, delay: 1.5, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.writeCommentContainer.frame = CGRect(x: 0, y: self.view.frame.height - 40, width: self.writeCommentContainer.frame.width, height: self.writeCommentContainer.frame.height)
        }, completion: nil)
    }
    
    private func addNotificationObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(showKeyboard), name: .UIKeyboardWillShow , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hideKeyboard), name: .UIKeyboardDidHide , object: nil)
    }
    
    func showKeyboard(){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            //Bewegt view um 64px nach oben (Navigationbar), wegen istranslusent = true
            self.writeCommentContainer.frame = CGRect(x: 0, y: self.view.frame.height - 249, width: self.writeCommentContainer.frame.width, height: self.writeCommentContainer.frame.height)
        }, completion: nil)
    }
    
    func hideKeyboard(){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.endEditing(true)
        }, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}

