//
//  DiscussClient.Message.swift
//  stoic
//
//  Created by Ritesh Pakala on 2/2/21.
//

import Foundation
import SwiftUI

public struct DiscussMessage: Hashable {
    let color: Color
    let data: DiscussRelayEvents.Messages.Receive.Payload
}
