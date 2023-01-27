//
//  File.swift
//  
//
//  Created by Nickolans Griffith on 1/26/23.
//

import Foundation
import CoreBluetooth

public struct Characteristic {
    var uuid: CBUUID
    public var value: Data? = nil
    var characteristic: CBCharacteristic
    
    init(value: Data? = nil, _ characteristic: CBCharacteristic) {
        self.uuid = characteristic.uuid
        self.value = value
        self.characteristic = characteristic
    }
}
