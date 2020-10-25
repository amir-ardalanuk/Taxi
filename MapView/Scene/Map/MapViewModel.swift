//
//  MapViewModel.swift
//  MapView
//
//  Created by Amir  on 10/25/20.
//  Copyright © 2020 Amir . All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol MapViewModel  {
    var vehicleList: Driver<[Vehicle]> { get }
    var clearList: Driver<Void> { get  }
    var loading: Driver<Bool> { get }
    var error: Driver<String> { get }
    var focusOnVehicle: Driver<Vehicle?> { get }
    var cameraBounds: PublishSubject<CoordinateBounds> {get set}
    var vehicleDidSelect: PublishSubject<Vehicle> { get set }
}

class MapViewModelImpl: MapViewModel {
    
    enum MapError: Error {
        case unknown
    }
    
    private let bag = DisposeBag()
    private var loadingSubject = ActivityIndicator()
    private var errorSubject = PublishSubject<String>()
    private let vehicleLocationServices: VehicleLocationUsecase
    private var clearListSubject  = PublishSubject<Void>()
    private var vehicleListSubject = BehaviorSubject<[Vehicle]>(value: [])
    private var vehicleFocused = PublishSubject<Vehicle?>()
    
    var loading: Driver<Bool> {
        return loadingSubject.asDriver(onErrorJustReturn: false)
    }
    
    var error: Driver<String> {
        return errorSubject.asDriver(onErrorJustReturn: MapError.unknown.localizedDescription)
    }
    
    var vehicleList: Driver<[Vehicle]> {
        return self.vehicleListSubject.asDriver(onErrorJustReturn: [])
    }
    
    var clearList: Driver<Void> {
        return self.clearListSubject.asDriver(onErrorJustReturn: ())
    }
    
    var focusOnVehicle: Driver<Vehicle?> {
        return vehicleFocused.asDriver(onErrorJustReturn: nil)
    }
    
    var vehicleDidSelect = PublishSubject<Vehicle>()
    var cameraBounds = PublishSubject<CoordinateBounds>()
    
    init(vehicleLocationServices: VehicleLocationUsecase) {
        self.vehicleLocationServices = vehicleLocationServices
        self.cameraBounds
            .filter{ $0.firstPosition.isEmpty == false && $0.secondPosition.isEmpty == false }
            .flatMapLatest {  (bounds) ->  Observable<Event<RemoteLocationEntity>> in
                //guard let self = self else { return Observable.empty() }
                return vehicleLocationServices.getVehicle(bounds: bounds)
                    .trackActivity(self.loadingSubject)
                    .materialize()
            }
            .compactMap { event in
                switch event {
                case .next(let response) :
                    return (response.poiList?.map {
                    Vehicle(id: $0.id ?? -1,
                            isActive: ($0.state  == .active),
                            title: $0.type,
                            type: VehicleType(rawValue: $0.type ?? "") ?? .none,
                            coordinate: $0.coordinate )
                    } ?? [])
                case let .error(error):
                    self.errorSubject.onNext(error.localizedDescription)
                    return nil
                case .completed:
                    return nil
                }
            }
            .observeOn(MainScheduler.instance)
            .bind(to: self.vehicleListSubject)
            .disposed(by: bag)
        
        self.cameraBounds.map{ _ in return Void() } .bind(to: self.clearListSubject).disposed(by: bag)
        
        self.vehicleDidSelect.asObservable().bind(to: self.vehicleFocused).disposed(by: bag)
    }
}
