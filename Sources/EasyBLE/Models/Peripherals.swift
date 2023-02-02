//
//  File.swift
//  
//
//  Created by Nickolans Griffith on 1/24/23.
//

import Foundation
import Combine
import CoreBluetooth

@available(iOS 13.0, *)
struct Peripherals {
    
    /**
     Single instance of Peripherals.
     */
    static var shared: Peripherals?
    
    /**
     Peripherals we are or have been connected to.
     */
    private(set) var items: Set<Peripheral> = []
    
    /**
     Publisher for updated peripherals.
     */
    private(set) var peripheralsPublisher = PassthroughSubject<Set<Peripheral>, Never>()
    
    mutating func updatePeripheral(_ peripheral: Peripheral) {
        self.items.update(with: peripheral)
        self.push()
    }
    
    mutating func removePeripheral(_ peripheral: Peripheral) {
        self.items.remove(peripheral)
        self.push()
    }
    
    mutating func addPeripheral(_ peripheral: Peripheral) {
        self.items.insert(peripheral)
        self.push()
    }
    
    private func push() {
        self.peripheralsPublisher.send(self.items)
    }
    
    func find(withUUID uuid: UUID) -> Peripheral? {
        return self.items.filter({ $0.id == uuid }).first
    }
}
