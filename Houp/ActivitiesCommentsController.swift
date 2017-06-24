import UIKit

class ActivitiesCommentsController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate{
    
    let commentsCellID = "commentsCellID"
    var widthHeightOfImageViews: CGFloat = 20
    var infoHeight: CGFloat = 0
    var liveQuery: CBLLiveQuery?
    var liveQueryActivity: CBLLiveQuery?
    var upvoteButtonInfo: UIButton?
    var upvoteLabelInfo: UILabel?
    var comments: [Comment] = [Comment]()
    var titleNav = ""
    var thirdColor = UIColor().getFourthColor()
    
    deinit {
        liveQuery?.removeObserver(self, forKeyPath: "rows")
//        liveQueryActivity?.removeObserver(self, forKeyPath: "rows")
    }
    
    
    var activityObject: Activity?{
        didSet{
            if let tit = activityObject?.activity{
                if let title = infoContainer.subviews[0] as? UILabel{
                    title.text = tit
                }
            }
            if let mess = activityObject?.activityText{
                if let tmessage = infoContainer.subviews[1] as? UITextView{
                    tmessage.text = mess
                }
            }
            if let user = activityObject?.userName{
                if let tusername = infoContainer.subviews[2] as? UILabel{
                    tusername.text = user
                }
            }
            if let timeO = activityObject?.timeObject{
                if let ttime = infoContainer.subviews[4] as? UILabel{
                    ttime.text = timeO.getTimePart()
                }
            }
            if let dateO = activityObject?.dateObject{
                if let tdate = infoContainer.subviews[3] as? UILabel{
                    tdate.text = dateO.getDatePart()
                }
            }
            if let likeIDs = activityObject?.likeIDs{
                if let userID = UserDefaults.standard.string(forKey: GetString.userID.rawValue){
                    if let button = (self.infoContainer.subviews[7] as? UIButton){
                        if(likeIDs.contains(userID)){
                            button.tintColor = UIColor().getMainColor()
                        }else{
                            button.tintColor = .black
                        }
                    }
                }
            }
            if let likes = activityObject?.likeIDs?.count{
                if let upvoteLabel = infoContainer.subviews[8] as? UILabel{
                    upvoteLabel.text = "\(likes)"
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
        let message = CustomViews.shared.getCustomTextView(text: "Hallo leute, also wie gesagt ich hätte folgendes Problem. Und zwar geht es darum, dass ich nciht weiß was ich machen soll. Bla bla bla bla bla bla bla fwhnegriopjhg ergijerpgjerpgjerg jergpijgrepojgregre gerjpoergjperjgreg grpoerjgpoerjgpojerg mergpojpoergjperjt ich hätte folgendes Problem. Und zwar geht es darum, dass ich nciht weiß was ich machen soll. Bla bla bla bla bla bla bla fwhnegriopjhg ergijerpgjerpgjerg jergpijgrepojgregre gerjpoergjperjgreg grpoerjgpoerjgpojerg mergpojpoergjper ättee folgendes Problem. Und zwar geht es darum, dass ich nciht weiß was ich machen soll. Bla bla bla bla bla bla bla fwhnegriopjhg ergijerpgjerpgjerg jergpijgrepojgregre gerjpoergjperjgreg grpoerjgpoerjgpojerg mergpojpoergjperjt", fontSize: 12, textAlignment: .left, textColor: .black, backGroundColor: UIColor().getFourthColor())
        //let editButton = CustomViews.shared.getCustomButtonWithImage(imageName: "edit_icon", backgroundColor: UIColor().getThirdColor(), imageColor: .black, radius: nil, borderColor: UIColor().getThirdColor())
        let seperatorInfo = CustomViews.shared.getCustomSeperator(color: UIColor().getFourthColor())
        let upvoteLabel = CustomViews.shared.getCustomLabel(text: "122", fontSize: 12, numberOfLines: 1, isBold: true, textAlignment: .center, textColor: .black)
        let upvoteButton = CustomViews.shared.getCustomButtonWithImage(imageName: "upvote_icon", backgroundColor: UIColor().getFourthColor(), imageColor: .black, radius: nil, borderColor: UIColor().getFourthColor())
        
        let view = UIView()
        view.addSubview(title)
        view.addSubview(message)
        view.addSubview(username)
        view.addSubview(date)
        view.addSubview(time)
        view.addSubview(seperator)
        //view.addSubview(editButton)
        view.addSubview(seperatorInfo)
        view.addSubview(upvoteButton)
        view.addSubview(upvoteLabel)
        view.backgroundColor = UIColor().getFourthColor()
        
        username.addConstraintsWithConstants(top: view.topAnchor, right: nil, bottom: nil, left: view.leftAnchor, centerX: nil, centerY: nil, topConstant: 5, rightConstant: 0, bottomConstant: 0, leftConstant: 15, width: 100, height: 20)
        //editButton.addConstraintsWithConstants(top: view.topAnchor, right: view.rightAnchor, bottom: nil, left: nil, centerX: nil, centerY: nil, topConstant: 5, rightConstant: 15, bottomConstant: 0, leftConstant: 0, width: 20, height: 20)
        time.addConstraintsWithConstants(top: view.topAnchor, right: view.rightAnchor, bottom: nil, left: nil, centerX: nil, centerY: nil, topConstant: 5, rightConstant: 15, bottomConstant: 0, leftConstant: 0, width: 35, height: 20)
        seperator.addConstraintsWithConstants(top: view.topAnchor, right: time.leftAnchor, bottom: nil, left: nil, centerX: nil, centerY: nil, topConstant: 5, rightConstant: 5, bottomConstant: 0, leftConstant: 0, width: 1, height: 20)
        date.addConstraintsWithConstants(top: view.topAnchor, right: seperator.leftAnchor, bottom: nil, left: nil, centerX: nil, centerY: nil, topConstant: 5, rightConstant: 5, bottomConstant: 0, leftConstant: 0, width: 70, height: 20)
        title.addConstraintsWithConstants(top: username.bottomAnchor, right: view.rightAnchor, bottom: nil, left: view.leftAnchor, centerX: nil, centerY: nil, topConstant: 5, rightConstant: 15, bottomConstant: 0, leftConstant: 15, width: 0, height: 40)
        upvoteButton.addConstraintsWithConstants(top: nil, right: view.rightAnchor, bottom: nil, left: nil, centerX: nil, centerY: view.centerYAnchor, topConstant: 5, rightConstant: 15, bottomConstant: 0, leftConstant: 0, width: 20, height: 20)
        upvoteLabel.addConstraintsWithConstants(top: upvoteButton.bottomAnchor, right: view.rightAnchor, bottom: nil, left: nil, centerX: nil, centerY: nil, topConstant: 0, rightConstant: 12.5, bottomConstant: 0, leftConstant: 0, width: 25, height: 20)
        message.addConstraintsWithConstants(top: title.bottomAnchor, right: upvoteButton.leftAnchor, bottom: nil, left: view.leftAnchor, centerX: nil, centerY: nil, topConstant: 5, rightConstant: 15, bottomConstant: 0, leftConstant: 15, width: 0, height: 0)
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
            getTopicComments(activityID: (self.activityObject?.aid)!)
        }
        
        TempStorageAndCompare.shared.activityWithCommentsDelegate = self
        
//        if(liveQueryActivity == nil){
//            getTopicActivity(activityID: (self.activityObject?.aid)!)
//        }
        
        commentsCollectionView.register(ActivitiesCommentsCell.self, forCellWithReuseIdentifier: commentsCellID)
        let sendButton = writeCommentContainer.subviews[1] as! UIButton
        sendButton.addTarget(self, action: #selector(handleSendComment), for: .touchUpInside)
        let commentTextField = writeCommentContainer.subviews[0] as! UITextField
        commentTextField.delegate = self
        view.addSubview(infoContainer)
        view.addSubview(commentsCollectionView)
        view.addSubview(writeCommentContainer)
        view.addGestureRecognizer(gestureRecognizer)
        self.upvoteLabelInfo = (self.infoContainer.subviews[8] as! UILabel)
        self.upvoteButtonInfo = (self.infoContainer.subviews[7] as! UIButton)
        self.upvoteButtonInfo?.addTarget(self, action: #selector(handleUpvote), for: .touchUpInside)
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
    
    
    func handleIfUserAlreadyLikedThis(){
        if let userID = UserDefaults.standard.string(forKey: GetString.userID.rawValue){
            if((self.activityObject?.likeIDs?.contains(userID))!){
                self.upvoteButtonInfo?.tintColor = UIColor().getSecondColor()
            }else{
                self.upvoteButtonInfo?.tintColor = .black
            }
        }
    }
    
    func setUpSubViews(){
        infoContainer.addConstraintsWithConstants(top: view.topAnchor, right: view.rightAnchor, bottom: nil, left: view.leftAnchor, centerX: nil, centerY: nil, topConstant: 0, rightConstant: 0, bottomConstant: 0, leftConstant: 0, width: 0, height: self.infoHeight)
        writeCommentContainer.addConstraintsWithConstants(top: nil, right: view.rightAnchor, bottom: view.bottomAnchor, left: view.leftAnchor, centerX: nil, centerY: nil, topConstant: 0, rightConstant: 0, bottomConstant: 0, leftConstant: 0, width: view.frame.width, height: 40)
        commentsCollectionView.addConstraintsWithConstants(top: infoContainer.bottomAnchor, right: view.rightAnchor, bottom: view.bottomAnchor, left: view.leftAnchor, centerX: nil, centerY: nil, topConstant: 0, rightConstant: 0, bottomConstant: 0, leftConstant: 0, width: 0, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let string = self.comments[indexPath.row].message
        let approximateWidth = view.frame.width - 55
        let sizeTitleMessage = CGSize(width: approximateWidth, height: 1000)
        let attributesMessage = [NSFontAttributeName: UIFont.systemFont(ofSize: 12)]
        let estimateMessageHeight = NSString(string: string!).boundingRect(with: sizeTitleMessage, options: .usesLineFragmentOrigin, attributes: attributesMessage, context: nil)
        let heightMessage = estimateMessageHeight.height + 66
        return CGSize(width: view.frame.width, height: heightMessage)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: commentsCellID, for: indexPath) as! ActivitiesCommentsCell
        cell.comment = self.comments[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.comments.count
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

