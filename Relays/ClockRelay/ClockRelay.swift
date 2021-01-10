//
//  ClockRelay.swift
//  * stoic
//
//  Created by Ritesh Pakala on 12/19/20.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

public struct ClockRelay: GraniteRelay {
    @ObservedObject
    public var command: GraniteService<ClockCenter, ClockState> = .init()
    
    class Clock {
        let currentTimePublisher = Timer.TimerPublisher(interval: 1.0, runLoop: .main, mode: .common)
        let cancellable: AnyCancellable?

        init() {
            self.cancellable = currentTimePublisher.connect() as? AnyCancellable
        }

        deinit {
            self.cancellable?.cancel()
        }
    }
    
    let gameClock: Clock = .init()
    var enabled: Bool = false {
        didSet {
            cancel()
            setup()
        }
    }
    
    public init() {
    }
    
    public func setup() {
        print(enabled)
        guard enabled else { return }
        gameClock.currentTimePublisher
            .sink(receiveValue: timeOutput)
            .store(in: &state.effectCancellables)
    }
    
    public func cancel() {
        
        gameClock.cancellable?.cancel()
        state.effectCancellables.forEach { $0.cancel() }
        state.effectCancellables.removeAll()
    }
    
    func timeOutput(date: Timer.TimerPublisher.Output) {
        guard enabled else { return }
//        sendRelay(ClockEvents.Updated())
//        print("{TEST} sending")
//        print(command.events.count)
        for event in command.events {
            print("⏱ Clock relay is firing")
            for relay in command.center.relays {
                relay.beam?.rebound(.init(command, .broadcast), event)
            }
        }
        
        //TODO: should be continous, this is just
        //for testing
        cancel()
    }
}
