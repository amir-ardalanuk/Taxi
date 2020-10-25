//
//  VehicleLocationUsecase.swift
//  MapView
//
//  Created by Amir  on 10/23/20.
//  Copyright © 2020 Amir . All rights reserved.
//

import Foundation
import RxSwift
protocol VehicleLocationUsecase {
    func getVehicle(bounds: CoordinateBounds) -> Observable<RemoteLocationEntity>
}
