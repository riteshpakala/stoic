//
//  ConsoleLoader.swift
//  Stoic
//
//  Created by Ritesh Pakala on 9/12/20.
//  Copyright © 2020 Ritesh Pakala. All rights reserved.
//

import Foundation
import UIKit
import Granite

protocol ConsoleLoaderDelegate: class {
    func consoleLoaderUpdated(_ indicator: String)
}
class ConsoleLoader {
    weak var delegate: ConsoleLoaderDelegate? = nil
    public var defaultStatus: String {
        let components = self.baseText.components(separatedBy: ConsoleLoader.seperator)
        
        if let trail = components.first, let tail = components.last, components.count == 2 {
            let indicator = trail+(self.currentIndicator.rawValue)+tail
            return indicator
        } else {
            return self.currentIndicator.rawValue
        }
    }
    public var isLoading: Bool {
        progressTimer != nil
    }
    
    var progressTimer: Timer? = nil
    var currentIndicator: ProgressTimerIndicator = .zero
    enum ProgressTimerIndicator: String {
        case zero = ""
        case one = "."
        case two = ".."
        case three = "..."
    }
    
    public static let seperator: String = "$@"
    let baseText: String
    public init(_ target: ConsoleLoaderDelegate? = nil, baseText: String = "") {
        self.baseText = baseText
        self.delegate = target
    }
    
    public func begin() {
        progressTimer = Timer
            .scheduledTimer(withTimeInterval: 0.42,repeats: true)
            { [weak self] timer in
                
            if self?.currentIndicator == .zero {
                self?.currentIndicator = .one
            } else if self?.currentIndicator == .one {
                self?.currentIndicator = .two
            } else if self?.currentIndicator == .two {
                self?.currentIndicator = .three
            } else {
                self?.currentIndicator = .zero
            }
                
            
            DispatchQueue.main.async {
                let components = self?.baseText.components(separatedBy: ConsoleLoader.seperator)
                
                if let trail = components?.first, let tail = components?.last, (components?.count ?? 0) == 2 {
                    
                    let indicator = trail+(self?.currentIndicator.rawValue ?? "")+tail
                    self?.delegate?.consoleLoaderUpdated(indicator)
                } else {
                    let indicator = self?.currentIndicator.rawValue ?? ""
                    self?.delegate?.consoleLoaderUpdated(indicator)
                }
            }
        }
    }
    
    public func stop() {
        progressTimer?.invalidate()
        self.progressTimer = nil
    }
}
