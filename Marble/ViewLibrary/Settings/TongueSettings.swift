//
//  TongueSettings.swift
//  Stoic
//
//  Created by Ritesh Pakala on 8/20/20.
//  Copyright © 2020 Ritesh Pakala. All rights reserved.
//


import Granite
import Foundation
import UIKit

class TongueSettings: GraniteView {
    
    lazy var tongueView: UIView = {
        let view: UIView = .init()
        view.backgroundColor = GlobalStyle.Colors.black
        view.layer.cornerRadius = 8.0
        return view
    }()
    
    lazy var container: UIView = {
        let view: UIView = .init()
        view.backgroundColor = GlobalStyle.Colors.black
        return view
    }()
    
    lazy var indicator: TriangleView = {
        let view: TriangleView = .init(
            frame: .zero,
            color: GlobalStyle.Colors.green,
            direction: .right)
        view.backgroundColor = .clear
        return view
    }()
    
    private(set) lazy var collection: (view: UICollectionView, layout: UICollectionViewLayout) = {
        
        let layout: UICollectionViewLayout
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 0.0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.sectionInset = .zero
        flowLayout.scrollDirection = .vertical
        layout = flowLayout
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.backgroundColor = .clear
        view.alwaysBounceVertical = true
        
        
        return (view, layout)
    }()
    
    lazy var tapGesture: UITapGestureRecognizer = {
        return .init(target: self, action: #selector(self.tapRegistered(_:)))
    }()
    
    let tongueSize: CGSize
    
    public var isOpen: Bool = false
    
    public var edge: UIRectEdge = .left {
        willSet {
            updateAppearance(true)
        }
    }
    
    public lazy var settingsItems: [TongueSettingsModel] = {
        let model1: TongueSettingsModel = TongueSettingsModel.init(
            title: "Senti..",
            subText: "..ment",
            value: "1")
        let model2: TongueSettingsModel = TongueSettingsModel.init(
            title: "Days",
            subText: "seen",
            value: "7")
        let model3: TongueSettingsModel = TongueSettingsModel.init(
            title: "Subscr..",
            subText: "..iption",
            value: "on")
        
        return [model1, model2, model3]
    }()
    
    public init(
        tongueSize: CGSize = .init(width: 42, height: 66)) {
        self.tongueSize = tongueSize
        super.init(frame: .zero)
        
        addSubview(tongueView)
        tongueView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.left.bottom.equalToSuperview()
            make.height.equalTo(tongueSize.height)
        }
        
        tongueView.addSubview(indicator)
        self.indicator.snp.makeConstraints { make in
            make.centerX.equalToSuperview().multipliedBy(1.5)
            make.centerY.equalToSuperview()
            make.height.equalTo(tongueSize.width/3)
            make.width.equalTo(tongueSize.width/3)
        }
        
        addSubview(container)
        container.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-tongueSize.width)
            make.left.bottom.top.equalToSuperview()
        }
        
        tongueView.addGestureRecognizer(tapGesture)
        
        collection.view.dataSource = self
        collection.view.delegate = self
        collection.view.register(
            TongueSettingsCell.self,
            forCellWithReuseIdentifier: "\(TongueSettingsCell.self)")
        container.addSubview(collection.view)
        collection.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        updateAppearance(true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    func tapRegistered(_ sender: UITapGestureRecognizer) {
        feedbackGenerator.impactOccurred()
        isOpen.toggle()
        indicator.rotate(by: CGFloat.pi)
        updateAppearance()
    }
    
    func updateAppearance(_ isLayout: Bool = false) {
        if edge == .right && isLayout {
            self.indicator.snp.remakeConstraints { make in
                make.centerX.equalToSuperview().multipliedBy(0.5)
                make.centerY.equalToSuperview()
                make.height.equalTo(tongueSize.width/3)
                make.width.equalTo(tongueSize.width/3)
            }
            
            container.snp.remakeConstraints { make in
                make.left.equalToSuperview().offset(tongueSize.width)
                make.right.bottom.top.equalToSuperview()
            }
            
            container.roundCorners(
                corners: .topLeft,
                radius: 8.0)
        } else if edge == .left && isLayout {
            self.indicator.snp.remakeConstraints { make in
                make.centerX.equalToSuperview().multipliedBy(1.5)
                make.centerY.equalToSuperview()
                make.height.equalTo(tongueSize.width/3)
                make.width.equalTo(tongueSize.width/3)
            }
            
            container.snp.remakeConstraints { make in
                make.right.equalToSuperview().offset(-tongueSize.width)
                make.left.bottom.top.equalToSuperview()
            }
            
            container.roundCorners(
                corners: .topRight,
                radius: 8.0)
        }
        
        if (!isOpen && !isLayout) || (!isOpen && isLayout) {
            self.snp.remakeConstraints { make in
                make.size.equalTo(self.frame.size)
                
                if self.edge == .left {
                    make.left.equalToSuperview().offset(-abs(self.frame.width - tongueSize.width))
                } else if self.edge == .right {
                    make.right.equalToSuperview().offset(abs(self.frame.width - tongueSize.width))
                }
                
                make.bottom.equalTo(superview?.safeAreaLayoutGuide.snp.bottom ?? self.safeAreaLayoutGuide.snp.bottom).offset(-GlobalStyle.padding*3)
            }
        }
        
        if (isOpen && !isLayout) || (isOpen && isLayout) {
            self.snp.remakeConstraints { make in
                make.size.equalTo(self.frame.size)
                
                if self.edge == .left {
                    make.left.equalTo(0)
                } else if self.edge == .right {
                    make.right.equalTo(0)
                }
                
                make.bottom.equalTo(superview?.safeAreaLayoutGuide.snp.bottom ?? self.safeAreaLayoutGuide.snp.bottom).offset(-GlobalStyle.padding*3)
            }
        }
    }
}

extension TongueSettings: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int {
        return settingsItems.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return .init(
            width: collectionView.frame.size.width,
            height: collectionView.frame.size.height/CGFloat(settingsItems.count))
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView
            .dequeueReusableCell(
                withReuseIdentifier: "\(TongueSettingsCell.self)",
                for: indexPath) as? TongueSettingsCell else {
            return .init()
        }
        
        cell.titleLabel.text = settingsItems[indexPath.item].title
        cell.subtitleLabel.text = settingsItems[indexPath.item].subText
        cell.valueLabel.text = settingsItems[indexPath.item].value
        cell.color = (indexPath.item + 1) % 2 == 0 ? GlobalStyle.Colors.purple : GlobalStyle.Colors.green
        
        return cell
    }
}

extension UIView {
   func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}

struct TongueSettingsModel {
    var title: String
    var subText: String
    var value: String
}

class TongueSettingsCell: UICollectionViewCell {
    lazy var titleLabel: UILabel = {
        let label: UILabel = .init()
        label.font = GlobalStyle.Fonts.courier(.small, .bold)
        label.textAlignment = .left
        return label
    }()
    
    lazy var subtitleLabel: UILabel = {
        let label: UILabel = .init()
        label.font = GlobalStyle.Fonts.courier(.small, .bold)
        label.textAlignment = .right
        return label
    }()
    
    lazy var valueLabel: UILabel = {
        let label: UILabel = .init()
        label.font = GlobalStyle.Fonts.courier(.large, .bold)
        label.textAlignment = .center
        return label
    }()
    
    public var color: UIColor = GlobalStyle.Colors.purple {
        didSet {
            titleLabel.textColor = color
            subtitleLabel.textColor = color
            valueLabel.textColor = color
        }
    }
    
    override func awakeFromNib() {
        
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(GlobalStyle.spacing)
            make.right.equalToSuperview()
            make.height.equalTo(titleLabel.font.lineHeight)
        }
        contentView.addSubview(subtitleLabel)
        subtitleLabel.snp.makeConstraints { make in
            make.bottom.right.equalToSuperview().offset(-GlobalStyle.spacing)
            make.left.equalToSuperview()
            make.height.equalTo(subtitleLabel.font.lineHeight)
        }
        contentView.addSubview(valueLabel)
        valueLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom)
            make.bottom.equalTo(subtitleLabel.snp.top)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
