//
//  Validation.swift
//  Houp
//
//  Created by Sebastian on 10.04.17.
//  Copyright © 2017 SP. All rights reserved.
//

import Foundation


class Validation{


    static var shared: Validation = Validation()
    
    func generateSecretGroupID() -> String {
        
        let length = 6
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var secretID = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            secretID += NSString(characters: &nextChar, length: 1) as String
        }
        return secretID
    }
}
