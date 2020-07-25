//
//  Picker.swift
//  Stoic
//
//  Created by Ritesh Pakala on 7/24/20.
//  Copyright © 2020 Ritesh Pakala. All rights reserved.
//

import Foundation
import UIKit

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
        data.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.dequeueReusableCell(
            withIdentifier: "\(PickerCell.self)",
            for: indexPath)
        
        if let tradingCell = cell as? PickerCell {
            tradingCell.label.text = data[indexPath.item].dateData.asString
            tradingCell.label.textColor = color
        }
        
        return cell
    }
}

class DaysPicker: Picker, UITableViewDataSource {
    var days: Int = 0 {
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
        days
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.dequeueReusableCell(
            withIdentifier: "\(PickerCell.self)",
            for: indexPath)
        
        print("{TEST} \(cell.frame)")
        if let tradingCell = cell as? PickerCell {
            let day = days - indexPath.item
            tradingCell.label.text = "\(day) day\(day > 1 ? "s" : "")"
            tradingCell.label.textColor = color
        }
        
        return cell
    }
}

class Picker: UITableView {
    let color: UIColor
    
    var cellHeight: CGFloat = 30
    
    init(color: UIColor) {
        self.color = color
        super.init(frame: .zero, style: .plain)
        
        self.register(PickerCell.self, forCellReuseIdentifier: "\(PickerCell.self)")
        
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = 3.0
        self.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension Picker: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath) {
        
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
        
        backgroundColor = .clear
        
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
}
