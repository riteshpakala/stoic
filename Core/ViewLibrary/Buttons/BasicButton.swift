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
                Brand.Colors.yellow.overlay(
                    
                    GraniteText(text,
                                Brand.Colors.black,
                                .subheadline,
                                .bold,
                                .center)
//                    Brand.Colors.black.opacity(0.36).overlay(
//
//
//                        Text(text)
//                        .multilineTextAlignment(.center)
//                        .font(Fonts.live(.subheadline, .bold))
//
//                    )
//                    .cornerRadius(8.0)
////                    .padding(.top, Brand.Padding.medium)
////                    .padding(.leading, Brand.Padding.large)
////                    .padding(.trailing, Brand.Padding.large)
////                    .padding(.bottom, Brand.Padding.medium)
//                    .frame(width: 80, height: 36, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
//                    .shadow(color: .black, radius: 4, x: 2, y: 2)
                )
                .cornerRadius(8.0)
//                .frame(maxHeight: 66)
                .frame(width: 120, height: 48, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .shadow(color: .black, radius: 4, x: 2, y: 2)
                
            }
        }
    }
}

//struct BasicButton_Previews: PreviewProvider {
//    static var previews: some View {
//        BasicButton()
//    }
//}
