//
//  File.swift
//  
//
//  Created by Nickolans Griffith on 1/26/23.
//

import Foundation
import CoreBluetooth

struct Characteristic {
    var uuid: UUID
    var value: Data
    var characteristic: CBCharacteristic
}
