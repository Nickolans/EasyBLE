//
//  File.swift
//  
//
//  Created by Nickolans Griffith on 1/26/23.
//

import Foundation
import CoreBluetooth

@available(iOS 13.0, *)
public struct Characteristic {
    var uuid: CBUUID
    public var value: Data? = nil
    var characteristic: CBCharacteristic
    var service: Service
    
    init(value: Data? = nil, _ characteristic: CBCharacteristic, service: Service) {
        self.uuid = characteristic.uuid
        self.value = value
        self.characteristic = characteristic
        self.service = service
    }
}
