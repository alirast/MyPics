//
//  Directory.swift
//  MyPics
//
//  Created by n on 14.09.2022.
//

import UIKit

class Directory: NSObject {
    static func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
