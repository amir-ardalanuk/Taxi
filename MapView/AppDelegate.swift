//
//  AppDelegate.swift
//  MapView
//
//  Created by Amir  on 10/23/20.
//  Copyright © 2020 Amir . All rights reserved.
//

import UIKit
import GoogleMaps
import AsyncDisplayKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow!
    let apiKey = "AIzaSyAHN332cIFKYvDdldvPCtw6YwVxQp52ie4"
    let vehicleLocationServices = VehicleLocationUsecaseImpl()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window  = UIWindow(frame: UIScreen.main.bounds)
        GMSServices.provideAPIKey(apiKey)
        
        window.backgroundColor = .black
        let mapViewModel = MapViewModelImpl(vehicleLocationServices: vehicleLocationServices)
        let mapNode = MapControllerNode(viewModel: mapViewModel)
        window.rootViewController = ASDKViewController(node: mapNode)
        window.makeKeyAndVisible()
        self.window = window
        // Override point for customization after application launch.
        return true
    }

}

