//
//  Widget.swift
//  loopback-swift-crud-example
//
//  Created by Kevin Goedecke on 1/6/16.
//  Copyright © 2016 kevingoedecke. All rights reserved.
//

import Foundation
import LoopBack

class Widget : LBPersistedModel {
    var name: String!
    var bars: NSNumber!
    var date: Date!
    var data: NSObject!
}
