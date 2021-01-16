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
                GradientView(colors: [Brand.Colors.yellow,
                                      Brand.Colors.salmon],
                             cornerRadius: 6.0,
                             direction: .topLeading).overlay(
                    
                    GraniteText(text,
                                Brand.Colors.black,
                                .subheadline,
                                .bold,
                                .center)
                        .shadow(color: Color.black.opacity(0.42),
                                radius: 3, x: 1, y: 1)
                )
                .frame(width: 120, height: 36, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                
            }
        }
    }
}

//struct BasicButton_Previews: PreviewProvider {
//    static var previews: some View {
//        BasicButton()
//    }
//}
