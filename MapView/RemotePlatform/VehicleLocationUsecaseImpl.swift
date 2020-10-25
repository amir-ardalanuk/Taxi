//
//  VehicleLocationUsecaseImpl.swift
//  MapView
//
//  Created by Amir  on 10/23/20.
//  Copyright © 2020 Amir . All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class VehicleLocationUsecaseImpl: VehicleLocationUsecase, NetworkWrapper {
    let API = "https://poi-api.mytaxi.com/PoiService"
    let categoriesEndpoint = "/poi/v1"
    
    func getVehicle(bounds: CoordinateBounds) -> Observable<RemoteLocationEntity> {
        do {
            let params = [
                "p2Lat": bounds.secondPosition.latitude!,
                "p2Lon": bounds.secondPosition.longitude!,
                "p1Lat": bounds.firstPosition.latitude!,
                "p1Lon": bounds.firstPosition.longitude!,
            ]
            return request(endpoint: API + categoriesEndpoint, query: params as [String : Any])
        } catch {
            return Observable.error(NetworkError.invalidParameter("Bounds", "is Empty"))
        }
    }
    
    
}
