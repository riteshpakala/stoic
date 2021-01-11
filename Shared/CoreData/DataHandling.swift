//
//  DataHandling.swift
//  * stoic
//
//  Created by Ritesh Pakala on 12/23/20.
//

import Foundation

extension NSObject {
    public var archived: Data? {
        do {
            return try NSKeyedArchiver
                .archivedData(
                    withRootObject: self,
                    requiringSecureCoding: true)
        } catch let error {
            print("{CoreData} \(error.localizedDescription)")
            return nil
        }
    }
}

open class Archiveable: Codable {}
extension Archiveable {
    public var archived: Data? {
        let encoder = JSONEncoder()
        do {
            return try encoder.encode(self)
        } catch let error {
            print("{CoreData} \(error.localizedDescription)")
            return nil
        }
    }
}

