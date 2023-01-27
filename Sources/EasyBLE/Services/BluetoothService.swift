//
//  File.swift
//  
//
//  Created by Nickolans Griffith on 1/24/23.
//

import Foundation
import CoreBluetooth
import Combine

@available(iOS 13.0, *)
final class BluetoothService: NSObject, CBCentralManagerDelegate {
    
    private var serviceUUIDs: [CBUUID]
    private var manager: CBCentralManager!
    
    static var shared: BluetoothService?
    
    /**
     Publisher for the state of the CBCentralManager.
     */
    public private(set) var statePublisher = PassthroughSubject<CBManagerState, Never>()
    public private(set) var discoveredPublisher = PassthroughSubject<Peripheral, Never>()
    
    init(serviceUUIDs: [CBUUID]) {
        self.serviceUUIDs = serviceUUIDs
        super.init()
        
        self.manager = CBCentralManager(delegate: self, queue: nil)
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
        self.statePublisher.send(central.state)
        
        switch central.state {
        case .poweredOn:
            break
        case .poweredOff:
            break
        case .resetting:
            break
        case .unauthorized:
            break
        case .unknown:
            break
        case .unsupported:
            break
        default:
            break
        }
    }
    
    func discoverPeripherals() {
        if (self.manager.state == .poweredOn) {
            self.manager.scanForPeripherals(withServices: serviceUUIDs.isEmpty ? nil : serviceUUIDs)
        }
    }
    
    func connectToPeripheral(_ peripheral: Peripheral) {
        self.manager.connect(peripheral.peripheral)
    }
}

@available(iOS 13.0, *)
extension BluetoothService: CBPeripheralDelegate {
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        Peripherals.shared?.addPeripheral(Peripheral(peripheral: peripheral, connected: true))
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        // TODO: Display Error
        Peripherals.shared?.addPeripheral(Peripheral(peripheral: peripheral, connected: false))
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        Peripherals.shared?.updatePeripheral(Peripheral(peripheral: peripheral, connected: false))
    }
}

@available(iOS 13, *)
extension BluetoothService {
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        self.discoveredPublisher.send(Peripheral(peripheral: peripheral))
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        //
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        //
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverDescriptorsFor characteristic: CBCharacteristic, error: Error?) {
        //
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverIncludedServicesFor service: CBService, error: Error?) {
        //
    }
}

@available(iOS 13, *)
extension BluetoothService {
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        //
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor descriptor: CBDescriptor, error: Error?) {
        //
    }
}

@available(iOS 13, *)
extension BluetoothService {
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        //
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor descriptor: CBDescriptor, error: Error?) {
        //
    }
}
