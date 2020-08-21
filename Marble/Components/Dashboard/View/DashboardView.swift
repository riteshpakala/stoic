//
//  DashboardView.swift
//  Stoic
//
//  Created by Ritesh Pakala on 6/1/20.
//  Copyright (c) 2020 Ritesh Pakala. All rights reserved.
//
import Granite
import Foundation
import UIKit

public class DashboardView: GraniteView {
    lazy var settings: TongueSettings = {
        let view: TongueSettings = .init()
        view.backgroundColor = .clear
        return view
    }()
    
    var parent: UIView?
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(settings)
        settings.snp.makeConstraints { make in
            make.size.equalTo(CGSize.init(width: 112, height: 200))
            make.left.equalToSuperview().offset(-abs(112 - settings.tongueSize.width))
            make.bottom.equalTo(
                self.safeAreaLayoutGuide.snp.bottom)
                .offset(-GlobalStyle.padding*3)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
	
    override public func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard let view = super.hitTest(point, with: event), view == self else {
            return super.hitTest(point, with: event)
        }

        return parent
    }
}
