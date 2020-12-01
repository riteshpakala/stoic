//
//  ConsoleDeatil.Sentiment.swift
//  Stoic
//
//  Created by Ritesh Pakala on 11/23/20.
//  Copyright © 2020 Ritesh Pakala. All rights reserved.
//

import Granite
import Foundation
import UIKit

//MARK: Sentiment
protocol ConsoleDetailSentimentViewDelegate: class {
    func sentimentChanged(
        _ positive: Double,
        negative: Double,
        neutral: Double,
        compound: Double)
}
class ConsoleDetailSentimentView: GraniteView {
    enum SentimentDetail: String {
        case positive = "positive"
        case negative = "negative"
        case neutral = "neutral"
        case delta = "leaning"
        case negCompound = "| -neg bias"
        case posCompound = "| -pos bias"
    }
    
    weak var delegate: ConsoleDetailSentimentViewDelegate?
    
    lazy var compoundSlider: UISlider = {
        let view: UISlider = .init(frame: .zero)
        view.tintColor = GlobalStyle.Colors.orange
        view.setValue(0.5, animated: false)
        view.addTarget(self, action: #selector(self.sliderValue(_:)), for: .valueChanged)
        return view
    }()
    
    lazy var refineSlider: UISlider = {
        let view: UISlider = .init(frame: .zero)
        view.tintColor = GlobalStyle.Colors.orange
        view.setValue(0.0, animated: false)
        view.addTarget(self, action: #selector(self.sliderValue(_:)), for: .valueChanged)
        return view
    }()
    
    lazy var slider: UISlider = {
        let view: UISlider = .init(frame: .zero)
        view.tintColor = GlobalStyle.Colors.orange
        view.setValue(0.5, animated: false)
        view.addTarget(self, action: #selector(self.sliderValue(_:)), for: .valueChanged)
        return view
    }()
    
    lazy var seperator1: UIView = {
        let label = UIView.init()
        label.backgroundColor = GlobalStyle.Colors.orange
        return label
    }()
    
    lazy var seperator2: UIView = {
        let label = UIView.init()
        label.backgroundColor = GlobalStyle.Colors.orange
        return label
    }()
    
    lazy var emotionTitleLabel: UILabel = {
        let label = UILabel.init()
        label.textAlignment = .center
        label.textColor = GlobalStyle.Colors.orange
        label.font = GlobalStyle.Fonts.courier(.small, .bold)
        label.numberOfLines = 1
        label.text = "neutral".localized
        return label
    }()
    
    lazy var emotionLabel: UILabel = {
        let label = UILabel.init()
        label.textAlignment = .center
        label.textColor = GlobalStyle.Colors.orange
        label.font = GlobalStyle.Fonts.courier(.small, .bold)
        label.numberOfLines = 1
        label.text = "[50%:50%]"
        return label
    }()
    
    lazy var refineLabel: UILabel = {
        let label = UILabel.init()
        label.textAlignment = .center
        label.textColor = GlobalStyle.Colors.orange
        label.font = GlobalStyle.Fonts.courier(.small, .bold)
        label.numberOfLines = 1
        label.text = "Δ:0%"
        label.isHidden = true
        return label
    }()
    
    lazy var compoundLabel: UILabel = {
        let label = UILabel.init()
        label.textAlignment = .center
        label.textColor = GlobalStyle.Colors.orange
        label.font = GlobalStyle.Fonts.courier(.small, .bold)
        label.numberOfLines = 1
        label.text = "λ:0"
        label.isHidden = true
        return label
    }()
    
    lazy var hStack: UIStackView = {
        let stack = UIStackView.init(
            arrangedSubviews: [
                refineSlider,
                seperator1,
                slider,
                seperator2,
                compoundSlider])
        stack.alignment = .center
        stack.distribution = .fill
        stack.axis = .horizontal
        stack.setCustomSpacing(GlobalStyle.padding, after: refineSlider)
        stack.setCustomSpacing(GlobalStyle.padding, after: seperator1)
        stack.setCustomSpacing(GlobalStyle.padding, after: slider)
        stack.setCustomSpacing(GlobalStyle.padding, after: seperator2)
        return stack
    }()
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .clear
        
        addSubview(hStack)
        addSubview(emotionLabel)
        addSubview(refineLabel)
        addSubview(compoundLabel)
        addSubview(emotionTitleLabel)
        
        hStack.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(GlobalStyle.padding)
            make.right.equalToSuperview().offset(-GlobalStyle.padding)
            make.height.equalToSuperview().multipliedBy(0.75)
            make.bottom.equalTo(-GlobalStyle.padding)
        }
        
        refineSlider.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.24)
        }
        
        compoundSlider.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.24)
        }
        
        seperator1.snp.makeConstraints { make in
            make.width.equalTo(GlobalStyle.spacing/2)
            make.height.equalToSuperview().multipliedBy(0.6)
        }
        seperator2.snp.makeConstraints { make in
            make.width.equalTo(GlobalStyle.spacing/2)
            make.height.equalToSuperview().multipliedBy(0.6)
        }
        
        refineLabel.sizeToFit()
        emotionLabel.sizeToFit()
        compoundLabel.sizeToFit()
        emotionTitleLabel.sizeToFit()
        
        refineLabel.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.25)
        }
        emotionLabel.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.25)
        }
        compoundLabel.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.25)
        }
        
        emotionTitleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(GlobalStyle.padding)
            make.right.equalToSuperview().offset(-GlobalStyle.padding)
            make.top.equalToSuperview()
            make.height.equalTo(emotionTitleLabel.frame.height)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        emotionLabel.center = .init(
            x: self.center.x,
            y: hStack.frame.maxY)
    }
    
    func updateSlider(
        _ sentiment: StockSentimentData) {
        DispatchQueue.main.async {
            self.refineSlider.setValue(
                Float(sentiment.neuAverage),
                animated: true)
            
            self.slider.setValue(
                Float(0.5 + (0.5*(sentiment.posAverage-sentiment.negAverage))),
                animated: true)
            
            
            self.compoundSlider.setValue(
                Float(0.5*(1.0 + sentiment.compoundAverage)),
                animated: true)
            
            self.updateEmotionCharacteristics(
                neuPercent: Int(sentiment.neuAverage*100),
                negPercent: Int(sentiment.negAverage*100),
                posPercent: Int(sentiment.posAverage*100),
                compound: Float(sentiment.compoundAverage))
            
            self.updateEmotionTrack()
        }
    }
    
    @objc func sliderValue(
        _ slider: UISlider) {
        
        let neuValue = self.refineSlider.value
        var posValue = self.slider.value
        var negValue = abs(self.slider.value - 1.0)
        
        let compoundValue1 = self.compoundSlider.value
        let compoundValue2 = abs(self.compoundSlider.value - 1.0)
        
        let diff = abs(1.0 - (posValue + negValue + neuValue))
        posValue -= diff/2
        negValue -= diff/2
        posValue = posValue < 0 ? 0 : posValue
        negValue = negValue < 0 ? 0 : negValue
        
        let posPercent = Int(posValue*100)
        let negPercent = Int(negValue*100)
        let neuPercent = Int(neuValue*100)
        var compound = round((compoundValue1 - compoundValue2)*100)/100
        compound = compound > -0.01 && compound < 0.01 ? 0.0 : compound
        
        updateEmotionCharacteristics(
            neuPercent: neuPercent,
            negPercent: negPercent,
            posPercent: posPercent,
            compound: compound)
        
        
        updateEmotionTrack()
        
        delegate?.sentimentChanged(
            Double(posValue),
            negative: Double(negValue),
            neutral: Double(neuValue),
            compound: Double(compound))
        
    }
    
    func updateEmotionCharacteristics(
        neuPercent: Int,
        negPercent: Int,
        posPercent: Int,
        compound: Float,
        padding: Int = 5) {
        
        refineLabel.text = "Δ:\(neuPercent)%"
        emotionLabel.text = "[\(negPercent)%:\(posPercent)%]"
        compoundLabel.text = "λ:\(compound)"
        
        var characteristics: [SentimentDetail] = []
        
        if neuPercent > padding {
            //Refine General Emotion
            characteristics.append(.delta)
        }
        
        if negPercent > posPercent + 5 {
            //Negative Emotion
            characteristics.append(.negative)
        } else if posPercent > negPercent + 5 {
            //Positive Emotion
            characteristics.append(.positive)
        } else {
            //Neutral Emotion
            characteristics.append(.neutral)
        }
        
        if compound > 0.0 {
            //Positive words
            characteristics.append(.posCompound)
        } else if compound < 0.0{
            //Negative words
            characteristics.append(.negCompound)
        } else {
            //Neutral words
        }
        
        let finalStatement: String = characteristics.map { $0.rawValue.localized }.joined(separator: " ")
        emotionTitleLabel.text = finalStatement
    }
    
    func updateEmotionTrack() {
        refineLabel.isHidden = false
        compoundLabel.isHidden = false
        
        emotionLabel.center = .init(
            x: slider.thumbCenterX + GlobalStyle.padding,
            y: hStack.frame.maxY)
        
        refineLabel.center = .init(
            x: refineSlider.thumbCenterX + GlobalStyle.padding,
            y: hStack.frame.maxY)
        
        compoundLabel.center = .init(
            x: compoundSlider.thumbCenterX + GlobalStyle.padding,
            y: hStack.frame.maxY)
    }
}
extension UISlider {
    var thumbCenterX: CGFloat {
        let trackRect = self.trackRect(forBounds: frame)
        let thumbRect = self.thumbRect(forBounds: bounds, trackRect: trackRect, value: value)
        return thumbRect.midX
    }
}
