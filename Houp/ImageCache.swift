//
//  ImageCache.swift
//  Houp
//
//  Created by Sebastian on 23.03.17.
//  Copyright © 2017 SP. All rights reserved.
//

import UIKit

class HoupImageCache{

    static var shared: HoupImageCache = HoupImageCache()
    
    let cache = NSCache<AnyObject, AnyObject>()
    
    func getImageFromCache(userID: String) -> UIImage?{
        
        let url : NSString = "\(userID)_profileImage.jpeg" as NSString
        let urlStr : NSString = url.addingPercentEscapes(using: String.Encoding.utf8.rawValue)! as NSString
        let searchURL : NSURL = NSURL(string: urlStr as String)!

        if let image = cache.object(forKey: searchURL) as? UIImage{
            return image
        }else{
            return nil
        }
    }
    
    func saveImageToCache(userID: String, profile_image: UIImage){
        
        let url : NSString = "\(userID)_profileImage.jpeg" as NSString
        let urlStr : NSString = url.addingPercentEscapes(using: String.Encoding.utf8.rawValue)! as NSString
        let searchURL : NSURL = NSURL(string: urlStr as String)!
        
        cache.setObject(profile_image, forKey: searchURL)
    }
}
