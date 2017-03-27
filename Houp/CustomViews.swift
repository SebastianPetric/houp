//
//  CustomProgressionView.swift
//  Houp
//
//  Created by Sebastian on 21.03.17.
//  Copyright © 2017 SP. All rights reserved.
//

import UIKit

class CustomViews{

    func getCustomTextField(placeholder: String, isPasswordField: Bool) -> CustomTextField {
            let customTextField = CustomTextField()
            customTextField.backgroundColor = UIColor(red: 41, green: 192, blue: 232, alphaValue: 1)
            customTextField.textColor = .white
            customTextField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSForegroundColorAttributeName: UIColor.white])
            customTextField.layer.cornerRadius = 5
            customTextField.isSecureTextEntry = isPasswordField
            customTextField.clearButtonMode = .always
            return customTextField
    }
    
    func getCustomButton(title: String) -> UIButton{
            let loginButton = UIButton(type: .system)
            loginButton.setTitle(title, for: .normal)
            loginButton.layer.cornerRadius = 5
            loginButton.setTitleColor(UIColor(red: 41, green: 192, blue: 232, alphaValue: 1), for: .normal)
            loginButton.layer.borderColor = UIColor(red: 41, green: 192, blue: 232, alphaValue: 1).cgColor
            loginButton.layer.borderWidth = 1
            loginButton.tintColor = .black
            return loginButton
    }
    
    func getBigRoundImage(name: String, cornerRadius: CGFloat, isUserInteractionEnabled: Bool) -> UIImageView{
            let bigRoundImage = UIImageView()
            bigRoundImage.image = UIImage(named: name)
            bigRoundImage.contentMode = .scaleAspectFit
            bigRoundImage.clipsToBounds = true
            bigRoundImage.backgroundColor = .white
            bigRoundImage.layer.cornerRadius = cornerRadius
            bigRoundImage.layer.borderColor = UIColor(red: 229, green: 231, blue: 235, alphaValue: 1).cgColor
            bigRoundImage.layer.borderWidth = 1
            bigRoundImage.isUserInteractionEnabled = isUserInteractionEnabled
            bigRoundImage.translatesAutoresizingMaskIntoConstraints = false
            return bigRoundImage
    }
    
    func getCustomProgressionView(status: Float, statusText: String) -> UIView {
    
            let progresion = UIProgressView()
            progresion.progressTintColor = UIColor(red: 41, green: 192, blue: 232, alphaValue: 1)
            progresion.trackTintColor = .white
            progresion.layer.borderColor = UIColor().getTextViewBorderColor()
            progresion.layer.borderWidth = 1
            progresion.layer.cornerRadius = 3
            progresion.progress = status
            
            let progressionViewText = UITextView()
            progressionViewText.text = statusText
            progressionViewText.font = UIFont.systemFont(ofSize: 10)
            progressionViewText.textAlignment = .center
            progressionViewText.textColor = .black
            progressionViewText.isEditable = false
            
            let container = UIView()
            container.addSubview(progresion)
            container.addSubview(progressionViewText)
            progresion.addConstraintsWithConstants(top: container.topAnchor, right: container.rightAnchor, bottom: nil, left: container.leftAnchor, centerX: container.centerXAnchor, centerY: nil, topConstant: 0, rightConstant: 0, bottomConstant: 0, leftConstant: 0, width: 0, height: 5)
            progressionViewText.addConstraintsWithConstants(top: progresion.bottomAnchor, right: container.rightAnchor, bottom: nil, left: nil, centerX: nil, centerY: nil, topConstant: 0, rightConstant: 0, bottomConstant: 0, leftConstant: 0, width: 50, height: 20)
            return container
    }
}
