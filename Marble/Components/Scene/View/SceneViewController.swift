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
        
        observeState(
            \.scene,
            handler: observeScene(_:),
            async: .main)
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        updateHomeState(self.view.frame.width > self.view.frame.height)
        _view.undim(animated: true)
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
        
        guard let sceneValue = component?.state.scene,
              let sceneType = SceneType.init(rawValue: sceneValue) else {
            return
        }
        
        switch sceneType {
        case .minimized:
            updateMinimizedState(size.width > size.height, animate: true)
        case .home:
            updateHomeState(size.width > size.height, animate: true)
        default:
            break
        }
    }
    
    func observeScene(_ scene: Change<Int>) {
        guard scene.newValue != scene.oldValue else { return }
        guard let sceneValue = scene.newValue,
            let sceneType = SceneType.init(rawValue: sceneValue) else {
            return
        }
        
        switch sceneType {
        case .minimized:
            updateMinimizedState(self.view.frame.width > self.view.frame.height, animate: true)
        case .home:
            updateHomeState(self.view.frame.width > self.view.frame.height, animate: true)
        default:
            break
        }
        
    }
}

extension SceneViewController {
    func updateHomeState(_ landscape: Bool = false, animate: Bool = false) {
        if animate {
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 1.0
        }
        
        if landscape {
            _view.nodes.cameraNode.position.y = 0
            _view.nodes.cameraNode.position.z = 18
        } else {
            _view.nodes.cameraNode.position.y = 0
            _view.nodes.cameraNode.position.z = 36
        }
        

        _view.nodes.alexanderNode.eulerAngles = .init(
            -24.radians,
            -27.radians,
            12.radians)
        
        if animate {
            SCNTransaction.commit()
        }
    }
    
    func updateMinimizedState(_ landscape: Bool = false, animate: Bool = false) {
        if animate {
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 1.0
        }
        
        if landscape {
            _view.nodes.cameraNode.position.y = 11.0
            _view.nodes.cameraNode.position.z = 30
        } else {
            _view.nodes.cameraNode.position.y = 21.5
            _view.nodes.cameraNode.position.z = 48
        }
        

        _view.nodes.alexanderNode.eulerAngles = .init(
            -27.radians,
            -24.radians,
            12.radians)

        if animate {
            SCNTransaction.commit()
        }
    }
}

extension Int {
    var radians: Float {
        return Float(self) * .pi / 180
    }
}
