//
//  Tone.swift
//  * stoic
//
//  Created by Ritesh Pakala on 12/27/20.
//
import SwiftUI
import Foundation
import GraniteUI

public class Portfolio: ObservableObject {
    var holdings: Holdings = .init()
}

public class Holdings {
    var tickerToAdd: String = ""
}
