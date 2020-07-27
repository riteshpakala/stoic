//
//  ViewController.swift
//  Wonder
//
//  Created by Ritesh Pakala on 8/12/19.
//  Copyright © 2019 Ritesh Pakala. All rights reserved.
//

import MediaPlayer
import MobileCoreServices
import UIKit
import SnapKit
import Photos

public class HomeViewController: GraniteViewController<HomeState>{
    
    override public func loadView() {
        self.view = HomeView.init()
    }
    
    public var _view: HomeView {
        return self.view as! HomeView
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        print("{TEST} Home viewDidLoad reached \(component?.state.test)")
//        sendEvent(HomeEvents.SVMStockTestEvent())
        sendEvent(HomeEvents.TweetSentimentTestEvent())
        print("{TEST} Home viewDidLoad reached \(component?.state.test)")
        
        self.view.backgroundColor = .clear
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
    }
    
    override public func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    
    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
}

