//
//  SearchComponent.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/2/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

public struct SearchComponent: GraniteComponent {
    @ObservedObject
    public var command: GraniteCommand<SearchCenter, SearchState> = .init()
    
    public init() {}
    
    public var body: some View {
        
        VStack {
            HStack {
                HStack {
                    Image("search_icon")
                        .resizable()
                        .frame(width: 20, height: 20, alignment: .leading)
                        .padding(.leading, Brand.Padding.medium)
                    
                    TextField("search markets", text: _state.query)
                        .onChange(of: state.query,
                                  perform: { q in
                                print("{TEST} typeing \(q)")
                            return sendEvent(SearchEvents.Query(q))
                        })
                        .background(Color.clear)
                        .textFieldStyle(PlainTextFieldStyle())
                        .font(Fonts.live(.headline, .regular))
                        .onTapGesture {
                            _state.isEditing.wrappedValue = true
                        }.frame(height: 36)
                }.background(Brand.Colors.greyV2.opacity(0.13))
                .cornerRadius(6.0)
                .padding(.leading, Brand.Padding.large)
                .padding(.trailing, Brand.Padding.large)
     
                if state.isEditing {
                    Group {
                        Button(action: {
                            _state.isEditing.wrappedValue = false
                            state.query = ""

                        }) {
                            GraniteText("cancel", .subheadline, .regular)


                        }
                        .buttonStyle(PlainButtonStyle())
                        .padding(.trailing, Brand.Padding.large)
                        .transition(.move(edge: .trailing))
                        .animation(.default)
                    }
                }
            }
        }
    }
}

#if os(macOS)
extension NSTextField {
    open override var focusRingType: NSFocusRingType {
        get { .none }
        set { }
    }
}
#endif
