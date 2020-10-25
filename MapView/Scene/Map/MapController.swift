//
//  MapController.swift
//  MapView
//
//  Created by Amir  on 10/24/20.
//  Copyright © 2020 Amir . All rights reserved.
//

import Foundation
import AsyncDisplayKit
import RxSwift
import RxCocoa

class MapControllerNode: ASDisplayNode {
    
    private let viewModel: MapViewModel
    private let bag = DisposeBag()
 
    lazy var activityIndicatorNode: ActivityIndicatorNode = {
        let node = ActivityIndicatorNode(style: .medium)
        node.isHidden = true
        node.isAnimating = true
        return node
    }()
    
    
    lazy var mapNode: MapNode = {
        let position1 = Coordinate(latitude: 53.694865, longitude: 9.757589)
        let position2 = Coordinate(latitude: 53.394655, longitude: 10.099891)
        let bounds = CoordinateBounds(firstPosition: position1, secondPosition: position2)
        let node = MapNode(initialBounds: bounds, zoom: 14, minZoomForChangeTrigger: 13)
        return node
    }()
    
    lazy var listNode: VehicleListNode = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 4
        
        let node = VehicleListNode(frame: .zero, collectionViewLayout: layout)
        node.isPagingEnabled = true
        node.contentInset = .init(top: 0, left: 10, bottom: 0, right: 10)
        node.showsHorizontalScrollIndicator = false
        return node
    }()
    
    lazy var messageBoxNode: MessageNode = {
        let node = MessageNode()
        node.isHidden = true
        return node
    }()
    
    init(viewModel: MapViewModel) {
        self.viewModel = viewModel
        super.init()
        self.automaticallyManagesSubnodes = true
    }
    
    override func didLoad() {
        super.didLoad()
        binding()
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        self.mapNode.view.frame.size = constrainedSize.max
        self.listNode.style.preferredSize.height = 65
        self.activityIndicatorNode.style.preferredSize.height = 30
        self.messageBoxNode.style.preferredSize.height = 60
        let messageInset = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8), child: self.messageBoxNode)
        
        let bottomChildNode: ASLayoutElement!
        if !messageBoxNode.isHidden {
             bottomChildNode = messageInset
        } else if !self.activityIndicatorNode.isHidden {
           bottomChildNode = self.activityIndicatorNode
        } else {
            bottomChildNode = listNode
        }
        
        return ASOverlayLayoutSpec(child: self.mapNode,
                                   overlay: ASInsetLayoutSpec(insets: UIEdgeInsets(top: .infinity, left: 0, bottom: self.safeAreaInsets.bottom + 8, right: 0),
                                                              child: bottomChildNode ))
    }
    
    private func binding() {
        
        self.mapNode.cameraBoundSubject.bind(to: self.viewModel.cameraBounds).disposed(by: bag)
        self.listNode.vehicleSelect.bind(to: self.viewModel.vehicleDidSelect).disposed(by: bag)
        
        self.viewModel.vehicleList.drive(onNext: self.updateList(_:)).disposed(by: bag)
        self.viewModel.clearList.asDriver(onErrorJustReturn: ()).drive(onNext: self.clearList).disposed(by: bag)
        
        self.viewModel.loading.drive(onNext: { [weak self] (isLoading) in
            self?.messageBoxNode.isHidden = true
            self?.activityIndicatorNode.isHidden = !isLoading
            self?.setNeedsLayout()
            
        }).disposed(by: bag)
        
        self.viewModel.focusOnVehicle.drive(onNext: { (vehicle) in
            if let veh = vehicle {
                self.mapNode.focusOn(veh)
            }
            
        }).disposed(by: bag)
        
        self.viewModel.error.drive(onNext: { [weak self] (error) in
            self?.messageBoxNode.message = error
            self?.messageBoxNode.isHidden = false
            self?.setNeedsLayout()
        }).disposed(by: bag)
    }
    
    private func clearList() {
        self.mapNode.clearMarkers()
        self.listNode.clearList()
    }
    
    private func updateList(_ list: [Vehicle]) {
        self.messageBoxNode.isHidden = true
        self.setNeedsLayout()
        self.mapNode.insertMarkers(list: list)
        self.listNode.updateList(list)
    }
    
    
}
