import Foundation
import Firebase
import UIKit

public struct Services {
    public let dataService: DataService
    
    public init() {
        self.dataService = DataService()
    }
}

public struct Core {
    
    public init() {
        
    }
}

public struct Defaults {
    public var onboardingComplete : Bool = false
    public var defaultTimelinePicked : Bool = false
    public var style : GlobalStyle
    
    
    public init() {
        style = GlobalStyle()
        
    }
}

public struct DeviceInfo {
    public var processor: String
    public var lowEnd : Bool = false
    
    public init() {
        processor = LSConst.DeviceKeys.superior
    }
    
    mutating func updateDeviceProcessor(to : String){
        processor = to
        
        if  to.contains(LSConst.DeviceKeys.A4) || to.contains(LSConst.DeviceKeys.A5) || to.contains(LSConst.DeviceKeys.A6) || to.contains(LSConst.DeviceKeys.A7) || to.contains(LSConst.DeviceKeys.A8) || to.contains(LSConst.DeviceKeys.A9) || to.contains(LSConst.DeviceKeys.A10) {
            
            lowEnd = true
            
        } else {
            
            lowEnd = false
            
        }
    }
}

public struct QueuedCrops {
    public var total : Int
    public var finished : Int
    
    public init() {
        self.total = 0
        self.finished = 0
    }
    
}

public class DataService {
    public let core: Core
    public var defaults: Defaults
    public var deviceInfo: DeviceInfo
    public var user: MarbleUser = .init()
    public var sharePayload : SharePayload? = nil
    
    init(){
        core = Core()
        defaults = Defaults()
        deviceInfo = DeviceInfo()
        user = MarbleUser()
    }
    
    func sync(with dataService: DataService){
        
    }
    
    var userExists: Bool {
        return user.deviceUID != nil && user.userInfo != nil
    }
}

public class MarbleUser {
    public var userInfo: User?
    public var deviceUID: String?
    public var authorName: String?
    public var isExhibitionLive: Bool = false
    
    init() {
        
    }
}

public struct SharePayload {
    var image : UIImage? = nil
    var imageURL : String? = nil
    var isUrl : Bool = false
    var isUnknown : Bool = false
}
