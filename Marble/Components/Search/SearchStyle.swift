//
//  SearchStyle.swift
//  Stoic
//
//  Created by Ritesh Pakala on 6/7/20.
//  Copyright (c) 2020 Ritesh Pakala. All rights reserved.
//

import Granite
import Foundation
import UIKit

struct SearchStyle {
    static var searchSizeInActive: CGSize = {
        return .init(width: LSConst.Device.width, height: 50)
    }()
    
    static var searchSizeActive: CGSize = {
        return .init(width: LSConst.Device.width, height: 50 + collectionHeight.height)
    }()
    
    static let amountOfCellsOnOnePage: CGFloat = 4.0
    static let cellSize: CGSize = .init(width: LSConst.Device.width, height: 50)
    static var collectionHeight: CGSize = {
        return .init(width: 0, height: cellSize.height)
    }()
    
    static let itemSpacing: CGFloat = GlobalStyle.spacing
    static let lineSpacing: CGFloat = GlobalStyle.spacing
}
