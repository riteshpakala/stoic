//
//  DetailView.swift
//  Stoic
//
//  Created by Ritesh Pakala on 6/1/20.
//  Copyright (c) 2020 Ritesh Pakala. All rights reserved.
//
import Granite
import Foundation
import UIKit

public class DetailView: GraniteView {
    public enum DetailPredictionState: String {
        case downloadingData = "downloading_data"
        case seekingSentiment = "seeking_emotions"
        case predicting = "predicting"
        case done = "done."
    }
    
    lazy var consoleView: ConsoleView = {
        let consoleView: ConsoleView = .init(
            frame: .init(
                origin: .zero,
                size: DetailStyle.consoleSizeExpanded))
        consoleView.setStatus(currentState.rawValue)
        return consoleView
    }()
    
    var currentState: DetailPredictionState = .downloadingData {
        didSet {
            if currentState == .done {
                progressTimer?.invalidate()
                self.progressTimer = nil
                self.consoleView.setStatus(nil)
                
                if !consoleView.minimized {
                    self.frame.size = DetailStyle.consoleSizeExpanded
                }
            }
        }
    }
    
    var progressTimer: Timer? = nil
    var currentIndicator: ProgressTimerIndicator = .zero
    enum ProgressTimerIndicator: String {
        case zero = ""
        case one = "."
        case two = ".."
        case three = "..."
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        self.frame.size = DetailStyle.consoleSizePredicting
        self.center = .init(
            x: LSConst.Device.width/2,
            y: LSConst.Device.height/2)
            
        addSubview(consoleView)
        consoleView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        progressTimer = Timer.scheduledTimer(
            withTimeInterval: 0.42,
            repeats: true) { timer in
            
                DispatchQueue.main.async {
                    if self.currentState != .done {
                        
                        if self.currentIndicator == .zero {
                            self.currentIndicator = .one
                        } else if self.currentIndicator == .one {
                            self.currentIndicator = .two
                        } else if self.currentIndicator == .two {
                            self.currentIndicator = .three
                        } else {
                            self.currentIndicator = .zero
                        }
                        
                        self.consoleView.setStatus(
                            self.currentState.rawValue+"\(self.currentIndicator.rawValue)")
                    }
                }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
