//
//  HomeView.swift
//  Stoic
//
//  Created by Ritesh Pakala on 5/31/20.
//  Copyright © 2020 Ritesh Pakala. All rights reserved.
//
import Granite
import Foundation
import SceneKit
import SceneKit.ModelIO
import UIKit

public class HomeView: GraniteView {
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
