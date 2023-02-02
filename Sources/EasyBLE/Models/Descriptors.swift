//
//  File.swift
//  
//
//  Created by Nickolans Griffith on 1/26/23.
//

import Foundation
import CoreBluetooth

@available(iOS 13.0, *)
public struct Descriptor {
    private var uuid: CBUUID
    var descriptor: CBDescriptor
    public var value: Any? = nil
    var characteristic: Characteristic
    
    init(value: Any? = nil, _ descriptor: CBDescriptor, characteristic: Characteristic) {
        self.uuid = descriptor.uuid
        self.descriptor = descriptor
        self.characteristic = characteristic
    }
}
