//
//  VehicleListNode.swift
//  MapView
//
//  Created by Amir  on 10/23/20.
//  Copyright © 2020 Amir . All rights reserved.
//

import Foundation
import AsyncDisplayKit
import RxCocoa
import RxSwift

class VehicleListNode:ASCollectionNode, ASCollectionDelegateFlowLayout, ASCollectionDataSource {
    private var list: [Vehicle] = []
    
    var vehicleSelect = PublishSubject<Vehicle>()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout, layoutFacilitator: nil)
        self.delegate = self
        self.dataSource = self
        self.backgroundColor = .clear
    }

    
    func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        list.count
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, nodeForItemAt indexPath: IndexPath) -> ASCellNode {
        return VehicleCell(vehicle: self.list[indexPath.item])
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, constrainedSizeForItemAt indexPath: IndexPath) -> ASSizeRange {
        let size = CGSize(width: collectionNode.frame.size.width / 2, height: collectionNode.frame.size.height)
        return ASSizeRange(min: size, max: size)
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, didSelectItemAt indexPath: IndexPath) {
        let vehicle = self.list[indexPath.item]
        self.vehicleSelect.onNext(vehicle)
    }
    
    func updateList(_ list: [Vehicle]) {
        self.list = list
        self.reloadData()
    }
    
    func clearList() {
        self.list = []
        self.reloadData()
    }
}
