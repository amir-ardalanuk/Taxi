//
//  MapNode.swift
//  MapView
//
//  Created by Amir  on 10/23/20.
//  Copyright © 2020 Amir . All rights reserved.
//

import Foundation
import AsyncDisplayKit
import GoogleMaps
import RxSwift
//protocol MapViewModel {
//
//}

class MapNode: ASDisplayNode {
    
    private var isCameraUpdating = false
    private var markers = [GMSMarker]()
    private var minZoom: Float
    private var mapView: GMSMapView {
        return self.view as! GMSMapView
    }
    
    var initialBound: CoordinateBounds
    var initailZoom: Float
    var cameraBoundSubject = PublishSubject<CoordinateBounds>()
    var cameraDidChangeToOutOfZoom = PublishSubject<Void>()
    
    init(initialBounds bounds: CoordinateBounds, zoom: Float,minZoomForChangeTrigger minZoom: Float) {
        self.minZoom = minZoom
        self.initialBound = bounds
        self.initailZoom = zoom
        super.init()
        
        self.setViewBlock({ () -> UIView in
            let camera = GMSCameraPosition.camera(withLatitude: 0.0, longitude: 0.0, zoom: zoom)
            let mapView = GMSMapView.map(withFrame: self.frame, camera: camera)
            
            
            mapView.delegate = self
            
            return mapView
        })

    }
    
    override func didLoad() {
        super.didLoad()
        let positionOne = self.initialBound.firstPosition.locationCoordinate2D
        let positionTwo = self.initialBound.secondPosition.locationCoordinate2D
        
        let bounds = GMSCoordinateBounds(coordinate: positionOne, coordinate: positionTwo)
        let cameraUpdate: GMSCameraUpdate = GMSCameraUpdate.fit(bounds)
        DispatchQueue.main.asyncAfter(deadline: .now() + .microseconds(100), execute: { [weak self] in
            guard let self = self else { return }
            self.mapView.animate(with: cameraUpdate)
            self.mapView.animate(toZoom: self.initailZoom)
        })
        
    }
    
    func insertMarkers(list : [Vehicle]) {
        let markerImage = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: 32, height: 32)))
        markerImage.contentMode = .scaleAspectFit
        markerImage.image = #imageLiteral(resourceName: "taxi_marker")
        
        list.forEach { (vehicle) in
            guard let coordinate = vehicle.coordinate else { return }
            let marker = GMSMarker(position: coordinate.locationCoordinate2D)
            marker.map = (self.view as! GMSMapView)
            marker.iconView = markerImage
            marker.userData = vehicle.id
            self.markers.append(marker)
        }
    }
    
    func clearMarkers() {
        self.markers = []
        (self.view as! GMSMapView).clear()
    }
    
    func focusOn(_ vehicle: Vehicle) {
        if let marker = self.markers.filter({($0.userData as? Int) == vehicle.id}).first {
            let cameraUpdate = GMSCameraUpdate.setTarget(marker.position, zoom: 15)
            isCameraUpdating = true
            self.mapView.animate(with: cameraUpdate)
        }
    }
    
}
extension MapNode: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        guard position.zoom >= self.minZoom else {
            return
        }
        guard !isCameraUpdating else {
            self.isCameraUpdating = false
            return
        }
        let projection = mapView.projection.visibleRegion()
        
        let topLeftCorner: CLLocationCoordinate2D = projection.farLeft
        let bottomRightCorner: CLLocationCoordinate2D = projection.nearRight
        
        let bounds = CoordinateBounds(firstPosition: topLeftCorner.coordinate, secondPosition: bottomRightCorner.coordinate)
        self.cameraBoundSubject.onNext(bounds)
    }
    
}
