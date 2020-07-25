//
//  FileManager.swift
//  Wonder
//
//  Created by Ritesh Pakala on 8/17/19.
//  Copyright © 2019 Ritesh Pakala. All rights reserved.
//

import Foundation

extension FileManager {
    func clearTmpDirectory() {
        do {
            let tmpDirectory = try contentsOfDirectory(atPath: NSTemporaryDirectory())
            try tmpDirectory.forEach {[unowned self] file in
                let path = String.init(format: "%@%@", NSTemporaryDirectory(), file)
                try self.removeItem(atPath: path)
            }
        } catch {
            print(error)
        }
    }
}
