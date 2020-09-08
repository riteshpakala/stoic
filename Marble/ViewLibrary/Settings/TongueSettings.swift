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

class TongueSettings<T>: GraniteView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    lazy var tongueView: UIView = {
        let view: UIView = .init()
        view.backgroundColor = GlobalStyle.Colors.marbleBrown
        view.layer.cornerRadius = 8.0
        return view
    }()
    
    lazy var container: UIView = {
        let view: UIView = .init()
        view.backgroundColor = GlobalStyle.Colors.marbleBrown
        view.layer.masksToBounds = true
        view.clipsToBounds = true
        return view
    }()
    
    lazy var indicator: TriangleView = {
        let view: TriangleView = .init(
            frame: .zero,
            color: GlobalStyle.Colors.black,
            direction: .left)
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
        view.alwaysBounceVertical = false
        
        return (view, layout)
    }()
    
    lazy var tapGesture: UITapGestureRecognizer = {
        return .init(target: self, action: #selector(self.tapRegistered(_:)))
    }()
    
    let tongueSize: CGSize
    
    public var isOpen: Bool = false
    
    public var edge: UIRectEdge = .left {
        didSet {
            updateAppearance(true)
        }
    }
    
    public var settingsItems: [TongueSettingsModel<T>] {
        didSet {
            DispatchQueue.main.async {
                self.setup()
                self.collection.view.reloadData()
            }
        }
    }
    
    struct Helpers {
        var isActive: Bool = false
        var labels: [UILabel] = []
        
        static var basicLabel: UILabel {
            let label: UILabel = .init()
            label.font = GlobalStyle.Fonts.courier(.small, .bold)
            label.textAlignment = .center
            label.textColor = GlobalStyle.Colors.black
            label.isHidden = true
            label.backgroundColor = GlobalStyle.Colors.marbleBrown
            return label
        }
        
        mutating func reset() {
            labels.forEach { label in
                label.isHidden = true
                label.removeFromSuperview()
            }
            
            labels.removeAll()
            
            isActive = false
        }
    
    }
    
    var helpers: Helpers = .init()
    
    public init(
        settingsItems: [TongueSettingsModel<T>] = [],
        tongueSize: CGSize = .init(width: 42, height: 66)) {
        self.settingsItems = settingsItems
        self.tongueSize = tongueSize
        super.init(frame: .zero)
        
        self.backgroundColor = .clear
        
        addSubview(tongueView)
        tongueView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.left.bottom.equalToSuperview()
            make.height.equalTo(tongueSize.height)
        }
        
        tongueView.addSubview(indicator)
        self.indicator.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-tongueSize.width/3)
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
        
        setup()
    }
    
    func setup() {
        self.helpers.reset()
        for i in 0..<self.settingsItems.count {
            self.helpers.labels.append(Helpers.basicLabel)
            self.helpers.labels[i].text = self.settingsItems[i].help
            self.helpers.labels[i].sizeToFit()
            self.addSubview(self.helpers.labels[i])
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
        if isOpen {
            collapse()
        } else {
            open()
        }
    }
    
    func open() {
        isOpen = true
        indicator.rotate(by: CGFloat.pi)
        updateAppearance()
    }
    
    func collapse() {
        isOpen = false
        indicator.rotate(by: CGFloat.pi)
        updateAppearance()
    }
    
    func updateAppearance(_ isLayout: Bool = false) {
        container.isHidden = !isOpen
        
        if edge == .right && isLayout {
            if self.indicator.isActive {
                self.indicator.rotate(by: CGFloat.pi, active: false)
            }
            self.indicator.snp.remakeConstraints { make in
                make.left.equalToSuperview().offset(tongueSize.width/3)
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
            if !self.indicator.isActive {
                self.indicator.rotate(by: CGFloat.pi)
            }
            self.indicator.snp.remakeConstraints { make in
                make.right.equalToSuperview().offset(-tongueSize.width/3)
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
    
    func showHelpers(forceActive: Bool = false, forceHide: Bool = false) {
        if forceActive && helpers.isActive {
            return
        }
        
        guard !helpers.isActive, !forceHide else {
            helpers.labels.forEach { label in
                label.isHidden = true
            }

            helpers.isActive = false
            return
        }
        
        for i in 0..<settingsItems.count {
            guard let cell = collection.view.dequeueReusableCell(
                withReuseIdentifier: "\(TongueSettingsCell.self)",
                for: IndexPath.init(item: i, section: 0)) as? TongueSettingsCell else {
                    continue
            }
            
            helpers.labels[i].isHidden = false
            helpers.labels[i].frame.origin = .init(x: container.frame.maxX, y: (cell.frame.maxY - cell.frame.height/2) - helpers.labels[i].frame.size.height/2)
        }
        
        helpers.isActive = true
    }
    
    @objc func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int {
        return settingsItems.count + 1
    }
    
    @objc func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath) {
        feedbackGenerator.impactOccurred()
        
        guard indexPath.item < settingsItems.count else {
            showHelpers()
            
            return
        }
        
        bubbleEvent(settingsItems[indexPath.item].selector)
    }
    
    @objc func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return .init(
            width: collectionView.frame.size.width,
            height: collectionView.frame.size.height/CGFloat(settingsItems.count + 1))
    }
    
    @objc func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView
            .dequeueReusableCell(
                withReuseIdentifier: "\(TongueSettingsCell.self)",
                for: indexPath) as? TongueSettingsCell else {
            return .init()
        }
        cell.layoutIfNeeded()
        guard indexPath.item < self.settingsItems.count else {
            cell.valueLabel.text = "i"
            cell.valueLabel.font = GlobalStyle.Fonts.courier(.medium, .bold)
            return cell
        }
        cell.valueLabel.font = GlobalStyle.Fonts.courier(.small, .bold)
        if settingsItems[indexPath.item].isResource {
            cell.imageView.isHidden = false
            cell.imageView.image = UIImage.init(named: settingsItems[indexPath.item].value)
        } else {
            cell.imageView.isHidden = true
            cell.valueLabel.text = settingsItems[indexPath.item].value
        }
        
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

struct TongueSettingsModel<T> {
    var help: String
    var label: String
    var value: String
    var isResource: Bool
    var reference: T
    var selector: Event
    
    public init(
        help: String,
        label: String,
        value: String,
        isResource: Bool,
        selector: Event,
        reference: T) {
        
        self.help = help
        self.label = label
        self.value = value
        self.isResource = isResource
        self.reference = reference
        self.selector = selector
    }
}

class TongueSettingsCell: UICollectionViewCell {
    lazy var imageView: UIImageView = {
        let view: UIImageView = .init()
        view.backgroundColor = .clear
        view.contentMode = .scaleAspectFit
        view.isHidden = true
        view.tintColor = GlobalStyle.Colors.black
        return view
    }()
    
    lazy var valueContainer: UIView = {
        let view: UIView = .init()
        view.backgroundColor = .clear
//        view.layer.borderWidth = 2.0
//        view.layer.borderColor = GlobalStyle.Colors.graniteGray.cgColor
        return view
    }()
    
    lazy var valueLabel: UILabel = {
        let label: UILabel = .init()
        label.font = GlobalStyle.Fonts.courier(.small, .bold)
        label.textAlignment = .center
        label.textColor = GlobalStyle.Colors.black
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(valueContainer)
        valueContainer.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().inset(GlobalStyle.padding+GlobalStyle.spacing)
            make.height.equalTo(valueContainer.snp.width)
        }
        valueContainer.addSubview(valueLabel)
        valueLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().inset(4)
            make.height.equalTo(valueContainer.snp.width)
        }
        
        valueContainer.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalToSuperview().inset(floor(GlobalStyle.padding/1.2))
            make.height.equalTo(valueContainer.snp.width)
        }
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        valueContainer.layer.cornerRadius = valueContainer.frame.size.width/2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        valueLabel.text = ""
        imageView.image = nil
        imageView.isHidden = true
    }
}
