//
//  ConsoleDetail.Prediction.swift
//  Stoic
//
//  Created by Ritesh Pakala on 11/23/20.
//  Copyright © 2020 Ritesh Pakala. All rights reserved.
//

import Granite
import Foundation
import UIKit

//MARK: Prediction
protocol ConsoleDetailPredictionViewDelegate: class {
    func thinking()
    func predictionUpdate(_ output: Double)
}
class ConsoleDetailPredictionView: GraniteView {
    weak var delegate: ConsoleDetailPredictionViewDelegate?
    
    lazy var thinkTriggerContainer: UIView = {
        let view: UIView = .init()
        view.isUserInteractionEnabled = true
        view.clipsToBounds = false
        return view
    }()
    lazy var thinkTrigger: UIView = {
        let view: UIView = .init()
        view.isUserInteractionEnabled = true
        view.clipsToBounds = false
        return view
    }()
    
    lazy var predictionLabel: UILabel = {
        let label = UILabel.init()
        label.textAlignment = .center
        label.textColor = GlobalStyle.Colors.purple
        label.font = GlobalStyle.Fonts.courier(.medium, .bold)
        label.text = "close: $0000.00"
        label.numberOfLines = 0
        return label
    }()
    
    lazy var vStack: UIStackView = {
        let stack = UIStackView.init(
            arrangedSubviews: [
                predictionLabel])
        stack.alignment = .fill
        stack.distribution = .fill
        stack.axis = .vertical
        stack.spacing = GlobalStyle.spacing
        return stack
    }()
    
    lazy var tapGesture: UITapGestureRecognizer = {
        return .init(target: self, action: #selector(self.tapRegistered(_:)))
    }()
    
    private var model: StockKitModels? = nil
    private var stockData: [StockData]? = nil
    private var emitterSize: CGFloat
    init(emitterSize: CGFloat = 48, minified: Bool = false) {
        self.emitterSize = emitterSize
        super.init(frame: .zero)
        
        backgroundColor = .clear
        
        if !minified {
            addSubview(vStack)
            
            self.vStack.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(GlobalStyle.spacing)
                make.right.equalToSuperview().offset(-GlobalStyle.spacing)
                make.top.equalToSuperview().offset(GlobalStyle.padding)
            }
            
            addSubview(thinkTriggerContainer)
            thinkTriggerContainer.addSubview(thinkTrigger)
            thinkTriggerContainer.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(GlobalStyle.spacing)
                make.right.equalToSuperview().offset(-GlobalStyle.spacing)
                make.top.equalTo(self.vStack.snp.bottom).offset(GlobalStyle.spacing)
                make.bottom.equalToSuperview()
            }
            thinkTrigger.snp.makeConstraints { make in
                make.center.equalToSuperview()
                make.width.height.equalTo(emitterSize)
            }
        } else {
            addSubview(thinkTriggerContainer)
            thinkTriggerContainer.addSubview(thinkTrigger)
            thinkTriggerContainer.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            thinkTrigger.snp.makeConstraints { make in
                make.center.equalToSuperview()
                make.width.height.equalTo(emitterSize)
            }
        }
        
        
        layoutIfNeeded()
        
        thinkTrigger.addGestureRecognizer(tapGesture)
        
        thinkTrigger.layer.cornerRadius = (emitterSize)/2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        thinkTrigger.thinkingEmitter(
            forSize: .init(
                width: emitterSize,
                height: emitterSize),
            lifetime: 0.75)
    }
    
    @objc
    func tapRegistered(_ sender: UITapGestureRecognizer) {
        feedbackGenerator.impactOccurred()
        delegate?.thinking()
        thinkTriggerContainer.thinkingEmitter(
            forSize: thinkTriggerContainer.bounds.size,
            renderMode: .backToFront,
            color: GlobalStyle.Colors.purple)
        sender.isEnabled = false
        
        bubbleEvent(DetailEvents.Think())
    }
    
    func stopAnimation() {
        DispatchQueue.main.async {
            self.tapGesture.isEnabled = true
            self.thinkTriggerContainer
                .layer.sublayers?.removeAll(
                where: {
                    ($0 as? CAEmitterLayer) != nil
            })
        }
    }
    
    func updateModel(
        model: StockKitModels,
        stockData: [StockData]) {
        self.model = model
        self.stockData = stockData
        predict()
    }
    
    public func predict(
        positive: Double = 0.5,
        negative: Double = 0.5,
        neutral: Double = 0.0,
        compound: Double = 0.0) {
        
        stopAnimation()
        
        guard let recentStock = self.stockData?.sorted(
            by: {
                ($0.dateData.asDate ?? Date())
                    .compare(($1.dateData.asDate ?? Date())) == .orderedDescending
                
        }).first else { return}
        
        DispatchQueue.init(label: "stoic.predicting").async { [weak self] in
            
            guard let modelType = self?.model?.currentType else {
                return
            }
            let testData = DataSet(
               dataType: .Regression,
               inputDimension: modelType.inDim,
               outputDimension: StockKitUtils.outDim)
            
            let sentimentWeights = StockSentimentData.emptyWithValues(
                positive: positive,
                negative: negative,
                neutral: neutral,
                compound: compound)
            
            do {
                let dataSet = StockKitUtils.Models.DataSet(
                    recentStock,
                    sentimentWeights,
                    modelType: modelType,
                    updated: true)
                
                print("********************\nPREDICTING\n\(dataSet.description)")
                
                try testData.addTestDataPoint(
                   input: dataSet.asArray)
            }
            catch {
               print("Invalid data set created")
            }
            
            //DEV:
            self?.model?.current?.predictValues(data: testData)
            
            if let set = self?.model?.current?.dataSet {
                for item in set.inputs {
                    print("{TEST} \(item)")
                }
            }
       
            DispatchQueue.main.async {
                guard let output = testData.singleOutput(index: 0) else {
                    self?.predictionLabel.text = "open: $⚠️\nclose: $⚠️"
                    return
                }

                self?.delegate?.predictionUpdate(output)
                print("[Prediction Output] :: \(output)")

                self?.predictionLabel.text = StockKitUtils.Models.DataSet.outputLabel(output)

                guard !output.isNaN else { return }
                self?.bubbleEvent(
                    DetailEvents.PredictionDidUpdate(
                        close: output,
                        stockSentimentData: sentimentWeights),
                    async: DispatchQueue.init(label: "stoic.prediction.didUpdate"))
                
            }
        }
    }
}
