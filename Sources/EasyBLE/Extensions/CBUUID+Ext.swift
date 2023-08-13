//
//  File.swift
//  
//
//  Created by Nickolans Griffith on 8/12/23.
//

import Foundation
import CoreBluetooth

extension CBUUID {
    func toUUID() -> UUID {
        return UUID(uuidString: self.uuidString)!
    }
}
