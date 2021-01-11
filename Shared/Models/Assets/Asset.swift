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
}

public protocol Asset: ID {
    var assetType: AssetType { get }
    var assetID: String { get }
    
    var symbol: String { get }
    var symbolColor: Color { get }
    var title: String { get }
    var subtitle: String { get }
    var description1: String { get }
    var description1_sub: String { get }
    var description2: String { get }
}

extension Asset {
    var asSecurity: Security? {
        return (self as? Security)
    }
    
    var asModel: TonalModel? {
        return (self as? TonalModel)
    }
}

extension TonalModel {
    public var title: String {
        self.quote.ticker
    }
    
    public var subtitle: String {
        "id: "+self.idDisplay
    }
    
    public var symbol: String {
        "M"
    }
    
    public var symbolColor: Color {
        Brand.Colors.purple
    }
    
    public var description1: String {
        "\(self.quote.securities.first?.description1 ?? "")"
    }
    
    public var description1_sub: String {
        "\(self.quote.securities.first?.description1_sub ?? "")"
    }
    
    public var description2: String {
        "\(self.quote.securities.first?.description2 ?? "")"
    }
}

extension Security {
    public var title: String {
        self.ticker
    }
    
    public var subtitle: String {
        "volume: "+self.volumeValue.abbreviate
    }
    
    public var symbol: String {
        self.indicator
    }
    
    public var symbolColor: Color {
        Brand.Colors.marble
    }
    
    public var description1: String {
        "$\(self.lastValue.display)"
    }
    
    public var description1_sub: String {
        "\(self.isGainer ? "+" : "")$\(self.changeAbsoluteValue.display)"
    }
    
    public var description2: String {
        "\(self.changePercentValue.display)%"
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
