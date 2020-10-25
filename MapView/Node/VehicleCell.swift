//
//  VehicleCell.swift
//  MapView
//
//  Created by Amir  on 10/24/20.
//  Copyright © 2020 Amir . All rights reserved.
//

import Foundation
import AsyncDisplayKit

class VehicleCell: ASCellNode {
    
    lazy var vehicleTypeNode: ASImageNode = {
        let node = ASImageNode()
        node.image = #imageLiteral(resourceName: "texi")
        node.style.preferredSize = .init(width: 42, height: 42)
        return node
    }()
    
    lazy var titleTextAttribut: [NSAttributedString.Key: AnyObject] = {
        var attributes = [NSAttributedString.Key: AnyObject]()
        attributes[.font] = UIFont.boldSystemFont(ofSize: 20)
        return attributes
    }()
    
    
    lazy var textNode: ASTextNode = {
        let node = ASTextNode()
        return node
    }()
    
    lazy var imageStateNode: ASImageNode = {
        let node = ASImageNode()
        node.style.preferredSize = .init(width: 24, height: 24)
        return node
    }()
    
    let vehicle: Vehicle
    
    init(vehicle: Vehicle) {
        self.vehicle = vehicle
        super.init()
        self.automaticallyManagesSubnodes = true
        
        self.borderWidth = 1
        self.cornerRadius = 5
        self.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.9447073063)
        self.shadowOffset = CGSize(width: 1, height: 1)
        self.shadowColor = #colorLiteral(red: 0.5723067522, green: 0.5723067522, blue: 0.5723067522, alpha: 0.2239766725)
        self.clipsToBounds = true
    }
    
    override func didLoad() {
        super.didLoad()
        titleTextAttribut[.foregroundColor] = vehicle.isActive ? #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1) :  #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        self.textNode.attributedText = NSAttributedString(string: vehicle.title ?? "-", attributes: self.titleTextAttribut)
        self.borderColor = vehicle.isActive ? #colorLiteral(red: 0.8959682642, green: 0.8959682642, blue: 0.8959682642, alpha: 1) :  #colorLiteral(red: 0.777566386, green: 0.777566386, blue: 0.777566386, alpha: 0.4812389965)
        self.imageStateNode.image =  vehicle.isActive ? #imageLiteral(resourceName: "active") : nil
        
    }
    
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASInsetLayoutSpec(insets: .init(top: 8, left: 8, bottom: 8, right: 8),
                                 child:  ASStackLayoutSpec(direction: .horizontal, spacing: 9, justifyContent: .spaceBetween, alignItems: .center, children: [
                                    ASStackLayoutSpec(direction: .horizontal, spacing: 8, justifyContent: .start, alignItems: .center, children: [
                                        vehicleTypeNode,
                                        textNode
                                    ]),
                                    imageStateNode
                                 ])
        )
    }
}
