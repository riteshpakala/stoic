//
//  DataSet.swift
//  AIToolbox
//
//  Created by Kevin Coble on 12/6/15.
//  Copyright © 2015 Kevin Coble. All rights reserved.
//

import Foundation


public enum DataSetType   //  data type
{
    case Regression
    case Classification
}

enum DataTypeError: Error {
    case InvalidDataType
    case DataWrongForType
    case WrongDimensionOnInput
    case WrongDimensionOnOutput
}

enum DataIndexError: Error {
    case Negative
    case IndexAboveDimension
    case IndexAboveDataSetSize
}


public class DataSet: NSObject, NSCoding, NSSecureCoding {
    public static var supportsSecureCoding: Bool = true
    
    let dataType : DataSetType
    let inputDimension: Int
    let outputDimension: Int
    var inputs: [[Double]]
    var outputs: [[Double]]?
    var classes: [Int]?
    var optionalData: AnyObject?        //  Optional data that can be temporarily added by methods using the data
    var labels: [String] = []
    public init(dataType : DataSetType, inputDimension : Int, outputDimension : Int)
    {
        //  Remember the data parameters
        self.dataType = dataType
        self.inputDimension = inputDimension
        self.outputDimension = outputDimension
        
        //  Allocate data arrays
        inputs = []
        if (dataType == .Regression) {
            outputs = []
        }
        else {
            classes = []
        }
        super.init()
    }
    
    public init?(fromDataSet: DataSet, withEntries: [Int])
    {
        //  Remember the data parameters
        self.dataType = fromDataSet.dataType
        self.inputDimension = fromDataSet.inputDimension
        self.outputDimension = fromDataSet.outputDimension
        
        //  Allocate data arrays
        inputs = []
        if (dataType == .Regression) {
            outputs = []
        }
        else {
            classes = []
        }
        super.init()
        //  Copy the entries
        do {
            try includeEntries(fromDataSet: fromDataSet, withEntries: withEntries)
        }
        catch {
            return nil
        }
    }
    
    public required convenience init?(coder: NSCoder) {
        let inDim: Int = coder.decodeInteger(forKey: "inputDimension")
        let outDim: Int = coder.decodeInteger(forKey: "outputDimension")
        let inputs: [[Double]] = coder.decodeObject(forKey: "inputs") as? [[Double]] ?? [[]]
        let outputs: [[Double]] = coder.decodeObject(forKey: "outputs") as? [[Double]] ?? [[]]
        let labels: [String] = (coder.decodeObject(forKey: "labels") as? [String]) ?? []

        self.init(
            dataType: .Regression,
            inputDimension: inDim,
            outputDimension: outDim)

        self.inputs = inputs
        self.outputs = outputs
        self.labels = labels
    }
    
    public func encode(with coder: NSCoder){
        coder.encode(inputDimension, forKey: "inputDimension")
        coder.encode(outputDimension, forKey: "outputDimension")
        coder.encode(inputs, forKey: "inputs")
        coder.encode(outputs, forKey: "outputs")
        coder.encode(labels, forKey: "labels")
    }
    
    public func includeEntries(fromDataSet: DataSet, withEntries: [Int]) throws
    {
        //  Make sure the dataset matches
        if dataType != fromDataSet.dataType { throw DataTypeError.InvalidDataType }
        if inputDimension != fromDataSet.inputDimension { throw DataTypeError.WrongDimensionOnInput }
        if outputDimension != fromDataSet.outputDimension { throw DataTypeError.WrongDimensionOnOutput }
        
        //  Copy the entries
        for index in withEntries {
            if (index  < 0) { throw DataIndexError.Negative }
            if (index  >= fromDataSet.size) { throw DataIndexError.IndexAboveDataSetSize }
            inputs.append(fromDataSet.inputs[index])
            if (dataType == .Regression) {
                outputs!.append(fromDataSet.outputs![index])
            }
            else {
                classes!.append(fromDataSet.classes![index])
                if outputs != nil {
                    outputs!.append(fromDataSet.outputs![index])
                }
            }
        }
    }
    
    public var size: Int
    {
        return inputs.count
    }
    
    public func singleOutput(index: Int) -> Double?
    {
        //  Validate the index
        if (index < 0) { return nil}
        if (index >= inputs.count) { return nil }
        
        //  Get the data
        if (dataType == .Regression) {
            return outputs![index][0]
        }
        else {
            return Double(classes![index])
        }
    }
    
    public func addDataPoint(input : [Double], output: [Double], label: String = "unknown") throws
    {
        //  Validate the data
        if (dataType != .Regression) { throw DataTypeError.DataWrongForType }
        if (input.count != inputDimension) { throw DataTypeError.WrongDimensionOnInput }
        if (output.count != outputDimension) { throw DataTypeError.WrongDimensionOnOutput }
        
        //  Add the new data item
        inputs.append(input)
        outputs!.append(output)
        self.labels.append(label)
    }
    
    public func addDataPoint(input : [Double], output: Int) throws
    {
        //  Validate the data
        if (dataType != .Classification) { throw DataTypeError.DataWrongForType }
        if (input.count != inputDimension) { throw DataTypeError.WrongDimensionOnInput }
        
        //  Add the new data item
        inputs.append(input)
        classes!.append(output)
    }
    
    public func setClass(index: Int, newClass : Int) throws
    {
        //  Validate the data
        if (dataType != .Classification) { throw DataTypeError.DataWrongForType }
        if (index < 0) { throw  DataIndexError.Negative }
        if (index > inputs.count) { throw  DataIndexError.Negative }
        
        classes![index] = newClass
    }
    
    public func addTestDataPoint(input : [Double]) throws
    {
        //  Validate the data
        if (input.count != inputDimension) { throw DataTypeError.WrongDimensionOnInput }
        
        //  Add the new data item
        inputs.append(input)
    }
    
    public func getClass(index: Int) throws ->Int
    {
        //  Validate the data
        if (dataType != .Classification) { throw DataTypeError.DataWrongForType }
        if (index < 0) { throw  DataIndexError.Negative }
        if (index > inputs.count) { throw  DataIndexError.Negative }
        
        return classes![index]
    }
    
    public func getRandomIndexSet() -> [Int]
    {
        //  Get the ordered array of indices
        var shuffledArray: [Int] = []
        for i in 0..<inputs.count - 1 { shuffledArray.append(i) }
        
        // empty and single-element collections don't shuffle
        if size < 2 { return shuffledArray }
        
        //  Shuffle
        for i in 0..<inputs.count - 1 {
            let j = Int(arc4random_uniform(UInt32(inputs.count - i))) + i
            guard i != j else { continue }
            shuffledArray.swapAt(i, j)
        }
        
        return shuffledArray
    }
}
