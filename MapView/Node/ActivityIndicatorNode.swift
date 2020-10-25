//
//  ActivityIndicatorNode.swift
//  MapView
//
//  Created by Amir  on 10/24/20.
//  Copyright © 2020 Amir . All rights reserved.
//

import AsyncDisplayKit

class ActivityIndicatorNode: ASDisplayNode {
    
    private var activityIndicatorView: UIActivityIndicatorView {
        return self.view as! UIActivityIndicatorView
    }
    
    init(style: UIActivityIndicatorView.Style) {
        super.init()
        self.setViewBlock({ () ->
            UIView in
            return UIActivityIndicatorView(style: style)
        })
    }
    
    var isAnimating: Bool {
        set{
            if newValue {
                self.activityIndicatorView.startAnimating()
            }else{
                self.activityIndicatorView.stopAnimating()
            }
        }
        get{
            self.activityIndicatorView.isAnimating
        }
    }
}
