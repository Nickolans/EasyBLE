//
//  File.swift
//  
//
//  Created by Nickolans Griffith on 3/25/23.
//

import Foundation

@available(iOS 13.0, *)
public enum BluetoothServiceError: Error {
    case stateNotPoweredOn
    case connectionError(EBPeripheral, String)
    case unableToWrite(String)
}
