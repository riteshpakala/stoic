//
//  DashboardComponent.swift
//  Stoic
//
//  Created by Ritesh Pakala on 6/1/20.
//  Copyright (c) 2020 Ritesh Pakala. All rights reserved.
//
import Granite
import Foundation
import UIKit

public class DashboardComponent: Component<DashboardState> {
    override public var reducers: [AnyReducer] {
        [
            ShowDetailReducer.Reducible(),
            CloseDetailReducer.Reducible(),
            GenerateSettingsReducer.Reducible(),
            UpdateSettingsReducer.Reducible()
        ]
    }
    
    override public func didLoad() {
//        push(LiveSearchCollectionBuilder.build(self.services, parent: self))
        push(SearchBuilder.build(self.service))
         
        guard let viewController = self.viewController else { return }
        
        sendEvent(DashboardEvents.GenerateSettings())
        
//        getSubComponent(
//            LiveSearchCollectionComponent.self)?
//            .viewController?.view.snp.makeConstraints { make in
//            make.height.equalTo(LiveSearchCollectionStyle.collectionHeight)
//            make.bottom.equalTo(viewController.view.safeAreaLayoutGuide.snp.bottom).offset(-GlobalStyle.padding)
//            make.left.equalTo(viewController.view.safeAreaLayoutGuide.snp.left)
//            make.right.equalTo(viewController.view.safeAreaLayoutGuide.snp.right)
//        }
        
        getSubComponent(
            SearchComponent.self)?
            .viewController?.view.snp.makeConstraints { make in
                
            make.height.equalTo(SearchStyle.searchSizeInActive.height)
            make.top.equalTo(viewController.view.safeAreaLayoutGuide.snp.top).offset(GlobalStyle.padding)
            make.left.equalTo(viewController.view.safeAreaLayoutGuide.snp.left)
            make.right.equalTo(viewController.view.safeAreaLayoutGuide.snp.right)
        }
        
        
    }
}
