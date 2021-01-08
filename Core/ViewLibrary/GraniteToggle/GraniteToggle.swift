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
    public struct Options {
        let labels: [String]
        public init(_ options: [String]) {
            labels = options
        }
    }
    
    let options: GraniteToggle.Options
    
    public init(options: GraniteToggle.Options) {
        self.options = options
    }
    
    public var body: some View {
        HStack(spacing: Brand.Padding.large) {
            
            ForEach(0..<options.labels.count,
                    id: \.self) { index in
                
                GraniteText(options.labels[index],
                            .headline,
                            .bold,
                            style: .init(selectionColor: .black),
                            selected: selected == index).onTapGesture {
                                self.selected = index
                            }
            }
        }
    }
}
