//
//  Cll.swift
//  MapView
//
//  Created by Amir  on 10/24/20.
//  Copyright © 2020 Amir . All rights reserved.
//

import Foundation
import CoreLocation

extension CLLocationCoordinate2D {
    var coordinate: Coordinate {
        return Coordinate(latitude: self.latitude, longitude: self.longitude)
    }
}
