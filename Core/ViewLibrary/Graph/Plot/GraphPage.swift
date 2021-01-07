//
//  RobinhoodPage.swift
//  RHLinePlotExample
//
//  Created by Wirawit Rueopas on 4/10/20.
//  Copyright © 2020 Wirawit Rueopas. All rights reserved.
//

import Combine
import SwiftUI

class SomePlotData: ObservableObject {
    typealias PlotData = GraphPageViewModel.PlotData
    @Published var plotData: PlotData?
    @Published var predictionPlotData: PlotData = []
    @Published var predictionDateData: PlotData = []
    @Published var trueDays: Int?
    @Published var modelType: TonalModels.ModelType = .none
}
struct GraphPage: View {
    typealias PlotData = GraphPageViewModel.PlotData
    
    @State var timeDisplayMode: TimeDisplayOption = .daily
    @State var isLaserModeOn = false
    @State var currentIndex: Int? = nil
//    @ObservedObject var viewModel = RobinhoodPageViewModel(symbol: symbol)
    @ObservedObject var someModel = SomePlotData()
    
    
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
            return GraphPageViewModel.segmentByHours(values: currentPlotData)
        case .daily:
            return GraphPageViewModel.segmentByMonths(values: currentPlotData)
        case .weekly, .monthly:
            return GraphPageViewModel.segmentByYears(values: currentPlotData)
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
    func readyPageContent(plotData: PlotData, predictionPlotData: PlotData) -> some View {
//        let firstPrice = plotData.first?.price ?? 0
//        let lastPrice = plotData.last?.price ?? 0
//        let themeColor = firstPrice <= lastPrice ? rhThemeColor : rhRedThemeColor
        return VStack {
            
            VStack(alignment: .leading, spacing: 0) {
                stockHeaderAndPrice(plotData: plotData+predictionPlotData)
            }.padding(.top, Brand.Padding.small).padding(.leading, Brand.Padding.small)
            VStack {
                plotBody(plotData: plotData, predictionPlotData: predictionPlotData)
            }
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
                GraniteText("loading...", .subheadline, .regular)
            } else {
                readyPageContent(plotData: currentPlotData, predictionPlotData: currentPredictionPlotData)
            }
        }
        .accentColor(graphThemeColor)
        .environment(\.graphLinePlotConfig, GraphLinePlotConfig.default.custom(f: { (c) in
            c.useLaserLightLinePlotStyle = isLaserModeOn
        }))/*.onAppear {
            self.viewModel.fetchOnAppear()
        }.onDisappear {
            self.viewModel.cancelAllFetchesOnDisappear()
        }*/
    }
}

// MARK:- Components
extension GraphPage {
    func plotBody(plotData: PlotData, predictionPlotData: PlotData) -> some View {
        let combined = (plotData + predictionPlotData)
        let values = combined.map { $0.price }
        let dates = combined.map { $0.time }
        let nonPredictionDates = plotData.map { $0.time }
        let predictionDates = predictionPlotData.map { $0.time }
        let currentIndex = self.currentIndex ?? (values.count - 1)
        // For value stick
        let dateString = combined[currentIndex].time.asString
        
//        let themeColor = values.last! >= values.first! ? rhThemeColor : rhRedThemeColor
        
        return GraphInteractiveLinePlot(
            nonPredictionCount: someModel.trueDays ?? currentPlotData.count,
            values: values,
            dates: dates,
            nonPredictionDates: nonPredictionDates,
            predictionDates: predictionDates,
            occupyingRelativeWidth: plotRelativeWidth,
            showGlowingIndicator: showGlowingIndicator,
            lineSegmentStartingIndices: plotDataSegments,
            segmentSearchStrategy: .binarySearch,
            didSelectValueAtIndex: { ind in
                self.currentIndex = ind
        },
            didSelectSegmentAtIndex: { segmentIndex in
                if segmentIndex != nil {
                    #if os(iOS)
                    Haptic.onChangeLineSegment()
                    #endif
                }
        },
            valueStickLabel: { value in
                Text("\(dateString)")
                    .foregroundColor(Brand.Colors.purple)
                    .font(Fonts.live(.subheadline, .bold))
        })
            //.frame(height: 280)
//            .foregroundColor(themeColor)
    }
    
    func stockHeaderAndPrice(plotData: PlotData) -> some View {
        return HStack {
//            VStack(alignment: .leading, spacing: 0) {
////                Text("\(Self.symbol)")
////                    .rhFont(style: .title1, weight: .heavy)
//                buildMovingPriceLabel(plotData: plotData)
//            }.frame(minWidth: 0, maxWidth: .infinity)
            buildMovingPriceLabel(plotData: plotData)
            Spacer().frame(minWidth: 0, maxWidth: .infinity)
        }
        .padding(.horizontal, 0.0)
    }
    
    func buildMovingPriceLabel(plotData: PlotData) -> some View {
        let currentIndex = self.currentIndex ?? (plotData.count - 1)
        return HStack(spacing: 2) {
            
            Text(someModel.modelType.symbol).background(with: Brand.Colors.black.opacity(0.75)).frame(width: someModel.modelType == .volume ? 0 : 20)
            MovingNumbersView(
                number: Double(plotData[currentIndex].price),
                numberOfDecimalPlaces: 2,
                verticalDigitSpacing: 0,
                animationDuration: 0.3,
                fixedWidth: 240) { (digit) in
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
        }.font(Fonts.live(.subheadline, .regular))
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
            GraphPage()
                .environment(\.colorScheme, .dark)
        }.previewLayout(.device)//.fixed(width: 320, height: 480))
    }
}
