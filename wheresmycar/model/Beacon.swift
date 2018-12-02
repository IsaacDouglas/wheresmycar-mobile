//
//  Beacon.swift
//  wheresmycar
//
//  Created by Isaac Douglas on 02/12/18.
//  Copyright © 2018 Isaac Douglas. All rights reserved.
//

import Foundation

class Beacon: Codable {
    var _id: String!
    var uuid: String!
    var minor: Int!
    var major: Int!
    var rssi: Int!
    var proximity: String!
    var position: Point!
}

class Point: Codable {
    var x: Double
    var y: Double
    
    init(x: Double, y: Double) {
        self.x = x
        self.y = y
    }
}
