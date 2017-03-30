//
//  UITextViewExtension.swift
//  Houp
//
//  Created by Sebastian on 30.03.17.
//  Copyright © 2017 SP. All rights reserved.
//

import UIKit

extension UITextView {
    
    func centerVertically() {
        let fittingSize = CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let size = sizeThatFits(fittingSize)
        let topOffset = (bounds.size.height - size.height * zoomScale) / 2
        let positiveTopOffset = max(1, topOffset)
        contentOffset.y = -positiveTopOffset
    }
//    override open func alignmentRect(forFrame frame: CGRect) -> CGRect {
//        return CGRect(x: bounds.origin.x + 10, y: bounds.origin.y, width: bounds.width + 10, height: bounds.height)
//    }
    
//    override func editingRect(forBounds bounds: CGRect) -> CGRect {
//        return CGRect(x: bounds.origin.x + 10, y: bounds.origin.y, width: bounds.width + 10, height: bounds.height)
//    }
//    
//    override func textRect(forBounds bounds: CGRect) -> CGRect {
//        return CGRect(x: bounds.origin.x + 10, y: bounds.origin.y, width: bounds.width + 10, height: bounds.height)
//    }

    
}
