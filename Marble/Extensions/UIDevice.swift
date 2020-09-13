//
//  UIDevice.swift
//  Stoic
//
//  Created by Ritesh Pakala on 9/12/20.
//  Copyright © 2020 Ritesh Pakala. All rights reserved.
//

import Foundation
import UIKit

extension UIResponder {
    public var orientation: UIDeviceOrientation {
        UIDevice.current.orientation
    }
    
    public var interface: UIUserInterfaceIdiom {
        UIDevice.current.userInterfaceIdiom
    }
    
    public var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    public var isIPhone: Bool {
        UIDevice.current.userInterfaceIdiom == .phone
    }
    
    public var orientationIsIPhonePortrait: Bool {
        orientation == .portrait && isIPhone
    }
    
    public var orientationIsIPhoneLandscape: Bool {
        orientation.isLandscape && isIPhone
    }
}
