//
//  SceneView.swift
//  Stoic
//
//  Created by Ritesh Pakala on 6/1/20.
//  Copyright © 2020 Ritesh Pakala. All rights reserved.
//
import Granite
import Foundation
import SceneKit
import SceneKit.ModelIO
import UIKit

public class SceneView: GraniteView {
    
    struct SCNNodes {
        var cameraNode: SCNNode {
            let cameraNode = SCNNode()
            cameraNode.camera = SCNCamera()
            cameraNode.position = SCNVector3(x: 0, y: 0, z: 15)
            cameraNode.rotation = SCNVector4(0, 0, 0, 0)
            return cameraNode
        }
        
        var lightNode: SCNNode {
            let lightNode = SCNNode()
            lightNode.light = SCNLight()
            lightNode.light!.type = .omni
            lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
            
            return lightNode
        }
        
        var ambientLightNode: SCNNode {
            let ambientLightNode = SCNNode()
            ambientLightNode.light = SCNLight()
            ambientLightNode.light!.type = .ambient
            ambientLightNode.light!.color = UIColor.darkGray
            
            return ambientLightNode
        }
        
        var alexanderNode: SCNNode {
            let path = Bundle.main.path(forResource: "alexander", ofType: "obj")
            let url = NSURL(fileURLWithPath: path!)
            let materialPath = Bundle.main.path(forResource: "alexander", ofType: "jpg")
            let materialURL = NSURL(fileURLWithPath: materialPath!)
            let asset = MDLAsset(url: url as URL)
            
            
            let scatteringFunction = MDLScatteringFunction.init()
            let material = MDLMaterial.init(name: "baseMaterial", scatteringFunction: scatteringFunction)
            
            let property = MDLMaterialProperty.init(name: "baseMaterial", semantic: .baseColor, url: materialURL as URL)
            material.setProperty(property)
            
            for mesh in ((asset.object(at: 0) as? MDLMesh)?.submeshes as? [MDLSubmesh]) ?? [] {
              mesh.material = material
            }
            
            asset.loadTextures()
            
            guard let object = asset.object(at: 0) as? MDLMesh
                 else { fatalError("Failed to get mesh from asset.") }
            
            let alexanderNode = SCNNode(mdlObject: object)
            alexanderNode.position = SCNVector3(x: 0, y: 0, z: 0)

            return alexanderNode
        }
    }
    
    lazy var sceneView: SCNView = {
        let scene = SCNScene.init()
        scene.rootNode.addChildNode(nodes.cameraNode)
        scene.rootNode.addChildNode(nodes.lightNode)
        scene.rootNode.addChildNode(nodes.ambientLightNode)
        scene.rootNode.addChildNode(nodes.alexanderNode)
       
        let sceneView = SCNView.init()
        sceneView.scene = scene
        sceneView.allowsCameraControl = true
        sceneView.backgroundColor = .black
        
        return sceneView
    }()
    
    var nodes: SCNNodes = .init()
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(sceneView)
        sceneView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
