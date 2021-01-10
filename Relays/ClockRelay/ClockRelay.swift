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
    public init() {
    }
    
    public func setup() {
        gameClock.currentTimePublisher
            .sink(receiveValue: timeOutput)
            .store(in: &state.effectCancellables)
    }
    
    func timeOutput(date: Timer.TimerPublisher.Output) {
        
//        sendRelay(ClockEvents.Updated())
//        print("{TEST} sending")
//        print(command.events.count)
        for event in command.events {
            print("{TEST} sending")
            for relay in command.center.relays {
                relay.beam?.rebound(.init(command, .broadcast), event)
            }
        }
        
        //TODO: should be continous, this is just
        //for testing
        gameClock.cancellable?.cancel()
        state.effectCancellables.forEach { $0.cancel() }
        state.effectCancellables.removeAll()
    }
}
