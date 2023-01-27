//
//  File.swift
//  
//
//  Created by Nickolans Griffith on 1/26/23.
//

import Foundation
import CoreBluetooth

public struct Service {
    private var uuid: CBUUID
    var service: CBService
    
    init(_ service: CBService) {
        self.uuid = service.uuid
        self.service = service
    }
}
