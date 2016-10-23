//
//  DataSet.swift
//  Medchat
//
//  Created by Srihari Mohan on 10/20/16.
//  Copyright © 2016 Srihari Mohan. All rights reserved.
//

import Foundation
import UIKit

struct DataSet {
    var points: [String]
    var values: [Double]
    var chartType: String
    var units: String
    
    static let DataKey = "DataKey"
    static let ValueKey = "ValueKey"
    static let TypeKey = "TypeKey"
    static let UnitKey = "UnitKey"
    
    init(dictionary: [String: AnyObject?]) {
        points = dictionary[DataSet.DataKey] as! [String]
        values = dictionary[DataSet.ValueKey] as! [Double]
        chartType = dictionary[DataSet.TypeKey] as! String
        units = dictionary[DataSet.UnitKey] as! String
    }
}