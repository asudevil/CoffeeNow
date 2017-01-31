//
//  Extensions.swift
//  CoffeeNow
//
//  Created by admin on 10/30/16.
//  Copyright © 2016 CodeWithFelix. All rights reserved.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    
    func loadImageUsingCacheWithUrlString(urlString: String) {
        
        self.image = nil
        
        // check for image first
        if let cachedImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = cachedImage
            return
        }
        
        //otherwise, fire off a new download
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            
            if error != nil {
                print(error!)
                return
            }
            
            DispatchQueue.main.async {
                
                if let downloadedImage = UIImage(data: data!) {
                    imageCache.setObject(downloadedImage, forKey: urlString as AnyObject)
                    self.image = downloadedImage
                }
            }
            
        }).resume()
    }    
}

extension UINavigationController {
    func pop(animated: Bool) {
        _ = self.popViewController(animated: animated)
    }
    
    func popToRoot(animated: Bool) {
        _ = self.popToRootViewController(animated: animated)
    }
}
