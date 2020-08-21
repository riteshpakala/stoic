//
//  SceneViewController.swift
//  Stoic
//
//  Created by Ritesh Pakala on 6/1/20.
//  Copyright © 2020 Ritesh Pakala. All rights reserved.
//
import Granite
import Foundation
import UIKit
import SceneKit

public class SceneViewController: GraniteViewController<SceneState>{
    
    override public func loadView() {
        self.view = SceneView.init()
    }
    
    public var _view: SceneView {
        return self.view as! SceneView
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        start()
    }
    
    override public func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    
    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override public func viewWillTransition(
        to size: CGSize,
        with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        start(size.width > size.height)
    }
}

extension SceneViewController {
    func start(_ landscape: Bool = false) {
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 1.0
        
        if landscape {
            _view.nodes.cameraNode.position.y = 11.5
            _view.nodes.cameraNode.position.z = 30
        } else {
            _view.nodes.cameraNode.position.y = 20
            _view.nodes.cameraNode.position.z = 48
        }
        

        _view.nodes.alexanderNode.eulerAngles = .init(
            -27.radians,
            -24.radians,
            12.radians)

        SCNTransaction.commit()
    }
}

extension Int {
    var radians: Float {
        return Float(self) * .pi / 180
    }
}
