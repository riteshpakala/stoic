//
//  GraniteToggle.swift
//  * stoic (iOS)
//
//  Created by Ritesh Pakala on 1/7/21.
//

import Foundation
import GraniteUI
import SwiftUI

public struct GraniteToggle: View {
    @State var selected: Int = 0
    var onToggle: ((Int) -> Void)
    
    public struct Options {
        let labels: [String]
        public init(_ options: [String]) {
            labels = options
        }
    }
    
    let options: GraniteToggle.Options
    
    public init(options: GraniteToggle.Options, onToggle: @escaping ((Int) -> Void)) {
        self.options = options
        self.onToggle = onToggle
    }
    
    public var body: some View {
        HStack(spacing: Brand.Padding.medium) {
            
            ForEach(0..<options.labels.count,
                    id: \.self) { index in
                
                GraniteText(options.labels[index],
                            .headline,
                            .bold,
                            style: .init(selectionColor: .black),
                            selected: selected == index).onTapGesture {
                                
                                GraniteHaptic.light.invoke()
                                self.selected = index
                                self.onToggle(index)
                            }
            }
        }
    }
}
