//
//  BluetoothObject.swift
//  
//
//  Created by Nickolans Griffith on 3/25/23.
//

import Foundation
import CoreBluetooth

@available(iOS 13.0, *)
protocol BluetoothObject<T, V>: Identifiable, Hashable {
    associatedtype T
    associatedtype V
    var id: UUID { get }
    var object: T { get }
    func getValue() -> Self.V?
}

@available(iOS 13.0, *)
extension BluetoothObject {
    typealias V = Optional<Any>.Type
    
    static func == (lhs: any BluetoothObject, rhs: any BluetoothObject) -> Bool {
        return lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public func getValue() -> Self.V? {
        return nil
    }
}
