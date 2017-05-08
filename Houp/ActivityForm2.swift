//
//  ActivityForm2.swift
//  Houp
//
//  Created by Sebastian on 08.05.17.
//  Copyright © 2017 SP. All rights reserved.
//

import UIKit

class ActivityForm2: UIViewController, UITextFieldDelegate{
    
    var heightOfTextView: NSLayoutConstraint?
    
    let titleHeader = CustomViews.shared.getCustomLabel(text: "Wenn du an den heutigen Tag zurückdenkst...", fontSize: 20, numberOfLines: 2, isBold: true, textAlignment: .center, textColor: .black)
    let question = CustomViews.shared.getCustomLabel(text: "Hast du deine geplante Aktivität durchgeführt?", fontSize: 15, numberOfLines: 2, isBold: true, textAlignment: .center, textColor: .black)
    let container = UIView()
    
    let badImage = CustomViews.shared.getCustomButtonWithImage(imageName: "edit_icon", backgroundColor: .white, imageColor: .black, radius: 20, borderColor: UIColor().getSecondColor())
    let neutralImage = CustomViews.shared.getCustomButtonWithImage(imageName: "edit_icon", backgroundColor: .white, imageColor: .black, radius: 20, borderColor: UIColor().getSecondColor())
    let goodImage = CustomViews.shared.getCustomButtonWithImage(imageName: "edit_icon", backgroundColor: .white, imageColor: .black, radius: 20, borderColor: UIColor().getSecondColor())
    let reason = CustomViews.shared.getCustomTextFieldLarge(placeholder: "Woran lag es deiner Meinung nach?", keyboardType: .default, isPasswordField: false, backgroundColor: UIColor().getSecondColor())
    let continueButton = CustomViews.shared.getCustomButton(title: "Weiter")
    let progressbar = CustomViews.shared.getCustomProgressionView(status: 0.666666, statusText: "2 von 3", progressColor: UIColor().getSecondColor())
    
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
        badImage.addTarget(self, action: #selector(handleSelectImage), for: .touchUpInside)
        neutralImage.addTarget(self, action: #selector(handleSelectImage), for: .touchUpInside)
        goodImage.addTarget(self, action: #selector(handleSelectImage), for: .touchUpInside)
        continueButton.addTarget(self, action: #selector(handleContinue), for: .touchUpInside)
        reason.delegate = self
        view.addGestureRecognizer(gestureRecognizer)
        setUpSubViews()
        addNotificationObserver()
    }
    
    
    func setUpSubViews(){
        titleHeader.addConstraintsWithConstants(top: view.topAnchor, right: view.rightAnchor, bottom: nil, left: view.leftAnchor, centerX: nil, centerY: nil, topConstant: 15, rightConstant: 15, bottomConstant: 0, leftConstant: 15, width: 0, height: 0)
        question.addConstraintsWithConstants(top: titleHeader.bottomAnchor, right: view.rightAnchor, bottom: nil, left: view.leftAnchor, centerX: nil, centerY: nil, topConstant: 75, rightConstant: 15, bottomConstant: 0, leftConstant: 15, width: 0, height: 0)
        container.addConstraintsWithConstants(top: question.bottomAnchor, right: nil, bottom: nil, left: nil, centerX: view.centerXAnchor, centerY: nil, topConstant: 15, rightConstant: 15, bottomConstant: 0, leftConstant: 15, width: 150, height: 40)
        badImage.addConstraintsWithConstants(top: container.topAnchor, right: nil, bottom: container.bottomAnchor, left: container.leftAnchor, centerX: nil, centerY: nil, topConstant: 0, rightConstant: 0, bottomConstant: 0, leftConstant: 0, width: 40, height: 40)
        neutralImage.addConstraintsWithConstants(top: container.topAnchor, right: nil, bottom: container.bottomAnchor, left: badImage.rightAnchor, centerX: nil, centerY: nil, topConstant: 0, rightConstant: 0, bottomConstant: 0, leftConstant: 15, width: 40, height: 40)
        goodImage.addConstraintsWithConstants(top: container.topAnchor, right: nil, bottom: container.bottomAnchor, left: neutralImage.rightAnchor, centerX: nil, centerY: nil, topConstant: 0, rightConstant: 0, bottomConstant: 0, leftConstant: 15, width: 40, height: 40)
        
        reason.translatesAutoresizingMaskIntoConstraints = false
        reason.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 50).isActive = true
        reason.topAnchor.constraint(equalTo: container.bottomAnchor, constant: 12.5).isActive = true
        reason.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -50).isActive = true
        self.heightOfTextView = reason.heightAnchor.constraint(equalToConstant: 0)
        self.heightOfTextView?.isActive = true
        reason.isHidden = true
        
        progressbar.addConstraintsWithConstants(top: reason.bottomAnchor, right: continueButton.rightAnchor, bottom: nil, left: continueButton.leftAnchor, centerX: nil, centerY: nil, topConstant: 12.5, rightConstant: 0, bottomConstant: 0, leftConstant: 0, width: 0, height: 25)
        continueButton.addConstraintsWithConstants(top: progressbar.bottomAnchor, right: view.rightAnchor, bottom: nil, left: view.leftAnchor, centerX: nil, centerY: nil, topConstant: 12.5, rightConstant: 50, bottomConstant: 0, leftConstant: 50, width: 0, height: 40)
    }
    
    func handleContinue(){
        let controller = ActivityForm3()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func handleSelectImage(sender: UIButton){
        for button in container.subviews as! [UIButton] {
            if(button == sender){
                if(sender == self.badImage || sender == self.neutralImage){
                    self.reason.isHidden = false
                    self.heightOfTextView?.isActive = false
                    self.heightOfTextView?.constant = 100
                    self.heightOfTextView?.isActive = true
                  }else{
                    self.reason.isHidden = true
                    self.heightOfTextView?.isActive = false
                    self.heightOfTextView?.constant = 0
                    self.heightOfTextView?.isActive = true
                }
                if(button.backgroundColor == .white){
                    button.backgroundColor = UIColor().getSecondColor()
                }else{
                    button.backgroundColor = .white
                }
            }else{
                button.backgroundColor = .white
            }
        }
    }
    
    private func addNotificationObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(hideKeyboard), name: .UIKeyboardDidHide , object: nil)
    }
    
    func hideKeyboard(){
    self.reason.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.reason.endEditing(true)
        return false
    }
}
