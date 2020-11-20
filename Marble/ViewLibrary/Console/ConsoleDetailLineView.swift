//
//  ConsoleDetailLineView.swift
//  Stoic
//
//  Created by Ritesh Pakala on 11/20/20.
//  Copyright © 2020 Ritesh Pakala. All rights reserved.
//

import Foundation
//
//  ConsoleDetailView.swift
//  Stoic
//
//  Created by Ritesh Pakala on 7/24/20.
//  Copyright © 2020 Ritesh Pakala. All rights reserved.
//

import Granite
import Foundation
import UIKit

class ConsoleDetailLineView: GraniteView {
    
    var currentPredictionWorkItem: PredictWorkItem? = nil {
        didSet {
            oldValue?.cancel()
        }
    }
    
    lazy var loaderView: UIView = {
        let view: UIView = .init()
        view.backgroundColor = GlobalStyle.Colors.purple.withAlphaComponent(0.36)
        
        view.isHidden = true
        
        return (view)
    }()
    
    let baseFrame: CGRect
    
    var baseSize: CGSize {
        return baseFrame.size
    }
    private var currentPage: RobinhoodPage?
    private var stockSymbol: String? = nil
    private var payload: ConsoleDetailPayload? = nil
    private var loader: ConsoleLoader?
    private var isThinking: Bool = false
    private var isOffline: Bool = false
    override init(frame: CGRect) {
        self.baseFrame = frame
        super.init(frame: frame)
        
        
        clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateData(_ payload: ConsoleDetailPayload) {
        self.payload = payload
        currentPage?.someModel.plotData = payload.historicalTradingData.map( { ($0.dateData.asDate ?? Date(), CGFloat($0.close))  } )
        
    }
    
    func updateThink(_ payload: ThinkPayload?) {
    }
    
    func updatePage(_ component: RobinhoodPage.PageComponent) {
        
        currentPage = component.page
        addSubview(component.host)
        component.host.snp.makeConstraints { make in
            make.top.equalTo(GlobalStyle.padding)
            make.right.bottom.left.equalToSuperview()
        }
    }
    
    func predictionUpdate(_ output: Double) {
        guard let payload = self.payload else { return }
        print("{TEST} \(payload.currentTradingDay) \(payload.currentTradingDay.asDate())")
        currentPage?.someModel.plotData?.append((payload.currentTradingDay.asDate() ?? Date(), CGFloat(output)))
    }
}

