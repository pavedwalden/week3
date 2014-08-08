//
//  FilterBundle.swift
//  Image'n
//
//  Created by Alex on 8/7/14.
//  Copyright (c) 2014 Alex Rice. All rights reserved.
//

import UIKit

class FilterBundle: NSObject {
    
    var filterNames : String
    
    init(filterName: String) {
        self.filterNames = filterName
    }
    
    func getThumbnail() -> UIImage {
        var thumbnail = UIImage(named: "violentj.jpg")
        return thumbnail
    }
}
