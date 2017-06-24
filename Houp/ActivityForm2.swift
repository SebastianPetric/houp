//
//  ActivityForm2.swift
//  Houp
//
//  Created by Sebastian on 08.05.17.
//  Copyright © 2017 SP. All rights reserved.
//

import UIKit

class ActivityForm2: UIViewController, UITextViewDelegate{
    
    var heightOfTextView: NSLayoutConstraint?
    var heightOfShareContainer: NSLayoutConstraint?
    var activity: Activity?
    var activityWeekCollection: ActivityWeekCollection?
    
    
    let titleHeader = CustomViews.shared.getCustomLabel(text: "Wenn du an den heutigen Tag zurückdenkst...", fontSize: 20, numberOfLines: 2, isBold: true, textAlignment: .center, textColor: .black)
    let question = CustomViews.shared.getCustomLabel(text: "Hast du deine geplante Aktivität durchgeführt?", fontSize: 15, numberOfLines: 2, isBold: true, textAlignment: .center, textColor: .black)
    let container = UIView()
    let badImage = CustomViews.shared.getCustomButtonWithImage(imageName: "thumb1_icon", backgroundColor: .white, imageColor: .black, radius: 20, borderColor: .black)
    let neutralImage = CustomViews.shared.getCustomButtonWithImage(imageName: "thumb2_icon", backgroundColor: .white, imageColor: .black, radius: 20, borderColor: .black)
    let goodImage = CustomViews.shared.getCustomButtonWithImage(imageName: "thumb3_icon", backgroundColor: .white, imageColor: .black, radius: 20, borderColor: .black)
    let reason = CustomViews.shared.getCustomTextViewContainer(text: "", fontSize: 12, isBold: true, textAlignment: .left, textColor: .black, borderColor: .white, backgroundColor: UIColor().getFourthColor())
    let continueButton = CustomViews.shared.getCustomButton(title: "Weiter", borderColor: UIColor().getLightGreyColor(), textColor: UIColor().getLightGreyColor())
    let progressbar = CustomViews.shared.getCustomProgressionView(status: 0.666666, statusText: "2 von 3", progressColor: UIColor().getFourthColor())
    let reasonHeader = CustomViews.shared.getCustomLabel(text: "Willst du noch etwas dazu sagen?", fontSize: 12, numberOfLines: 2, isBold: true, textAlignment: .left, textColor: .black)
    let extraCommentSwitch: UISwitch = {
        let switchButton = UISwitch()
        switchButton.tintColor = UIColor().getFourthColor()
        switchButton.onTintColor = UIColor().getFourthColor()
        switchButton.isOn = false
        return switchButton
    }()
    let shareContainer = UIView()
    let shareHeader = CustomViews.shared.getCustomLabel(text: "Super! Willst du das mit deinen Gruppen teilen?", fontSize: 12, numberOfLines: 2, isBold: true, textAlignment: .left, textColor: .black)
    let shareSwitch: UISwitch = {
        let switchButton = UISwitch()
        switchButton.tintColor = UIColor().getFourthColor()
        switchButton.onTintColor = UIColor().getFourthColor()
        switchButton.isOn = false
        return switchButton
    }()

    lazy var gestureRecognizer: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        return recognizer
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Gleich geschafft!"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        view.backgroundColor = .white
        view.addSubview(titleHeader)
        view.addSubview(question)
        view.addSubview(continueButton)
        view.addSubview(progressbar)
        view.addSubview(reason)
        container.addSubview(badImage)
        container.addSubview(neutralImage)
        container.addSubview(goodImage)
        view.addSubview(container)
        view.addSubview(extraCommentSwitch)
        view.addSubview(reasonHeader)
        shareContainer.addSubview(shareHeader)
        shareContainer.addSubview(shareSwitch)
        view.addSubview(shareContainer)
        badImage.addTarget(self, action: #selector(handleSelectImage), for: .touchUpInside)
        neutralImage.addTarget(self, action: #selector(handleSelectImage), for: .touchUpInside)
        goodImage.addTarget(self, action: #selector(handleSelectImage), for: .touchUpInside)
        continueButton.addTarget(self, action: #selector(handleContinue), for: .touchUpInside)
        extraCommentSwitch.addTarget(self, action: #selector(handleExtraCommentSwitch), for: .touchUpInside)
        reason.delegate = self
        view.addGestureRecognizer(gestureRecognizer)
         addNotificationObserver()
        setUpSubViews()
    }
    
    
    func setUpSubViews(){
        titleHeader.addConstraintsWithConstants(top: view.topAnchor, right: view.rightAnchor, bottom: nil, left: view.leftAnchor, centerX: nil, centerY: nil, topConstant: 15, rightConstant: 15, bottomConstant: 0, leftConstant: 15, width: 0, height: 0)
        question.addConstraintsWithConstants(top: titleHeader.bottomAnchor, right: view.rightAnchor, bottom: nil, left: view.leftAnchor, centerX: nil, centerY: nil, topConstant: 75, rightConstant: 15, bottomConstant: 0, leftConstant: 15, width: 0, height: 0)
        container.addConstraintsWithConstants(top: question.bottomAnchor, right: nil, bottom: nil, left: nil, centerX: view.centerXAnchor, centerY: nil, topConstant: 15, rightConstant: 15, bottomConstant: 0, leftConstant: 15, width: 150, height: 40)
        badImage.addConstraintsWithConstants(top: container.topAnchor, right: nil, bottom: container.bottomAnchor, left: container.leftAnchor, centerX: nil, centerY: nil, topConstant: 0, rightConstant: 0, bottomConstant: 0, leftConstant: 0, width: 40, height: 40)
        neutralImage.addConstraintsWithConstants(top: container.topAnchor, right: nil, bottom: container.bottomAnchor, left: badImage.rightAnchor, centerX: nil, centerY: nil, topConstant: 0, rightConstant: 0, bottomConstant: 0, leftConstant: 15, width: 40, height: 40)
        goodImage.addConstraintsWithConstants(top: container.topAnchor, right: nil, bottom: container.bottomAnchor, left: neutralImage.rightAnchor, centerX: nil, centerY: nil, topConstant: 0, rightConstant: 0, bottomConstant: 0, leftConstant: 15, width: 40, height: 40)
        
        shareContainer.translatesAutoresizingMaskIntoConstraints = false
        shareContainer.topAnchor.constraint(equalTo: container.bottomAnchor, constant: 12.5).isActive = true
        shareContainer.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -50).isActive = true
        shareContainer.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 50).isActive = true
        self.heightOfShareContainer = shareContainer.heightAnchor.constraint(equalToConstant: 0)
        self.heightOfShareContainer?.isActive = true
        shareContainer.isHidden = true
        
        shareSwitch.addConstraintsWithConstants(top: nil, right: shareContainer.rightAnchor, bottom: nil, left: nil, centerX: nil, centerY: shareContainer.centerYAnchor, topConstant: 12.5, rightConstant: 0, bottomConstant: 0, leftConstant: 0, width: 50, height: 0)
        shareHeader.addConstraintsWithConstants(top: nil, right: shareSwitch.leftAnchor, bottom: nil, left: shareContainer.leftAnchor, centerX: nil, centerY: shareSwitch.centerYAnchor, topConstant: 12.5, rightConstant: 0, bottomConstant: 0, leftConstant: 0, width: 0, height: 0)
        
        reasonHeader.addConstraintsWithConstants(top: nil, right: extraCommentSwitch.leftAnchor, bottom: nil, left: continueButton.leftAnchor, centerX: nil, centerY: extraCommentSwitch.centerYAnchor, topConstant: 12.5, rightConstant: 0, bottomConstant: 0, leftConstant: 0, width: 0, height: 0)
        extraCommentSwitch.addConstraintsWithConstants(top: shareContainer.bottomAnchor, right: continueButton.rightAnchor, bottom: nil, left: nil, centerX: nil, centerY: nil, topConstant: 12.5, rightConstant: 0, bottomConstant: 0, leftConstant: 0, width: 50, height: 0)
        
        reason.translatesAutoresizingMaskIntoConstraints = false
        reason.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 50).isActive = true
        reason.topAnchor.constraint(equalTo: extraCommentSwitch.bottomAnchor, constant: 12.5).isActive = true
        reason.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -50).isActive = true
        self.heightOfTextView = reason.heightAnchor.constraint(equalToConstant: 0)
        self.heightOfTextView?.isActive = true
        reason.isHidden = true
        
        progressbar.addConstraintsWithConstants(top: reason.bottomAnchor, right: continueButton.rightAnchor, bottom: nil, left: continueButton.leftAnchor, centerX: nil, centerY: nil, topConstant: 12.5, rightConstant: 0, bottomConstant: 0, leftConstant: 0, width: 0, height: 25)
        continueButton.addConstraintsWithConstants(top: progressbar.bottomAnchor, right: view.rightAnchor, bottom: nil, left: view.leftAnchor, centerX: nil, centerY: nil, topConstant: 12.5, rightConstant: 50, bottomConstant: 0, leftConstant: 50, width: 0, height: 40)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n"){
            self.view.endEditing(true)
            return false
        }
        return true
    }

    private func addNotificationObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(showKeyboard), name: .UIKeyboardWillShow , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hideKeyboard), name: .UIKeyboardDidHide , object: nil)
    }
    
    func showKeyboard(){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            //Bewegt view um 64px nach oben (Navigationbar), wegen istranslusent = true
            self.view.frame = CGRect(x: 0, y: -25, width: self.view.frame.width, height: self.view.frame.height)
        }, completion: nil)
    }
    
    func hideKeyboard(){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.endEditing(true)
            self.view.frame = CGRect(x: 0, y: 64, width: self.view.frame.width, height: self.view.frame.height)
        }, completion: nil)
    }
}
