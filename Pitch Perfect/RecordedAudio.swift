//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Jeffrey Sulton on 3/8/15.
//  Copyright (c) 2015 notlus. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject {
    var filePathURL: NSURL
    var title: String
    
    init(filePath: NSURL, title: String) {
        filePathURL = filePath
        self.title = title
    }
    
    
}