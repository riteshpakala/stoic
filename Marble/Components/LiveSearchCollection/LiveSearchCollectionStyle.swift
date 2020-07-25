//
//  CollectionStyle.swift
//  Stoic
//
//  Created by Ritesh Pakala on 6/1/20.
//  Copyright (c) 2020 Ritesh Pakala. All rights reserved.
//

import Foundation
import UIKit

struct LiveSearchCollectionStyle {
    static let cellSize: CGSize = .init(width: 120, height: 25)
    static var collectionHeight: CGSize = {
        return .init(width: 0, height: cellSize.height)
    }()
    static let itemSpacing: CGFloat = GlobalStyle.padding
    static let lineSpacing: CGFloat = GlobalStyle.padding
}
