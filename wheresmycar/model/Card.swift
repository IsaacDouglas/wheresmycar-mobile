//
//  Card.swift
//  wheresmycar
//
//  Created by Isaac Douglas on 01/12/18.
//  Copyright © 2018 Isaac Douglas. All rights reserved.
//

import Foundation

class Card: Codable {
    var _id: String!
    var token: String!
    var text: String!
    var userDeviceId: String!
    var section: Section!
}
