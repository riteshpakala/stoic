//
//  SightNavigationController.swift
//  DeepCrop
//
//  Created by Ritesh Pakala on 3/5/19.
//  Copyright © 2019 Ritesh Pakala. All rights reserved.
//

import Photos
import UIKit


class RootNavigationController : UINavigationController, UINavigationControllerDelegate {
    struct RootNavigationOptions {
        var toolBarHeight : CGFloat = 65
        var fromRight : Bool = true
        var fromBottom : Bool = false
    }
    
    var rootNavOptions = RootNavigationOptions()
    
    override init(
        nibName nibNameOrNil: String?,
        bundle nibBundleOrNil: Bundle?) {
        
        
        super.init(
            nibName: nibNameOrNil,
            bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .clear
        self.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13, *) {

            return .darkContent
        }
        
        return .default
    }
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PushPopAnimator(operation: operation, fromRight: rootNavOptions.fromRight, fromBottom: rootNavOptions.fromBottom)
    }
    
    func style(){
        self.view.backgroundColor = LSConst.Colors.offWhite
        
        let attributes: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font : UIFont(name: LSConst.Fonts.FiraSansBold, size: 20) ?? UIFont.systemFont(ofSize: 30, weight: .bold) ]
        UINavigationBar.appearance().titleTextAttributes = attributes
        UIBarButtonItem.appearance().setTitleTextAttributes(attributes, for: .normal)
        
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : LSConst.Colors.aDarkSpaceGray ]
        UINavigationBar.appearance().tintColor = LSConst.Colors.aDarkSpaceGray
    }
}
