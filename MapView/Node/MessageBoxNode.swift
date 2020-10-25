//
//  MessageBoxNode.swift
//  MapView
//
//  Created by Amir  on 10/25/20.
//  Copyright © 2020 Amir . All rights reserved.
//

import Foundation
import AsyncDisplayKit

class MessageNode: ASDisplayNode {
    
    private lazy var titleTextAttribut: [NSAttributedString.Key: AnyObject] = {
        var attributes = [NSAttributedString.Key: AnyObject]()
        attributes[.font] = UIFont.boldSystemFont(ofSize: 13)
        return attributes
    }()
    
    private var containerNode: ASDisplayNode = {
        let node = ASDisplayNode()
        node.backgroundColor = .white
        node.cornerRadius = 8
        return node
    }()
    

    private lazy var textNode: ASTextNode = {
        let node = ASTextNode()
        return node
    }()
    
    var message: String? {
        set {
            textNode.attributedText = NSAttributedString(string: newValue ?? "", attributes: self.titleTextAttribut)
        }
        get {
            return textNode.attributedText?.string
        }
    }
    
    
    
    override init() {
        super.init()
        self.automaticallyManagesSubnodes = true
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASOverlayLayoutSpec(child: self.containerNode,
                                   overlay: ASCenterLayoutSpec(centeringOptions: .XY, sizingOptions: [], child: self.textNode))
    }
}
