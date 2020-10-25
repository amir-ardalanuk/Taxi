//
//  Vehicle.swift
//  MapView
//
//  Created by Amir  on 10/23/20.
//  Copyright © 2020 Amir . All rights reserved.
//

import Foundation
enum VehicleType: String {
    case taxi = "Taxi"
    case none
}
struct Vehicle {
    var id: Int
    var isActive: Bool = false
    var title: String?
    var type: VehicleType
    var coordinate: Coordinate?
}
