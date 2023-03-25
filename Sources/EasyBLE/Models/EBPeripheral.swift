//
//  File.swift
//  
//
//  Created by Nickolans Griffith on 3/25/23.
//

import Foundation
import CoreBluetooth

@available(iOS 13.0, *)
public struct EBPeripheral: BluetoothObject {
        
    typealias T = CBPeripheral
    public private(set) var id: UUID
    private(set) var object: T
    var connected: Bool = false
    
    init(_ object: T, connected: Bool) {
        self.id = UUID(uuidString: object.identifier.uuidString)!
        self.object = object
        self.connected = connected
    }
}

