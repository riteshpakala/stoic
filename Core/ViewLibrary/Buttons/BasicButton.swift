//
//  BasicButton.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/4/21.
//

import SwiftUI

struct BasicButton: View {
    var text: String
    
    var body: some View {
        HStack(alignment: .center) {
            
            ZStack {
                GradientView(colors: [Brand.Colors.marbleV2.opacity(0.66),
                                      Brand.Colors.marble.opacity(0.24)],
                             cornerRadius: 6.0,
                             direction: .topLeading).overlay(
                    
                    GraniteText(text,
                                Brand.Colors.black,
                                .subheadline,
                                .bold,
                                .center)
                )
                .frame(width: 120, height: 36, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .background(Brand.Colors.salmon.cornerRadius(6.0)
                                .shadow(color: Color.black, radius: 6.0, x: 3.0, y: 2.0))
                
            }
        }
    }
}

//struct BasicButton_Previews: PreviewProvider {
//    static var previews: some View {
//        BasicButton()
//    }
//}
