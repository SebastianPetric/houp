//
//  ActivityForm3.swift
//  Houp
//
//  Created by Sebastian on 08.05.17.
//  Copyright © 2017 SP. All rights reserved.
//

import UIKit

class ActivityForm3: UIViewController{
    
    let titleHeader = CustomViews.shared.getCustomLabel(text: "Wenn du an den heutigen Tag zurückdenkst...", fontSize: 20, numberOfLines: 2, isBold: true, textAlignment: .center, textColor: .black)
    let question = CustomViews.shared.getCustomLabel(text: "Wie war dein Wohlbefinden den gesamten Tag über?", fontSize: 15, numberOfLines: 2, isBold: true, textAlignment: .center, textColor: .black)
    let container = UIView()
    let veryBadImage = CustomViews.shared.getCustomButtonWithImage(imageName: "edit_icon", backgroundColor: .white, imageColor: .black, radius: 20, borderColor: UIColor().getSecondColor())
    let badImage = CustomViews.shared.getCustomButtonWithImage(imageName: "edit_icon", backgroundColor: .white, imageColor: .black, radius: 20, borderColor: UIColor().getSecondColor())
    let neutralImage = CustomViews.shared.getCustomButtonWithImage(imageName: "edit_icon", backgroundColor: .white, imageColor: .black, radius: 20, borderColor: UIColor().getSecondColor())
    let goodImage = CustomViews.shared.getCustomButtonWithImage(imageName: "edit_icon", backgroundColor: .white, imageColor: .black, radius: 20, borderColor: UIColor().getSecondColor())
    let veryGoodImage = CustomViews.shared.getCustomButtonWithImage(imageName: "edit_icon", backgroundColor: .white, imageColor: .black, radius: 20, borderColor: UIColor().getSecondColor())
    let continueButton = CustomViews.shared.getCustomButton(title: "Fertig!")
    let progressbar = CustomViews.shared.getCustomProgressionView(status: 1, statusText: "3 von 3", progressColor: UIColor().getSecondColor())
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(titleHeader)
        view.addSubview(question)
        view.addSubview(continueButton)
        view.addSubview(progressbar)
        container.addSubview(veryBadImage)
        container.addSubview(badImage)
        container.addSubview(neutralImage)
        container.addSubview(goodImage)
        container.addSubview(veryGoodImage)
        view.addSubview(container)
        veryBadImage.addTarget(self, action: #selector(handleSelectImage), for: .touchUpInside)
        badImage.addTarget(self, action: #selector(handleSelectImage), for: .touchUpInside)
        neutralImage.addTarget(self, action: #selector(handleSelectImage), for: .touchUpInside)
        goodImage.addTarget(self, action: #selector(handleSelectImage), for: .touchUpInside)
        veryGoodImage.addTarget(self, action: #selector(handleSelectImage), for: .touchUpInside)
        continueButton.addTarget(self, action: #selector(handleContinue), for: .touchUpInside)
        setUpSubViews()
    }
    
    
    func setUpSubViews(){
        titleHeader.addConstraintsWithConstants(top: view.topAnchor, right: view.rightAnchor, bottom: nil, left: view.leftAnchor, centerX: nil, centerY: nil, topConstant: 15, rightConstant: 15, bottomConstant: 0, leftConstant: 15, width: 0, height: 0)
        question.addConstraintsWithConstants(top: titleHeader.bottomAnchor, right: view.rightAnchor, bottom: nil, left: view.leftAnchor, centerX: nil, centerY: nil, topConstant: 75, rightConstant: 15, bottomConstant: 0, leftConstant: 15, width: 0, height: 0)
        container.addConstraintsWithConstants(top: question.bottomAnchor, right: nil, bottom: nil, left: nil, centerX: view.centerXAnchor, centerY: nil, topConstant: 15, rightConstant: 15, bottomConstant: 0, leftConstant: 15, width: 260, height: 40)
        veryBadImage.addConstraintsWithConstants(top: container.topAnchor, right: nil, bottom: container.bottomAnchor, left: container.leftAnchor, centerX: nil, centerY: nil, topConstant: 0, rightConstant: 0, bottomConstant: 0, leftConstant: 0, width: 40, height: 40)
        badImage.addConstraintsWithConstants(top: container.topAnchor, right: nil, bottom: container.bottomAnchor, left: veryBadImage.rightAnchor, centerX: nil, centerY: nil, topConstant: 0, rightConstant: 0, bottomConstant: 0, leftConstant: 15, width: 40, height: 40)
        neutralImage.addConstraintsWithConstants(top: container.topAnchor, right: nil, bottom: container.bottomAnchor, left: badImage.rightAnchor, centerX: nil, centerY: nil, topConstant: 0, rightConstant: 0, bottomConstant: 0, leftConstant: 15, width: 40, height: 40)
        goodImage.addConstraintsWithConstants(top: container.topAnchor, right: nil, bottom: container.bottomAnchor, left: neutralImage.rightAnchor, centerX: nil, centerY: nil, topConstant: 0, rightConstant: 0, bottomConstant: 0, leftConstant: 15, width: 40, height: 40)
        veryGoodImage.addConstraintsWithConstants(top: container.topAnchor, right: nil, bottom: container.bottomAnchor, left: goodImage.rightAnchor, centerX: nil, centerY: nil, topConstant: 0, rightConstant: 0, bottomConstant: 0, leftConstant: 15, width: 40, height: 40)
        progressbar.addConstraintsWithConstants(top: container.bottomAnchor, right: continueButton.rightAnchor, bottom: nil, left: continueButton.leftAnchor, centerX: nil, centerY: nil, topConstant: 25, rightConstant: 0, bottomConstant: 0, leftConstant: 0, width: 0, height: 25)
        continueButton.addConstraintsWithConstants(top: progressbar.bottomAnchor, right: view.rightAnchor, bottom: nil, left: view.leftAnchor, centerX: nil, centerY: nil, topConstant: 12.5, rightConstant: 50, bottomConstant: 0, leftConstant: 50, width: 0, height: 40)
    }
    
    func handleContinue(){
    
    }
    
    func handleSelectImage(sender: UIButton){
        for button in container.subviews as! [UIButton] {
            if(button == sender){
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
}
