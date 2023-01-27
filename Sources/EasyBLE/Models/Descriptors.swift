//
//  File.swift
//  
//
//  Created by Nickolans Griffith on 1/26/23.
//

import Foundation
import CoreBluetooth

public struct Descriptor {
    private var uuid: CBUUID
    var descriptor: CBDescriptor
    public var value: Any? = nil
    
    init(value: Any? = nil, _ descriptor: CBDescriptor) {
        self.uuid = descriptor.uuid
        self.descriptor = descriptor
    }
}
