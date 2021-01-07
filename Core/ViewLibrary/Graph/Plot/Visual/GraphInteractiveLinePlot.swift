//
//  RHInteractiveLinePlot.swift
//  RHLinePlot
//
//  Created by Wirawit Rueopas on 4/9/20.
//  Copyright © 2020 Wirawit Rueopas. All rights reserved.
//

import SwiftUI

public struct GraphInteractiveLinePlot<StickLabel, Indicator>: View
    where StickLabel: View, Indicator: View
{
    public typealias Value = CGFloat
    public enum SegmentSearchStrategy {
        /// Use binary search to search for active segment in O(log(no. of segments)). No extra space needed.
        case binarySearch
        
        /// TODO: Store mapping of value index -> segment index for O(1) lookup.?
        /// However we keep an extra O(no. of `values`) space.
        /// Also how to keep cache in SwiftUI's View? (w/o resorting to global cache)
        // case cacheLookup
    }
    
    let nonPredictionCount: Int
    let values: [Value]
    let dates: [Date]
    let nonPredictionDates: [Date]
    let predictionDates: [Date]
    let lineSegmentStartingIndices: [Int]?
    let showGlowingIndicator: Bool
    
    /// Relative width that the line plot is occupying (from 0 to 1)
    let occupyingRelativeWidth: CGFloat
    let valueStickLabelBuilder: (Value) -> StickLabel
    
    /// Notify when the index selected is changed
    let didSelectValueAtIndex: ((Int?) -> Void)?
    
    /// Notify when the segment index selected is changed
    let didSelectSegmentAtIndex: ((Int?) -> Void)?
    
    let customLatestValueIndicator: () -> Indicator
    
    /// Strategy to use to search for an active segment.
    let segmentSearchStrategy: SegmentSearchStrategy
    
    @State var isDragging: Bool = false
    @GestureState var isDraggingG: Bool = false
    @State private var draggableIndicatorOffset: CGFloat = 0
    @State private var currentlySelectedIndex: Int? = nil
    @State private var currentlySelectedSegmentIndex: Int? = nil
    
    @Environment(\.graphLinePlotConfig) var graphLinePlotConfig
    
    public init(
        nonPredictionCount: Int,
        values: [Value],
        dates: [Date],
        nonPredictionDates: [Date],
        predictionDates: [Date],
        occupyingRelativeWidth: CGFloat = 1.0,
        showGlowingIndicator: Bool = false,
        lineSegmentStartingIndices: [Int]? = nil,
        segmentSearchStrategy: SegmentSearchStrategy = .binarySearch,
        didSelectValueAtIndex: ((Int?) -> Void)? = nil,
        didSelectSegmentAtIndex: ((Int?) -> Void)? = nil,
        @ViewBuilder
        customLatestValueIndicator: @escaping () -> Indicator,
        @ViewBuilder
        valueStickLabel: @escaping (Value) -> StickLabel
    ) {
        self.nonPredictionCount = nonPredictionCount
        self.values = values
        self.dates = dates
        self.nonPredictionDates = nonPredictionDates
        self.predictionDates = predictionDates
        self.occupyingRelativeWidth = occupyingRelativeWidth
        self.lineSegmentStartingIndices = lineSegmentStartingIndices
        self.didSelectValueAtIndex = didSelectValueAtIndex
        self.didSelectSegmentAtIndex = didSelectSegmentAtIndex
        self.valueStickLabelBuilder = valueStickLabel
        self.showGlowingIndicator = showGlowingIndicator
        self.customLatestValueIndicator = customLatestValueIndicator
        self.segmentSearchStrategy = segmentSearchStrategy
    }
    
    // TODO: How to build this cache *once* for the view?
//    private func buildIndexToSegmentLookupCache(segments: [Int]) -> [Int] {
//        var cache = Array<Int>(repeating: -1, count: self.values.count)
//        let allSplitPoints = segments + [self.values.count]
//        let segmentLocations = zip(allSplitPoints, allSplitPoints[1...])
//        for (i, sp) in segmentLocations.enumerated() {
//            // Exclusive `to`
//            let (from, to) = sp
//            cache.replaceSubrange((from..<to), with: repeatElement(i, count: to-from))
//        }
//        return cache
//    }
    
    public var body: some View {
        GeometryReader { proxy in
            self.makeGraphBody(proxy: proxy)
        }
    }
    
    func linePlot() -> some View {
        return GraphLinePlot(
            nonPredictionCount: nonPredictionCount,
            values: values,
            dates: dates,
            nonPredictionDates: nonPredictionDates,
            predictionDates: predictionDates,
            occupyingRelativeWidth: occupyingRelativeWidth,
            showGlowingIndicator: showGlowingIndicator,
            lineSegmentStartingIndices: lineSegmentStartingIndices,
            activeSegment: currentlySelectedSegmentIndex,
            customLatestValueIndicator: customLatestValueIndicator
        )
    }
    
    var stickAndLabelOpacity: Double {
        isDragging ? 1 : 0
    }
    
    func makeGraphBody(proxy: GeometryProxy) -> some View {
        // Full edge-adjusted canvas, used in placing the stick label
        let canvasFrame = getAdjustedStrokeEdgesCanvasFrame(proxy: proxy, graphLinePlotConfig: self.graphLinePlotConfig)
        
        // Shrinked canvas taking into account the relative width,
        // used for placing the value stick & dragging
        let relativeWidthCanvas: CGRect = {
            var c = canvasFrame
            c.size.width = occupyingRelativeWidth * canvasFrame.width
            return c
        }()
        
        // Currently selected index on screen
        // NOTE: Use 0 if nil for convenience
        let effectiveIndex = self.currentlySelectedIndex ?? 0
        let currentValue = values[effectiveIndex]
        
        // Get value stick (vertical line that appears on user drag)
        // Compute its offset & text translation
        let valueStickLabel = valueStickLabelBuilder(currentValue)
        let valueStickOffset = getValueStickOffset(canvas: relativeWidthCanvas)
        
        let canvasWidthWithoutAdjust = proxy.size.width
        let canvasHeightWithoutAdjust = proxy.size.height
        
        // Clamp to not go out of plot bounds
        // We need proxy here to calculate the label size dynamically
        func labelTranslation(labelProxy: GeometryProxy) -> CGAffineTransform {
            // Unlike stick, *without translation, label is centered.
            //
            // First we align center of label to the stick:
            // [LABEL]
            //    |
            let centering = -canvasWidthWithoutAdjust/2 + valueStickOffset
            let labelWidth = labelProxy.size.width
            let centeringClamped = centering.clamp(
                low: -canvasWidthWithoutAdjust/2 + labelWidth/2,
                high: canvasWidthWithoutAdjust/2 - labelWidth/2)
            return CGAffineTransform(translationX: centeringClamped, y: -(Brand.Padding.large + Brand.Padding.small))
        }
        
        let valueStickYOffset = (canvasHeightWithoutAdjust/2 + (Brand.Padding.large + Brand.Padding.small + Brand.Padding.large))
        return ZStack {//(spacing: rhPlotConfig.spaceBetweenValueStickAndStickLabel) {
            
            // Value Stick Label
            // HACK: We get a dynamic size of value stick label through `overlay`.
            // We hide the bottom one and just use it for sizing.
            valueStickLabel.opacity(0)
                .overlay(
                    GeometryReader { labelProxy in
                        valueStickLabel
                            .transformEffect(labelTranslation(labelProxy: labelProxy))
                    }.opacity(stickAndLabelOpacity))
            
            // Line Plot
            linePlot()
                .padding(EdgeInsets(
                    top: 0,
                    leading: 0,
                    bottom: 0,
                    trailing: 0))
                .overlay(
                    // Value Stick
                    LinePlotValueStick(lineWidth: graphLinePlotConfig.valueStickWidth)
                        .opacity(isDragging ? 0.75 : 0.0)
                        .offset(x: valueStickOffset-(graphLinePlotConfig.valueStickWidth/2), y: -valueStickYOffset)
                        .foregroundColor(graphLinePlotConfig.valueStickColor),
                    alignment: .leading
            )
                .contentShape(Rectangle())
                .gesture(touchAndDrag(canvas: relativeWidthCanvas))
//            .overlay(pressAndDragProxyView(canvas: relativeWidthCanvas))
        }
    }
}

// Default indicator
public extension GraphInteractiveLinePlot where Indicator == GlowingIndicator {
    init(
        nonPredictionCount: Int,
        values: [Value],
        dates: [Date],
        nonPredictionDates: [Date],
        predictionDates: [Date],
        occupyingRelativeWidth: CGFloat = 1.0,
        showGlowingIndicator: Bool = false,
        lineSegmentStartingIndices: [Int]? = nil,
        segmentSearchStrategy: SegmentSearchStrategy = .binarySearch,
        didSelectValueAtIndex: ((Int?) -> Void)? = nil,
        didSelectSegmentAtIndex: ((Int?) -> Void)? = nil,
        @ViewBuilder
        valueStickLabel: @escaping (Value) -> StickLabel
    ) {
        self.init(
            nonPredictionCount: nonPredictionCount,
            values: values,
            dates: dates,
            nonPredictionDates: nonPredictionDates,
            predictionDates: predictionDates,
            occupyingRelativeWidth: occupyingRelativeWidth,
            showGlowingIndicator: showGlowingIndicator,
            lineSegmentStartingIndices: lineSegmentStartingIndices,
            segmentSearchStrategy: segmentSearchStrategy,
            didSelectValueAtIndex: didSelectValueAtIndex,
            didSelectSegmentAtIndex: didSelectSegmentAtIndex,
            customLatestValueIndicator: {
                GlowingIndicator()
        },
            valueStickLabel: valueStickLabel)
    }
}

private extension GraphInteractiveLinePlot {
    
    // Get index of nearest data point.
    func getEffectiveIndex(canvas: CGRect) -> Int {
        let referencedWidth = canvas.width
        let relativeX = (self.draggableIndicatorOffset - canvas.minX) / max(referencedWidth, 1)
        return Int(round(relativeX * CGFloat(self.values.count - 1)))
            .clamp(low: 0, high: self.values.count-1)
    }
    
    // Get final offset for line that snaps to the nearest data point.
    func getValueStickOffset(canvas: CGRect) -> CGFloat {
        let targetIndex = CGFloat(getEffectiveIndex(canvas: canvas))
        
        let referencedWidth = canvas.width
        let segmentLength = referencedWidth / CGFloat(values.count - 1)
        let target = targetIndex * segmentLength
        return canvas.minX + target.clamp(low: 0, high: referencedWidth)
    }
    
// Just in case we come back to here.
    func touchAndDrag(canvas: CGRect) -> some Gesture {
        let drag = DragGesture(minimumDistance: 0)
            .updating($isDraggingG) { (value, state, _) in
                state = true
        }.onChanged { (value) in
            self.isDragging = true
            self.draggableIndicatorOffset = value.location.x
                .clamp(low: canvas.minX, high: canvas.maxX)

            self.currentlySelectedIndex = self.getEffectiveIndex(canvas: canvas)
            self.didSelectValueAtIndex?(self.currentlySelectedIndex)

            let activeSegment: Int?
            if let segments = self.lineSegmentStartingIndices,
                let currentIndex = self.currentlySelectedIndex
            {
                switch self.segmentSearchStrategy {
                case .binarySearch:
                    activeSegment = binarySearchOrIndexToTheLeft(array: segments, value: currentIndex)
                }
            } else {
                activeSegment = nil
            }
            if self.currentlySelectedSegmentIndex != activeSegment {
                self.currentlySelectedSegmentIndex = activeSegment
                self.didSelectSegmentAtIndex?(activeSegment)
            }
        }
        .onEnded { (_) in
            self.isDragging = false
            self.draggableIndicatorOffset = canvas.maxX

            self.currentlySelectedIndex = nil
            self.didSelectValueAtIndex?(nil)

            if self.currentlySelectedSegmentIndex != nil {
                self.currentlySelectedSegmentIndex = nil
                self.didSelectSegmentAtIndex?(nil)
            }
        }
        return drag
    }
    
    /// A proxy view to handle gestures.
//    func pressAndDragProxyView(canvas: CGRect) -> some View {
//        VStack {
//
//        }.gesture(DragGesture(coordinateSpace: .global).onChanged { drag in
//            print("{TEST} hey")
//            self.isDragging = true
//            self.onStickLocationChanged(newX: drag.location.x, canvas: canvas)
//        }.onEnded { drag in
//            self.isDragging = false
//
//            self.draggableIndicatorOffset = canvas.maxX
//
//            self.currentlySelectedIndex = nil
//            self.didSelectValueAtIndex?(nil)
//
//            if self.currentlySelectedSegmentIndex != nil {
//                self.currentlySelectedSegmentIndex = nil
//                self.didSelectSegmentAtIndex?(nil)
//            }
//        })
////        let minimumPressDuration = rhPlotConfig.minimumPressDurationToActivateInteraction
////        return PressAndHorizontalDragGestureView(
////            minimumPressDuration: minimumPressDuration,
////            onBegan: { (value) in
////                self.isDragging = true
////                self.onStickLocationChanged(newX: value.location.x, canvas: canvas)
////        }, onChanged: { (value) in
////            self.onStickLocationChanged(newX: value.location.x, canvas: canvas)
////        }, onEnded: { _ in
////            self.isDragging = false
////
////            self.draggableIndicatorOffset = canvas.maxX
////
////            self.currentlySelectedIndex = nil
////            self.didSelectValueAtIndex?(nil)
////
////            if self.currentlySelectedSegmentIndex != nil {
////                self.currentlySelectedSegmentIndex = nil
////                self.didSelectSegmentAtIndex?(nil)
////            }
////        })
//    }
    
    private func onStickLocationChanged(newX: CGFloat, canvas: CGRect) {
        self.draggableIndicatorOffset = newX
            .clamp(low: canvas.minX, high: canvas.maxX)
        
        self.currentlySelectedIndex = self.getEffectiveIndex(canvas: canvas)
        self.didSelectValueAtIndex?(self.currentlySelectedIndex)

        let activeSegment: Int?
        if let segments = self.lineSegmentStartingIndices,
            let currentIndex = self.currentlySelectedIndex
        {
            switch self.segmentSearchStrategy {
            case .binarySearch:
                activeSegment = binarySearchOrIndexToTheLeft(array: segments, value: currentIndex)
            }
        } else {
            activeSegment = nil
        }
        if self.currentlySelectedSegmentIndex != activeSegment {
            self.currentlySelectedSegmentIndex = activeSegment
            self.didSelectSegmentAtIndex?(activeSegment)
        }
    }
}
