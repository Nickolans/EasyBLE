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
    public private(set) var discoveredPublisher = PassthroughSubject<LoadType, Never>()
    public private(set) var valuePublisher = PassthroughSubject<ValueLoad, Never>()
    
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
    
    func disconnectFromPeripheral(_ peripheral: Peripheral) {
        self.manager.cancelPeripheralConnection(peripheral.peripheral)
    }
    
    func discoverServices(forPeripheral peripheral: Peripheral, serviceUUIDs: [CBUUID]?) {
        peripheral.peripheral.discoverServices(serviceUUIDs)
    }
    
    func discoverCharacteristics(forService service: Service, withCharacteristicUUIDs uuids: [CBUUID]?) {
        service.peripheral.peripheral.discoverCharacteristics(uuids, for: service.service)
    }
    
    func discoverDescriptors(forPeripheral peripheral: Peripheral, forCharacteristic characteristic: Characteristic) {
        peripheral.peripheral.discoverDescriptors(for: characteristic.characteristic)
    }
    
    func write(value data: Data, toCharacteristic characteristic: Characteristic, type: CBCharacteristicWriteType) {
        characteristic.service.peripheral.peripheral.writeValue(data, for: characteristic.characteristic, type: type)
    }
    
    func write(value data: Data, toDescriptor descriptor: Descriptor) {
        descriptor.characteristic.service.peripheral.peripheral.writeValue(data, for: descriptor.descriptor)
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
        self.discoveredPublisher.send(.peripheral(Peripheral(peripheral: peripheral)))
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        
        if let peripheral = Peripherals.shared?.find(withUUID: peripheral.identifier) {
            self.discoveredPublisher.send(.services(services.map({ Service($0, peripheral: peripheral) })))
        }
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else { return }
        self.discoveredPublisher.send(.characteristics(characteristics.map({ Characteristic($0, service: Service(service, peripheral: Peripheral(peripheral: peripheral))) })))
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverDescriptorsFor characteristic: CBCharacteristic, error: Error?) {
        guard let descriptors = characteristic.descriptors else { return }
        self.discoveredPublisher.send(.descriptors(descriptors.map({ Descriptor($0, characteristic: Characteristic(characteristic, service: Service(characteristic.service!, peripheral: Peripheral(peripheral: peripheral)))) })))
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
        guard let value = characteristic.value else { return }
        self.valuePublisher.send(.characteristic(Characteristic(value: value, characteristic, service: Service(characteristic.service!, peripheral: Peripheral(peripheral: peripheral)))))
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor descriptor: CBDescriptor, error: Error?) {
        guard let value = descriptor.value else { return }
        self.valuePublisher.send(.descriptor(Descriptor(value: value, descriptor, characteristic: Characteristic(descriptor.characteristic!, service: Service(descriptor.characteristic!.service!, peripheral: Peripheral(peripheral: peripheral))))) )
    }
}
