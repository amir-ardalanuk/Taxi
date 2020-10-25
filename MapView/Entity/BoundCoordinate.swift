//
//  BoundCoordinate.swift
//  MapView
//
//  Created by Amir  on 10/24/20.
//  Copyright © 2020 Amir . All rights reserved.
//

import Foundation
import CoreLocation

struct CoordinateBounds {
    let firstPosition: Coordinate
    let secondPosition: Coordinate
}
extension Coordinate {
    var locationCoordinate2D: CLLocationCoordinate2D {
        guard !self.isEmpty else {
            return CLLocationCoordinate2D()
        }
        return CLLocationCoordinate2D(latitude: self.latitude!, longitude: self.longitude!)
    }
}
