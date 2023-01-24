//
//  File.swift
//  
//
//  Created by Nickolans Griffith on 1/24/23.
//

import Foundation
import CoreBluetooth
import Combine

@available(iOS 13.0, *)
public struct Peripheral: Identifiable, Hashable {
    
    public var id: UUID
    var peripheral: CBPeripheral
    var connected: Bool = false
    
    init(peripheral: CBPeripheral, connected: Bool = false) {
        self.id = peripheral.identifier
        self.peripheral = peripheral
        self.connected = connected
    }
    
    public static func == (lhs: Peripheral, rhs: Peripheral) -> Bool {
        return lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
