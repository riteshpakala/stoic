//
//  ConsoleDetail.ModelSelector.swift
//  Stoic
//
//  Created by Ritesh Pakala on 11/23/20.
//  Copyright © 2020 Ritesh Pakala. All rights reserved.
//

import Granite
import Foundation
import UIKit

//MARK: Historical
class ConsoleDetailModelView: GraniteView, PickerDelegate {
    lazy var modelPicker: GenericPicker = {
        return .init(color: GlobalStyle.Colors.purple)
    }()
    
    lazy var indicator: TriangleView = {
        let triangle: TriangleView = .init(
            frame: .zero,
            color: GlobalStyle.Colors.purple)
        triangle.backgroundColor = GlobalStyle.Colors.black
        return triangle
    }()
    
    var expand: Bool = false {
        didSet {
            DispatchQueue.main.async {
                if self.expand {
                    self.modelPicker.snp.remakeConstraints { make in
                        make.left.equalToSuperview()
                        make.width.equalToSuperview()
                        make.height.equalTo(self.expandSize)
                        make.top.equalToSuperview().offset(self.modelPicker.frame.origin.y)
                    }
                    
                    self.modelPicker.backgroundColor = GlobalStyle.Colors.black.withAlphaComponent(0.75)
                } else {
                    self.modelPicker.snp.remakeConstraints { make in
                        make.left.equalToSuperview()
                        make.width.equalToSuperview()
                        make.height.equalToSuperview()
                        make.centerY.equalToSuperview()
                    }
                    
                    self.modelPicker.backgroundColor = GlobalStyle.Colors.black.withAlphaComponent(0.0)
                    self.modelPicker.scrollTo(self.currentIndex, animated: true)
                }
            }
        }
    }
    
    lazy var tapGestureTableView: UITapGestureRecognizer = {
        return .init(target: self, action: #selector(self.tapRegistered(_:)))
    }()
    
    var expandSize: CGFloat {
        self.cellsToViewWhenExpanded * self.modelPicker.cellHeight
    }
    var cellHeight: CGFloat {
        didSet {
            modelPicker.cellHeight = cellHeight
        }
    }
    var cellsToViewWhenExpanded: CGFloat
    
    private var currentIndex: Int = 0 {
        didSet {
            updateModel()
        }
    }
    init(
        cellHeight: CGFloat = 30,
        cellsToViewWhenExpanded: CGFloat = 3) {
        self.cellHeight = cellHeight
        self.cellsToViewWhenExpanded = cellsToViewWhenExpanded
        
        super.init(frame: .zero)
        
        backgroundColor = .clear
        
        modelPicker.cellHeight = cellHeight
        modelPicker.pickerDelegate = self
        
        addSubview(modelPicker)
        addSubview(indicator)
        
        self.modelPicker.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.indicator.snp.makeConstraints { make in
            make.right.equalTo(modelPicker.snp.right).offset(-GlobalStyle.padding)
            make.centerY.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.19)
            make.width.equalTo(indicator.snp.height).multipliedBy(1.3)
        }
        
        indicator.addGestureRecognizer(tapGestureTableView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func updateData(_ data: StockKitModels) {
        cellHeight = self.frame.height
            
        modelPicker.data = StockKitModels.ModelType.allCases.map { "\($0)" }
        modelPicker.expandedPadding = Int(cellsToViewWhenExpanded - 1)
    }
    
    func updateModel() {
        
    }
    
    @objc
    func tapRegistered(_ sender: UITapGestureRecognizer) {
        expand.toggle()
        indicator.rotate()
    }
    
    func didSelect(index: Int) {
        guard index < (modelPicker.data.count) else {
            return
        }
        DispatchQueue.main.async {
            self.feedbackGenerator.impactOccurred()
            self.currentIndex = index
        }
    }
}
