//
//  Asset.swift
//  * stoic (iOS)
//
//  Created by Ritesh Pakala on 12/21/20.
//

import Foundation
import GraniteUI
import SwiftUI

public enum AssetType {
    case security
    case model
    case sentiment
    case user
}

public protocol Asset: ID {
    var assetType: AssetType { get }
    var assetID: String { get }
    
    var symbol: String { get }
    var symbolImage: Image? { get }
    
    var symbolColor: Color { get }
    
    var title: String { get }
    var subtitle: String { get }
    var showDescription1: Bool { get }
    var description1: String { get }
    var description1_sub: String { get }
    var description2Title: String? { get }
    var showDescription2: Bool { get }
    var description2: String { get }
}

extension Asset {
    public var symbolImage: Image? {
        nil
    }
    
    var asSecurity: Security? {
        return (self as? Security)
    }
    
    var asModel: TonalModel? {
        return (self as? TonalModel)
    }
    
    public var showDescription1: Bool {
        true
    }
    
    public var showDescription2: Bool {
        true
    }
    
    public var description2Title: String? {
        nil
    }
}

extension User {
    public var assetType: AssetType {
        .user
    }
    
    public var assetID: String {
        "id: "+self.info.uid
    }
    
    public var symbol: String {
        ""
    }
    
    public var symbolColor: Color {
        appearance.color
    }
    
    public var title: String {
        info.username
    }
    
    public var subtitle: String {
        "age: \(info.created.daysFrom(.today))"
    }
    
    public var showDescription1: Bool {
        false
    }
    
    public var description1: String {
        ""
    }
    
    public var description1_sub: String {
        ""
    }
    
    public var showDescription2: Bool {
        false
    }
    
    public var description2: String {
        ""
    }
}

extension TonalModel {
    public var title: String {
        self.quote.ticker.uppercased()
    }
    
    public var subtitle: String {
        "id: "+self.idDisplay
    }
    
    public var symbol: String {
        "M"
    }
    
    public var symbolImage: Image? {
        Image("model_icon")
            .resizable()
    }
    
    public var symbolColor: Color {
        self.needsUpdate ? Brand.Colors.marble : Brand.Colors.purple
    }
    
    public var description1: String {
        self.targetDate.asStringWithTime
    }
    
    public var description1_sub: String {
        ""
    }
    
    public var description2: String {
        self.latestSecurity.description2
    }
}

extension Security {
    public var title: String {
        self.ticker.uppercased()
    }
    
    public var subtitle: String {
        "volume: "+self.volumeValue.abbreviate
    }
    
    public var symbol: String {
        self.indicator
    }
    
    public var symbolColor: Color {
        switch securityType {
        case .crypto:
            return Brand.Colors.orange
        default:
            return Brand.Colors.marble
        }
    }
    
    public var description1: String {
        "$\(self.lastValue.display)"
    }
    
    public var description1_sub: String {
        "\(self.isGainer ? "+" : "-")$\(self.changeAbsoluteValue.display.replacingOccurrences(of: "-", with: ""))"
    }
    
    public var description2: String {
        "\(self.isGainer ? "+" : "")\(self.changePercentValue.percent)%"
    }
}

extension Sentiment {
    public var title: String {
        self.content
    }
    
    public var subtitle: String {
        "[neg: \((neg*100).asInt)% | pos: \((pos*100).asInt)%] // bias: \((neu*100).asInt)%"
    }
    
    public var symbol: String {
        "S"
    }
    
    public var symbolColor: Color {
        Brand.Colors.yellow
    }
    
    public var description1: String {
        ""
    }
    
    public var description1_sub: String {
        ""
    }
    
    public var description2: String {
        ""
    }
}
