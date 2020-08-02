//
//  ConsoleView.swift
//  Stoic
//
//  Created by Ritesh Pakala on 6/1/20.
//  Copyright © 2020 Ritesh Pakala. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class ConsoleView: UIView {
    var detailIsLoaded: Bool = false
    
    lazy var taskbarView: UIView = {
        let view: UIView = .init()
        view.backgroundColor = GlobalStyle.Colors.graniteGray
        view.isUserInteractionEnabled = true
        return view
    }()
    
    lazy var closeButton: UIButton = {
        let button: UIButton = .init()
        button.setTitle("X", for: .normal)
        button.setTitleColor(GlobalStyle.Colors.black, for: .normal)
        button.backgroundColor = GlobalStyle.Colors.graniteGray
        
        button.tag = 0
        
        return button
    }()
    
    lazy var minimizeButton: UIButton = {
        let button: UIButton = .init()
        button.setTitle("_", for: .normal)
        button.setTitleColor(GlobalStyle.Colors.black, for: .normal)
        button.backgroundColor = GlobalStyle.Colors.graniteGray
        
        button.tag = 0
        
        return button
    }()
    
    lazy var tickerLabel: UILabel = {
        let label: UILabel = .init()
        label.text = "$TSLA"
        label.textColor = GlobalStyle.Colors.black
        label.font = GlobalStyle.Fonts.courier(.medium, .bold)
        label.textAlignment = .left
        label.isUserInteractionEnabled = false
        return label
    }()
    
    let statusView: UILabel = {
        let label: UILabel = .init()
        label.text = ""
        label.textColor = GlobalStyle.Colors.purple
        label.font = GlobalStyle.Fonts.courier(.medium, .bold)
        return label
    }()
    
    let progressView: UILabel = {
        let label: UILabel = .init()
        label.text = ""
        label.textColor = .white
        label.font = GlobalStyle.Fonts.courier(.medium, .bold)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    lazy var detailView: ConsoleDetailView = {
        let view: ConsoleDetailView = .init(
            frame: .init(
                origin: .zero,
                size: .init(
                    width: baseSize.width,
                    height: baseSize.height - (baseSize.height*0.1))))
        view.isHidden = true
        return view
    }()
    
    lazy var predictingIndicator: SwiftyWaveView = {
        let view: SwiftyWaveView = .init(
        frame: .init(
            origin: .zero,
            size: .init(width: baseSize.width, height: baseSize.height*0.16)))
        
        return view
    }()
    
    var minimized: Bool {
        minimizeButton.tag == 1
    }
    
    let baseFrame: CGRect
    
    var baseSize: CGSize {
        return baseFrame.size
    }
    
    override init(frame: CGRect) {
        self.baseFrame = frame
        super.init(frame: frame)
        
        self.isUserInteractionEnabled = true
        self.backgroundColor = GlobalStyle.Colors.black.withAlphaComponent(0.75)
        
        addSubview(taskbarView)
        addSubview(statusView)
        addSubview(detailView)
        addSubview(progressView)
        addSubview(predictingIndicator)
        
        predictingIndicator.center = .init(
            x: self.center.x,
            y: self.center.y)
        
        taskbarView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(baseSize.height*0.1)
        }
        statusView.snp.makeConstraints { make in
            make.top.equalTo(taskbarView.snp.bottom).offset(GlobalStyle.padding)
            make.left.equalToSuperview().offset(GlobalStyle.spacing)
            make.right.equalToSuperview().offset(-GlobalStyle.spacing)
            make.height.equalTo(GlobalStyle.Fonts.FontSize.medium.rawValue)
        }
        progressView.snp.makeConstraints { make in
            make.top.equalTo(taskbarView.snp.bottom)
            make.left.equalToSuperview().offset(GlobalStyle.padding)
            make.right.equalToSuperview().offset(-GlobalStyle.padding)
            make.bottom.equalToSuperview()
        }
        detailView.snp.makeConstraints { make in
            make.top.equalTo(taskbarView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        
        taskbarView.addSubview(closeButton)
        taskbarView.addSubview(minimizeButton)
        taskbarView.addSubview(tickerLabel)
        
        closeButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-GlobalStyle.spacing)
            make.centerY.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.8)
            make.width.equalTo(taskbarView.snp.height).multipliedBy(0.8)
        }
        minimizeButton.snp.makeConstraints { make in
            make.right.equalTo(closeButton.snp.left).offset(-GlobalStyle.spacing)
            make.centerY.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.8)
            make.width.equalTo(taskbarView.snp.height).multipliedBy(0.8)
        }
        tickerLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(GlobalStyle.spacing)
            make.right.equalTo(minimizeButton.snp.left).offset(-GlobalStyle.spacing)
            make.centerY.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.8)
        }
        
        GlobalStyle.addShadow(toView: closeButton)
        GlobalStyle.addShadow(toView: minimizeButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ConsoleView {
    func tickerSizeDifference() -> CGSize {
        let tickerSize = tickerLabel.frame.size
        let sizeOfTicker = (tickerLabel.text ?? "").size(forFont: tickerLabel.font)
        
        return .init(
            width: abs(tickerSize.width - sizeOfTicker.width) - (GlobalStyle.spacing*2),
            height: tickerSize.height)
    }
    
    func minimizedTaskBarSize() -> CGSize {
        let taskbarSize: CGSize = taskbarView.frame.size
        
        return .init(
            width: abs(taskbarSize.width - tickerSizeDifference().width),
            height: taskbarSize.height)
    }
    
    func changeViewState(){
        
        statusView.isHidden = minimizeButton.tag == 0 || detailIsLoaded
        progressView.isHidden = minimizeButton.tag == 0 || detailIsLoaded
        detailView.isHidden = minimizeButton.tag == 0 || !detailIsLoaded
        predictingIndicator.isHidden = minimizeButton.tag == 0 || detailIsLoaded
        
        if minimizeButton.tag == 0 {
            
            taskbarView.snp.remakeConstraints { make in
                make.edges.equalToSuperview()
                make.height.equalToSuperview()
            }
            
            minimizeButton.tag = 1
        } else if minimizeButton.tag == 1 {
            
            taskbarView.snp.remakeConstraints { make in
                make.top.left.right.equalToSuperview()
                make.height.equalTo(baseSize.height*0.1)
            }
            
            minimizeButton.tag = 0
        }
        
        
    }
}

extension ConsoleView {
    func setDetailData(_ payload: ConsoleDetailPayload) {
        detailView.isHidden = minimizeButton.tag == 1
        detailView.updateData(payload)
    }
    
    func setTitle(_ title: String?) {
        self.tickerLabel.text = title
    }
    
    func setStatus(_ status: String?) {
        if status == nil {
            detailIsLoaded = true
            predictingIndicator.stop()
            statusView.text = nil
            progressView.isHidden = true
            
            statusView.snp.remakeConstraints { make in
                make.top.equalTo(taskbarView.snp.bottom).offset(GlobalStyle.padding)
                make.left.equalToSuperview().offset(GlobalStyle.spacing)
                make.right.equalToSuperview().offset(-GlobalStyle.spacing)
                make.height.equalTo(0)
            }
            progressView.snp.remakeConstraints { make in
                make.top.equalTo(taskbarView.snp.bottom).offset(GlobalStyle.padding)
                make.left.equalToSuperview().offset(GlobalStyle.padding)
                make.right.equalToSuperview().offset(-GlobalStyle.padding)
                make.height.equalTo(0)
            }
        } else {
            detailIsLoaded = false
            predictingIndicator.start()
            statusView.text = "/**** \(status?.localized ?? "") */"
            progressView.isHidden = false
            statusView.snp.makeConstraints { make in
                make.top.equalTo(taskbarView.snp.bottom).offset(GlobalStyle.padding)
                make.left.equalToSuperview().offset(GlobalStyle.spacing)
                make.right.equalToSuperview().offset(-GlobalStyle.spacing)
                make.height.equalTo(GlobalStyle.Fonts.FontSize.medium.rawValue)
            }
            progressView.snp.makeConstraints { make in
                make.top.equalTo(taskbarView.snp.bottom)
                make.left.equalToSuperview().offset(GlobalStyle.padding)
                make.right.equalToSuperview().offset(-GlobalStyle.padding)
                make.bottom.equalToSuperview()
            }
        }
    }
}
