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
        return .init(width: LSConst.Device.width, height: 50 + collectionHeight.height + GlobalStyle.padding)
    }()
    
    static let searchSpinnerSize: CGFloat = 24.0
    
    static let amountOfCellsOnOnePage: CGFloat = 4.0
    static let cellSize: CGSize = .init(width: 120, height: 25)
    static let headerCellSize: CGSize = .init(width: 66, height: 25)
    static var collectionHeight: CGSize = {
        return .init(width: 0, height: cellSize.height+GlobalStyle.spacing)
    }()
    
    static let itemSpacing: CGFloat = GlobalStyle.padding
    static let lineSpacing: CGFloat = GlobalStyle.padding
}
