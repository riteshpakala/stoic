//
//  URL+Share.swift
//  Wonder
//
//  Created by Ritesh Pakala on 8/18/19.
//  Copyright © 2019 Ritesh Pakala. All rights reserved.
//

import Foundation
import UIKit

extension URL{
    func share(from viewController: UIViewController, completion: ((Bool) -> Void)? = nil) {
        let activityVC = UIActivityViewController(activityItems: [self], applicationActivities: nil)
        activityVC.completionWithItemsHandler = { (activity, success, items, error) in
            
            
            
            if success {
                
                
                UserDefaults.standard.set(UserDefaults.standard.integer(forKey: LSConst.DefaultKeys.exported)+1, forKey: LSConst.DefaultKeys.exported)
                UserDefaults.standard.synchronize()

//
//                DispatchQueue.main.async {
//                    viewController.requestReview()
//                }
            }
            
            completion?(success)
        }
        
        
        activityVC.popoverPresentationController?.sourceView = viewController.view
        activityVC.popoverPresentationController?.sourceRect = viewController.view.frame
        
        viewController.present(activityVC, animated: true, completion: nil)
    }
}
