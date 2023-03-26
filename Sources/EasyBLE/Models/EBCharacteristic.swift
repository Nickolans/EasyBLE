//
//  File.swift
//  
//
//  Created by Nickolans Griffith on 3/25/23.
//

import Foundation
import CoreBluetooth

@available(iOS 13.0, *)
public struct EBCharacteristic: BluetoothObject {
        
    typealias T = CBCharacteristic
    public typealias V = Data
    public private(set) var id: UUID
    private(set) var object: T
    
    init(_ object: T) {
        self.id = UUID(uuidString: object.uuid.uuidString)!
        self.object = object
    }
    
    public func getValue() -> V? {
        return object.value
    }
}
