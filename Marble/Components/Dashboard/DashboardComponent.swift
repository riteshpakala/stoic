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
            UpdateSettingsReducer.Reducible(),
            OpenProfileSettingsReducer.Reducible(),
            OpenBrowserSettingsReducer.Reducible(),
            DismissProfileSettingsReducer.Reducible(),
            DetailIsInteractingReducer.Reducible(),
            ShowSettingsReducer.Reducible(),
            SubscriptionUpdatedDashboardReducer.Reducible(),
            ShowSubscribeReducer.Reducible()
        ]
    }
    
    override public func didLoad() {
        push(SearchBuilder.build(self.service))
        guard let viewController = self.viewController else { return }
        
        sendEvent(DashboardEvents.GenerateSettings())
        
        getSubComponent(
            SearchComponent.self)?
            .viewController?.view.snp.makeConstraints { make in
                
            make.height.equalTo(SearchStyle.searchSizeInActive.height)
            make.top.equalTo(viewController.view.safeAreaLayoutGuide.snp.top).offset(GlobalStyle.padding)
            make.left.equalTo(viewController.view.safeAreaLayoutGuide.snp.left)
            make.right.equalTo(viewController.view.safeAreaLayoutGuide.snp.right)
        }
        
        //Onboarding
        if !service.center.onboardingDashboardCompleted {
            push(OnboardingBuilder.build(
                self.service,
                state: .init(GlobalDefaults.OnboardingDashboard)),
                 display: .fit)
        }
        
        //DEV:
        if !service.center.welcomeCompleted {
            push(AnnouncementBuilder.build(
                self.service,
                state: .init(GlobalDefaults.Welcome)),
                display: .modalTop)
        }
    }
}
