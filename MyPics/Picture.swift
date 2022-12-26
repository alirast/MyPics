//
//  Picture.swift
//  MyPics
//
//  Created by n on 14.09.2022.
//

import UIKit

class Picture: NSObject, Codable {
    var caption: String
    var image: String
    
    init(caption: String, image: String) {
        self.caption = caption
        self.image = image
    }
    
    static func recievePicFromUserDefaults() -> [Picture] {
        let defaults = UserDefaults.standard
        if let savedPics = defaults.object(forKey: "pictures") as? Data {
            if let decodedPics = try? JSONDecoder().decode([Picture].self, from: savedPics) {
                return decodedPics
            }
        }
        return [Picture]()
    }
    
    static func savePicsToUserDefaults(pictures: [Picture]) {
        let jsonEncoder = JSONEncoder()
        if let savedPics = try? jsonEncoder.encode(pictures) {
            let defaults = UserDefaults.standard
            defaults.set(savedPics, forKey: "pictures")
        }
    }
}
