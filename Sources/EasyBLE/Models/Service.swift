//
//  File.swift
//  
//
//  Created by Nickolans Griffith on 1/26/23.
//

import Foundation
import CoreBluetooth

@available(iOS 13.0, *)
public struct Service {
    private var uuid: CBUUID
    var service: CBService
    var peripheral: Peripheral
    
    init(_ service: CBService, peripheral: Peripheral) {
        self.uuid = service.uuid
        self.service = service
        self.peripheral = peripheral
    }
}
