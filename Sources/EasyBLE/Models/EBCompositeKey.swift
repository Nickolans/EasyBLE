//
//  File.swift
//  
//
//  Created by Nickolans Griffith on 8/12/23.
//

import Foundation
import CoreBluetooth

struct EBCompositeKey: Hashable {
    let part1: UUID
    let part2: UUID
}
