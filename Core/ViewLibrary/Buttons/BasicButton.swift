//
//  BasicButton.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/4/21.
//

import SwiftUI

struct BasicButton: View {
    var body: some View {
        HStack(alignment: .center) {
            
            ZStack {
                
                Rectangle().frame(
                    width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/,
                    height: 75)
                    .background(Brand.Colors.yellow)
                
                Rectangle().frame(
                    width: 90,
                    height: 60)
                    .background(Brand.Colors.grey)
                
                Text("Create").granite_innerShadow(
                    Brand.Colors.white,
                    radius: 3,
                    offset: .init(x: 2, y: 2))
                .multilineTextAlignment(.center)
                .font(Fonts.live(.subheadline, .regular))
            }
        }
    }
}

struct BasicButton_Previews: PreviewProvider {
    static var previews: some View {
        BasicButton()
    }
}
