//
//  Picker.swift
//  Stoic
//
//  Created by Ritesh Pakala on 7/24/20.
//  Copyright © 2020 Ritesh Pakala. All rights reserved.
//

import Foundation
import UIKit

class GenericPicker: Picker, UITableViewDataSource {
    var data: [String] = [] {
        didSet {
            DispatchQueue.main.async {
                self.reloadData()
            }
        }
    }
    
    override init(color: UIColor) {
        super.init(color: color)
        self.dataSource = self
        self.layer.borderWidth = 0.0
        self.backgroundColor = .clear
        self.separatorStyle = .none
        self.showsVerticalScrollIndicator = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
        data.count + expandedPadding
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.dequeueReusableCell(
            withIdentifier: "\(PickerCell.self)",
            for: indexPath)
        
        if  let tradingCell = cell as? PickerCell,
            indexPath.item < data.count {
            
            tradingCell.label.text = data[indexPath.item]
            tradingCell.label.textColor = color
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        Haptic.onChangeLineSegment()
    }
    
    override func scrollTo(_ index: Int, animated: Bool = false) {
        guard index < data.count else { return }
        super.scrollTo(index, animated: animated)
    }
}

class StockDatePicker: Picker, UITableViewDataSource {
    var data: [StockData] = [] {
        didSet {
            DispatchQueue.main.async {
                self.reloadData()
            }
        }
    }
    
    override init(color: UIColor) {
        super.init(color: color)
        self.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
        data.count + expandedPadding
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.dequeueReusableCell(
            withIdentifier: "\(PickerCell.self)",
            for: indexPath)
        
        if  let tradingCell = cell as? PickerCell,
            indexPath.item < data.count {
            
            tradingCell.label.text = data[indexPath.item].dateData.asString
            tradingCell.label.textColor = color
        }
        
        return cell
    }
    
    override func scrollTo(_ index: Int, animated: Bool = false) {
        guard index < data.count else { return }
        super.scrollTo(index, animated: animated)
    }
}

class DaysPicker: Picker, UITableViewDataSource {
    var days: Int = 0 {
        didSet {
            DispatchQueue.main.async {
                self.reloadData()
                self.scrollTo(self.currentDay)
            }
        }
    }
    
    var currentDay: Int = 0
    
    override init(color: UIColor) {
        super.init(color: color)
        self.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
        days
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.dequeueReusableCell(
            withIdentifier: "\(PickerCell.self)",
            for: indexPath)
        
        if let tradingCell = cell as? PickerCell {
            let day = days - indexPath.item
            let dayText = "day\(day > 1 ? "s" : "")".localized.lowercased()
            tradingCell.label.text = "\(day) \(dayText)"
            tradingCell.label.textColor = color
        }
        
        return cell
    }
    
    override func scrollTo(_ index: Int, animated: Bool = false) {
        guard index < days else { return }
        super.scrollTo(index, animated: animated)
    }
}

protocol PickerDelegate: class {
    func didSelect(index: Int)
}

class Picker: UITableView {
    weak var pickerDelegate: PickerDelegate?
    
    let color: UIColor
    
    var cellHeight: CGFloat = 30
    
    var expandedPadding: Int = 0 {
        didSet {
            DispatchQueue.main.async {
                self.reloadData()
            }
        }
    }
    
    init(color: UIColor) {
        self.color = color
        super.init(frame: .zero, style: .plain)
        
        self.register(PickerCell.self, forCellReuseIdentifier: "\(PickerCell.self)")
        
        self.backgroundColor = GlobalStyle.Colors.black
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = 3.0
        self.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func scrollTo(_ index: Int, animated: Bool = false) {
        self.setContentOffset(
            .init(
                x: 0,
                y: cellHeight*CGFloat(index)),
            animated: true)
    }
}

extension Picker: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath) {
        
        pickerDelegate?.didSelect(index: indexPath.item)
    }
    
    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
}

class PickerCell: UITableViewCell {
    let label: UILabel = {
        let view: UILabel = .init()
        view.text = ""
        view.textColor = GlobalStyle.Colors.green
        view.font = GlobalStyle.Fonts.courier(.medium, .bold)
        view.textAlignment = .left
        return view
    }()
    
    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?) {
        super.init(
            style: style,
            reuseIdentifier: reuseIdentifier)
        
        backgroundColor = GlobalStyle.Colors.black.withAlphaComponent(0.5)
        contentView.backgroundColor = GlobalStyle.Colors.black.withAlphaComponent(0.5)
        
        self.selectionStyle = .none
        
        contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(GlobalStyle.padding)
            make.right.equalToSuperview().offset(-GlobalStyle.padding)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        label.text = ""
    }
}
