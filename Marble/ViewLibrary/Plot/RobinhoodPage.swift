//
//  RobinhoodPage.swift
//  RHLinePlotExample
//
//  Created by Wirawit Rueopas on 4/10/20.
//  Copyright © 2020 Wirawit Rueopas. All rights reserved.
//

import Combine
import SwiftUI
import UIKit

class SomePlotData: ObservableObject {
    typealias PlotData = RobinhoodPageViewModel.PlotData
    @Published var plotData: PlotData?
    @Published var predictionPlotData: PlotData = []
}
struct RobinhoodPage: View {
    typealias PageComponent = (page: RobinhoodPage, host: UIView)
    typealias PlotData = RobinhoodPageViewModel.PlotData
    static let symbol = "IBM"
    
    @State var timeDisplayMode: TimeDisplayOption = .daily
    @State var isLaserModeOn = true
    @State var currentIndex: Int? = nil
//    @ObservedObject var viewModel = RobinhoodPageViewModel(symbol: symbol)
    @ObservedObject var someModel = SomePlotData()
    
    
    static public func create(from: UIViewController) -> PageComponent {
        let page: RobinhoodPage = .init()
        let hostController = UIHostingController.init(rootView: page)
        hostController.view.translatesAutoresizingMaskIntoConstraints = false
        from.addChild(hostController)
        hostController.view.backgroundColor = .clear
        hostController.view.clipsToBounds = false
        hostController.view.layer.masksToBounds = false
        return (page, hostController.view)
    }
    
    
    
    var currentPlotData: PlotData {
        someModel.plotData ?? []
//        switch timeDisplayMode {
//        case .hourly:
//            return viewModel.intradayPlotData
//        case .daily:
//            return viewModel.dailyPlotData
//        case .weekly:
//            return viewModel.weeklyPlotData
//        case .monthly:
//            return viewModel.monthlyPlotData
//        }
    }
    
    var currentPredictionPlotData: PlotData {
        someModel.predictionPlotData
//        switch timeDisplayMode {
//        case .hourly:
//            return viewModel.intradayPlotData
//        case .daily:
//            return viewModel.dailyPlotData
//        case .weekly:
//            return viewModel.weeklyPlotData
//        case .monthly:
//            return viewModel.monthlyPlotData
//        }
    }
    
    var plotDataSegments: [Int]? {
        switch timeDisplayMode {
        case .hourly:
            return RobinhoodPageViewModel.segmentByHours(values: currentPlotData)
        case .daily:
            return RobinhoodPageViewModel.segmentByMonths(values: currentPlotData)
        case .weekly, .monthly:
            return RobinhoodPageViewModel.segmentByYears(values: currentPlotData)
        }
    }
    
    var plotRelativeWidth: CGFloat {
        switch timeDisplayMode {
        case .hourly:
            return 0.7 // simulate today's data
        default:
            return 1.0
        }
    }
    
    var showGlowingIndicator: Bool {
        switch timeDisplayMode {
        case .hourly:
            return true // simulate today's data
        default:
            return false
        }
    }
    
    // MARK: Body
    func readyPageContent(plotData: PlotData) -> some View {
//        let firstPrice = plotData.first?.price ?? 0
//        let lastPrice = plotData.last?.price ?? 0
//        let themeColor = firstPrice <= lastPrice ? rhThemeColor : rhRedThemeColor
        return ZStack {
            VStack {
                plotBody(plotData: plotData)
            }
            VStack(alignment: .leading, spacing: 0) {
                stockHeaderAndPrice(plotData: plotData)
                Spacer()
            }.padding(.top, GlobalStyle.largePadding + GlobalStyle.padding)
//            TimeDisplayModeSelector(
//                currentTimeDisplayOption: $timeDisplayMode,
//                eligibleModes: TimeDisplayOption.allCases
//            ).accentColor(themeColor)
            
//            Divider()
//            HStack {
//                Text("All Segments")
//                    .bold()
//                    .rhFont(style: .title2)
//                Spacer()
//            }.padding([.leading, .top], 22)
//            rowsOfSegment(plotData)
//            Spacer()
        }.frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: .infinity, alignment: .topLeading)
    }
    
//    func rowsOfSegment(_ plotData: PlotData) -> some View {
//        guard let segments = viewModel.segmentsDataCache[timeDisplayMode] else {
//            return AnyView(EmptyView())
//        }
//        let allSplitPoints = segments + [plotData.count]
//        let fromAndTos = Array(zip(allSplitPoints, allSplitPoints[1...]))
//        let allTimes = plotData.map { $0.time }
//        let allValues = plotData.map { $0.price }
//        let dateFormatter = timeDisplayMode == .hourly ?
//            SharedDateFormatter.onlyTime : SharedDateFormatter.dayAndYear
//        return AnyView(ForEach((0..<fromAndTos.count).reversed(), id: \.self) { (i) -> AnyView in
//            let (from, to) = fromAndTos[i]
//            let endingPrice = allValues[to-1]
//            let firstPrice = allValues[from]
//            let endingTime = allTimes[to-1]
//            let color = endingPrice >= firstPrice ? rhThemeColor : rhRedThemeColor
//            return AnyView(self.segmentRow(
//                titleText: "\(dateFormatter.string(from: endingTime))",
//                values: Array(allValues[from..<to]),
//                priceText: "$\(endingPrice.round2Str())").accentColor(color)
//            )
//            }.drawingGroup())
//    }
//    func segmentRow(titleText: String, values: [CGFloat], priceText: String) -> some View {
//        HStack {
//            Text(titleText)
//                .rhFont(style: .headline)
//                .frame(maxWidth: .infinity, alignment: .leading)
//                .padding(.leading, 22)
//            RHLinePlot(values: values)
//                .frame(maxWidth: .infinity)
//                .padding()
//                .foregroundColor(Color.accentColor)
//
//            Text(priceText)
//                .rhFont(style: .headline)
//                .foregroundColor(.white)
//                .padding(.vertical, 4)
//                .padding(.horizontal, 8)
//                .background(
//                    RoundedRectangle(cornerRadius: 6)
//                        .fill(Color.accentColor))
//                .frame(maxWidth: .infinity, alignment: .trailing)
//                .padding(.trailing, 22)
//        }.frame(height: 60)
//    }
    
    var body: some View {
        VStack {
            if currentPlotData.isEmpty {
                Text("Loading...")
            } else {
                readyPageContent(plotData: currentPlotData + currentPredictionPlotData)
            }
        }
        .accentColor(rhThemeColor)
        .environment(\.rhLinePlotConfig, RHLinePlotConfig.default.custom(f: { (c) in
            c.useLaserLightLinePlotStyle = isLaserModeOn
        }))/*.onAppear {
            self.viewModel.fetchOnAppear()
        }.onDisappear {
            self.viewModel.cancelAllFetchesOnDisappear()
        }*/
    }
}

// MARK:- Components
extension RobinhoodPage {
    func plotBody(plotData: PlotData) -> some View {
        let values = plotData.map { $0.price }
        let currentIndex = self.currentIndex ?? (values.count - 1)
        // For value stick
        let dateString = plotData[currentIndex].time.asString
        
//        let themeColor = values.last! >= values.first! ? rhThemeColor : rhRedThemeColor
        
        return RHInteractiveLinePlot(
            nonPredictionCount: currentPlotData.count,
            values: values,
            occupyingRelativeWidth: plotRelativeWidth,
            showGlowingIndicator: showGlowingIndicator,
            lineSegmentStartingIndices: plotDataSegments,
            segmentSearchStrategy: .binarySearch,
            didSelectValueAtIndex: { ind in
                self.currentIndex = ind
        },
            didSelectSegmentAtIndex: { segmentIndex in
                if segmentIndex != nil {
                    Haptic.onChangeLineSegment()
                }
        },
            valueStickLabel: { value in
                Text("\(dateString)")
                    .foregroundColor(Color(GlobalStyle.Colors.purple))
                    .font(Font.init(GlobalStyle.Fonts.courier(.medium, .bold)))
        })
            //.frame(height: 280)
//            .foregroundColor(themeColor)
    }
    
    func stockHeaderAndPrice(plotData: PlotData) -> some View {
        return HStack {
            VStack(alignment: .leading, spacing: 0) {
//                Text("\(Self.symbol)")
//                    .rhFont(style: .title1, weight: .heavy)
                buildMovingPriceLabel(plotData: plotData)
            }.frame(minWidth: 0, maxWidth: .infinity)
            Spacer().frame(minWidth: 0, maxWidth: .infinity)
        }
        .padding(.horizontal, 0.0)
    }
    
    func buildMovingPriceLabel(plotData: PlotData) -> some View {
        let currentIndex = self.currentIndex ?? (plotData.count - 1)
        return HStack(spacing: 2) {
            
            Text("$").background(with: Color.init(GlobalStyle.Colors.black.withAlphaComponent(0.75)))
            MovingNumbersView(
                number: Double(plotData[currentIndex].price),
                numberOfDecimalPlaces: 2,
                verticalDigitSpacing: 0,
                animationDuration: 0.3,
                fixedWidth: 120) { (digit) in
                    Text(digit)
            }
            .mask(LinearGradient(
                gradient: Gradient(stops: [
                    Gradient.Stop(color: .clear, location: 0),
                    Gradient.Stop(color: .black, location: 0.2),
                    Gradient.Stop(color: .black, location: 0.8),
                    Gradient.Stop(color: .clear, location: 1.0)]),
                startPoint: .top,
                endPoint: .bottom))
        }.font(Font.init(GlobalStyle.Fonts.courier(.large, .bold)))
    }
}

extension View {
  func background(with color: Color) -> some View {
    background(GeometryReader { geometry in
      Rectangle().path(in: geometry.frame(in: .local)).foregroundColor(color)
    })
  }
}

struct RobinhoodPage_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            RobinhoodPage()
                .environment(\.colorScheme, .dark)
        }.previewLayout(.device)//.fixed(width: 320, height: 480))
    }
}
