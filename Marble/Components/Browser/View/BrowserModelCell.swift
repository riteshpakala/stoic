//
//  BrowserModelCell.swift
//  Stoic
//
//  Created by Ritesh Pakala on 9/6/20.
//  Copyright © 2020 Ritesh Pakala. All rights reserved.
//

import Granite
import Foundation
import UIKit

public class BrowserModelCell: UICollectionViewCell {
    lazy var valueContainer: UIView = {
        let view: UIView = .init()
        view.backgroundColor = .clear
//        view.layer.borderWidth = 2.0
//        view.layer.borderColor = GlobalStyle.Colors.graniteGray.cgColor
        return view
    }()
    
    lazy var valueLabel: UILabel = {
        let label: UILabel = .init()
        label.font = GlobalStyle.Fonts.courier(.large, .bold)
        label.textAlignment = .left
        label.textColor = GlobalStyle.Colors.green
        return label
    }()
    
    var model: StockModelMergedObject? = nil {
        didSet {
            stock = model?.stock.asSearchStock ?? SearchStock.init(exchangeName: "unknown", symbolName: "unknown", companyName: "unknown")
            guard let models = model?.models else { return }
            
            var stockModels: [StockModel] = []
            for item in models {
                if let stockModelObject = item as? StockModelObject {
                    let stockModel = StockModel.init(from: stockModelObject)
                    stockModels.append(stockModel)
                }
            }
            self.stockModels = stockModels
        }
    }
    
    var stock: SearchStock? = nil {
        didSet {
            valueLabel.text = stock?.symbol
        }
    }
    
    var stockModels: [StockModel] = [] {
        didSet {
            maxDayOfCells = CGFloat(self.stockModels.map({ $0.days }).max() ?? 0)
            
            DispatchQueue.main.async {
                print("{Browser} \(self.stockModels.count)")
                self.collection.view.reloadData()
            }
        }
    }
    
    lazy var maxDays: Int = {
        return PredictionRules.init().maxDays
    }()
    
    var maxDayOfCells: CGFloat = 1
    
    lazy var stackView: GraniteStackView = {
        let view: GraniteStackView = GraniteStackView.init(
            arrangedSubviews: [
                valueContainer,
                collection.view
            ]
        )
        
        view.axis = .vertical
        view.alignment = .fill
        view.distribution = .fill
        view.spacing = GlobalStyle.spacing
        
        return view
    }()
    
    private(set) lazy var collection: (view: UICollectionView,
            layout: UICollectionViewLayout) = {

        let layout: UICollectionViewLayout
        let flowLayout = UICollectionViewFlowLayout()
//        flowLayout.itemSize = CGSize(width: 200.0, height: 144.0)
//        flowLayout.sectionInset = UIEdgeInsets(
//            top: SharedStyle.padding,
//            left: SharedStyle.padding,
//            bottom: SharedStyle.padding,
//            right: SharedStyle.padding)
        
        
        flowLayout.minimumInteritemSpacing = GlobalStyle.spacing
        flowLayout.minimumLineSpacing = GlobalStyle.padding
        flowLayout.scrollDirection = .horizontal
        layout = flowLayout

        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.backgroundColor = .clear
        view.alwaysBounceVertical = false
        view.isPrefetchingEnabled = false
        
        view.contentInsetAdjustmentBehavior = .never
        return (view, layout)
    }()
    
    override public func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let panGestureRecognizer = UIPanGestureRecognizer(
            target: self,
            action: #selector(BrowserModelCell.panGestureRecognized(_:)))
        self.panGestureRecognizer = panGestureRecognizer
        addGestureRecognizer(panGestureRecognizer)
        collection.view.dataSource = self
        collection.view.delegate = self
        collection.view.register(
            BrowserModelDataCell.self,
            forCellWithReuseIdentifier: identify(BrowserModelDataCell.self))
        
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        valueContainer.snp.makeConstraints { make in
            make.height.equalTo(valueLabel.font.lineHeight)
            
        }
        valueContainer.addSubview(valueLabel)
        valueLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override public func layoutIfNeeded() {
        super.layoutIfNeeded()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func prepareForReuse() {
        super.prepareForReuse()
        
        valueLabel.text = ""
        stockModels = []
        stock = nil
    }
    
    //MARK: -- Variables for card style experience
    // MARK: Gesture Recognizer

    private var panGestureRecognizer: UIPanGestureRecognizer?

    private var panGestureTranslation: CGPoint = .zero

    private var tapGestureRecognizer: UITapGestureRecognizer?

    // MARK: Drag Animation Settings

    static var maximumRotation: CGFloat = 1.0

    static var rotationAngle: CGFloat = CGFloat(Double.pi) / 10.0

    static var animationDirectionY: CGFloat = 1.0

    static var swipePercentageMargin: CGFloat = 0.6

    // MARK: Card Finalize Swipe Animation

    static var finalizeSwipeActionAnimationDuration: TimeInterval = 0.8

    // MARK: Card Reset Animation

    static var cardViewResetAnimationSpringBounciness: CGFloat = 10.0

    static var cardViewResetAnimationSpringSpeed: CGFloat = 20.0

    static var cardViewResetAnimationDuration: TimeInterval = 0.2
    
    // MARK: - Pan Gesture Recognizer

    @objc private func panGestureRecognized(_ gestureRecognizer: UIPanGestureRecognizer) {
        panGestureTranslation = gestureRecognizer.translation(in: self)

        switch gestureRecognizer.state {
        case .began:
            let initialTouchPoint = gestureRecognizer.location(in: self)
            let newAnchorPoint = CGPoint(x: initialTouchPoint.x / bounds.width, y: initialTouchPoint.y / bounds.height)
            let oldPosition = CGPoint(x: bounds.size.width * layer.anchorPoint.x, y: bounds.size.height * layer.anchorPoint.y)
            let newPosition = CGPoint(x: bounds.size.width * newAnchorPoint.x, y: bounds.size.height * newAnchorPoint.y)
            layer.anchorPoint = newAnchorPoint
            layer.position = CGPoint(x: layer.position.x - oldPosition.x + newPosition.x, y: layer.position.y - oldPosition.y + newPosition.y)

            removeAnimations()
            layer.rasterizationScale = UIScreen.main.scale
            layer.shouldRasterize = true
        case .changed:
            let rotationStrength = min(panGestureTranslation.x / frame.width, BrowserModelCell.maximumRotation)
            let rotationAngle = BrowserModelCell.animationDirectionY * BrowserModelCell.rotationAngle * rotationStrength

            var transform = CATransform3DIdentity
            transform = CATransform3DRotate(transform, rotationAngle, 0, 0, 1)
            transform = CATransform3DTranslate(transform, panGestureTranslation.x, panGestureTranslation.y, 0)
            layer.transform = transform
        case .ended:
            endedPanAnimation()
            layer.shouldRasterize = false
        default:
            resetCardViewPosition()
            layer.shouldRasterize = false
        }
    }

    private var dragDirection: SwipeDirection? {
        let normalizedDragPoint = panGestureTranslation.normalizedDistanceForSize(bounds.size)
        return SwipeDirection.allDirections.reduce((distance: CGFloat.infinity, direction: nil), { closest, direction -> (CGFloat, SwipeDirection?) in
            let distance = direction.point.distanceTo(normalizedDragPoint)
            if distance < closest.distance {
                return (distance, direction)
            }
            return closest
        }).direction
    }

    private var dragPercentage: CGFloat {
        guard let dragDirection = dragDirection else { return 0.0 }

        let normalizedDragPoint = panGestureTranslation.normalizedDistanceForSize(frame.size)
        let swipePoint = normalizedDragPoint.scalarProjectionPointWith(dragDirection.point)

        let rect = SwipeDirection.boundsRect

        if !rect.contains(swipePoint) {
            return 1.0
        } else {
            let centerDistance = swipePoint.distanceTo(.zero)
            let targetLine = (swipePoint, CGPoint.zero)

            return rect.perimeterLines
                .flatMap { CGPoint.intersectionBetweenLines(targetLine, line2: $0) }
                .map { centerDistance / $0.distanceTo(.zero) }
                .min() ?? 0.0
        }
    }

    private func endedPanAnimation() {
//        if let dragDirection = dragDirection, dragPercentage >= SwipeableView.swipePercentageMargin {
//            let translationAnimation = POPBasicAnimation(propertyNamed: kPOPLayerTranslationXY)
//            translationAnimation?.duration = SwipeableView.finalizeSwipeActionAnimationDuration
//            translationAnimation?.fromValue = NSValue(cgPoint: POPLayerGetTranslationXY(layer))
//            translationAnimation?.toValue = NSValue(cgPoint: animationPointForDirection(dragDirection))
//            layer.pop_add(translationAnimation, forKey: "swipeTranslationAnimation")
//            self.delegate?.didEndSwipe(onView: self)
//        } else {
//            resetCardViewPosition()
//        }
    }

    private func animationPointForDirection(_ direction: SwipeDirection) -> CGPoint {
        let point = direction.point
        let animatePoint = CGPoint(x: point.x * 4, y: point.y * 4)
        let retPoint = animatePoint.screenPointForSize(UIScreen.main.bounds.size)
        return retPoint
    }

    private func resetCardViewPosition() {
        removeAnimations()

//        // Reset Translation
//        let resetPositionAnimation = POPSpringAnimation(propertyNamed: kPOPLayerTranslationXY)
//        resetPositionAnimation?.fromValue = NSValue(cgPoint:POPLayerGetTranslationXY(layer))
//        resetPositionAnimation?.toValue = NSValue(cgPoint: CGPoint.zero)
//        resetPositionAnimation?.springBounciness = SwipeableView.cardViewResetAnimationSpringBounciness
//        resetPositionAnimation?.springSpeed = SwipeableView.cardViewResetAnimationSpringSpeed
//        resetPositionAnimation?.completionBlock = { _, _ in
//            self.layer.transform = CATransform3DIdentity
//        }
//        layer.pop_add(resetPositionAnimation, forKey: "resetPositionAnimation")
//
//        // Reset Rotation
//        let resetRotationAnimation = POPBasicAnimation(propertyNamed: kPOPLayerRotation)
//        resetRotationAnimation?.fromValue = POPLayerGetRotationZ(layer)
//        resetRotationAnimation?.toValue = CGFloat(0.0)
//        resetRotationAnimation?.duration = SwipeableView.cardViewResetAnimationDuration
//        layer.pop_add(resetRotationAnimation, forKey: "resetRotationAnimation")
    }

    private func removeAnimations() {
//        pop_removeAllAnimations()
//        layer.pop_removeAllAnimations()
    }
}

extension BrowserModelCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout  {
    public func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int {
        return stockModels.count
    }
    
    public func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView
            .dequeueReusableCell(
                withReuseIdentifier: identify(BrowserModelDataCell.self),
                for: indexPath)
        
        guard let dataCell = cell as? BrowserModelDataCell else {
            return cell
        }
        
        dataCell.model = stockModels[indexPath.item]
        
        return dataCell
    }
    
    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return  .init(
            width: self.frame.size.width,
            height: collectionView.frame.height)
    }
    
    public func collectionView(
        _ collectionView: UICollectionView,
        didEndDisplaying cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
    }
    
    public func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath) {
        
    }
    
    var estimatedSize: CGSize {
        self.stackView.systemLayoutSizeFitting(UIView.layoutFittingExpandedSize)
    }
}

import CoreGraphics

enum SwipeDirection {
    case left
    case right
    case up
    case down
    case topLeft
    case topRight
    case bottomLeft
    case bottomRight

    static var allDirections: [SwipeDirection] {
        return [.left, .right, .up, .down, .topLeft, .topRight, .bottomLeft, .bottomRight]
    }

    var horizontalPosition: HorizontalPosition {
        switch self {
        case .left:
            return .left
        case .right:
            return .right
        case .up:
            return .middle
        case .down:
            return .middle
        case .topLeft:
            return .left
        case .topRight:
            return .right
        case .bottomLeft:
            return .left
        case .bottomRight:
            return .right
        }
    }

    var verticalPosition: VerticalPosition {
        switch self {
        case .left:
            return .middle
        case .right:
            return .middle
        case .up:
            return .top
        case .down:
            return .bottom
        case .topLeft:
            return .top
        case .topRight:
            return .top
        case .bottomLeft:
            return .bottom
        case .bottomRight:
            return .bottom
        }
    }

    var point: CGPoint {
        return CGPoint(x: horizontalPosition.rawValue, y: verticalPosition.rawValue)
    }

    enum HorizontalPosition: CGFloat {
        case left = -1
        case middle = 0
        case right = 1
    }

    enum VerticalPosition: CGFloat {
        case top = -1
        case middle = 0
        case bottom = 1
    }

    static var boundsRect: CGRect {
        let w = HorizontalPosition.right.rawValue - HorizontalPosition.left.rawValue
        let h = VerticalPosition.bottom.rawValue - VerticalPosition.top.rawValue
        return CGRect(x: HorizontalPosition.left.rawValue, y: VerticalPosition.top.rawValue, width: w, height: h)
    }

}

typealias CGLine = (start: CGPoint, end: CGPoint)

extension CGRect {

    var topLine: CGLine {
        return (SwipeDirection.topLeft.point, SwipeDirection.topRight.point)
    }
    var leftLine: CGLine {
        return (SwipeDirection.topLeft.point, SwipeDirection.bottomLeft.point)
    }
    var bottomLine: CGLine {
        return (SwipeDirection.bottomLeft.point, SwipeDirection.bottomRight.point)
    }
    var rightLine: CGLine {
        return (SwipeDirection.topRight.point, SwipeDirection.bottomRight.point)
    }

    var perimeterLines: [CGLine] {
        return [topLine, leftLine, bottomLine, rightLine]
    }

}

extension CGPoint {

    func distanceTo(_ point: CGPoint) -> CGFloat {
        return sqrt(pow(point.x - self.x, 2) + pow(point.y - self.y, 2))
    }

    func normalizedDistanceForSize(_ size: CGSize) -> CGPoint {
        // multiplies by 2 because coordinate system is (-1,1)
        let x = 2 * (self.x / size.width)
        let y = 2 * (self.y / size.height)
        return CGPoint(x: x, y: y)
    }

    func scalarProjectionPointWith(_ point: CGPoint) -> CGPoint {
        let r = scalarProjectionWith(point) / point.modulo
        return CGPoint(x: point.x * r, y: point.y * r)
    }

    func scalarProjectionWith(_ point: CGPoint) -> CGFloat {
        return dotProductWith(point) / point.modulo
    }

    func dotProductWith(_ point: CGPoint) -> CGFloat {
        return (self.x * point.x) + (self.y * point.y)
    }

    var modulo: CGFloat {
        return sqrt(self.x*self.x + self.y*self.y)
    }

    static func intersectionBetweenLines(_ line1: CGLine, line2: CGLine) -> CGPoint? {
        let (p1,p2) = line1
        let (p3,p4) = line2

        var d = (p4.y - p3.y) * (p2.x - p1.x) - (p4.x - p3.x) * (p2.y - p1.y)
        var ua = (p4.x - p3.x) * (p1.y - p4.y) - (p4.y - p3.y) * (p1.x - p3.x)
        var ub = (p2.x - p1.x) * (p1.y - p3.y) - (p2.y - p1.y) * (p1.x - p3.x)
        if (d < 0) {
            ua = -ua; ub = -ub; d = -d
        }

        if d != 0 {
            return CGPoint(x: p1.x + ua / d * (p2.x - p1.x), y: p1.y + ua / d * (p2.y - p1.y))
        }
        return nil
    }

    func screenPointForSize(_ screenSize: CGSize) -> CGPoint {
        let x = 0.5 * (1 + self.x) * screenSize.width
        let y = 0.5 * (1 + self.y) * screenSize.height
        return CGPoint(x: x, y: y)
    }

}
