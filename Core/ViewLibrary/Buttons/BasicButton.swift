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
                    
                    
                    Brand.Colors.black.opacity(0.36).overlay(
                        
                        
                        Text(text).granite_innerShadow(
                            Brand.Colors.white,
                            radius: 1,
                            offset: .init(x: 0.5, y: 0.5))
                        .multilineTextAlignment(.center)
                        .font(Fonts.live(.subheadline, .bold))
                        
                    )
                    .cornerRadius(8.0)
                    .frame(width: 80, height: 36, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .shadow(color: .black, radius: 4, x: 2, y: 2)
                )
                .cornerRadius(8.0)
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
