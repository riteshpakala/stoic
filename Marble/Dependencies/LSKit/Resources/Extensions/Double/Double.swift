import Foundation

extension Double{
    func randomBetween(_ secondNum: Double) -> Double{
        return Double(arc4random()) / Double(UINT32_MAX) * abs(self - secondNum) + min(self, secondNum)
    }
    
    var degreesToRadians: Double { return self * .pi / 180 }
    var radiansToDegrees: Double { return self * 180 / .pi }
}
