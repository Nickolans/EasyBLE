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
    
    typealias BluetoothSubject = PassthroughSubject<Void, BluetoothServiceError>
    
    private var serviceUUIDs: [CBUUID] = []
    private var manager: CBCentralManager!
    
    static var shared: BluetoothService = BluetoothService()
    
    /**
     Publisher for the state of the CBCentralManager.
     */
    public private(set) var statePublisher = PassthroughSubject<CBManagerState, Never>()
    public private(set) var discoveredPublisher = PassthroughSubject<LoadType, Never>()
    public private(set) var valuePublisher = PassthroughSubject<ValueLoad, Never>()
    public private(set) var peripheralsPublisher = PassthroughSubject<EBPeripheral, BluetoothServiceError>()
    
    private var transientSubjects: [EBCompositeKey:BluetoothSubject] = [:]
    
    override init() {
        super.init()
        self.manager = CBCentralManager(delegate: self, queue: nil)
    }
    
    func setServiceUUIDs(_ uuids: [CBUUID]) {
        self.serviceUUIDs = uuids
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
    
    func discoverPeripherals() throws {
        if (self.manager.state != .poweredOn) {
            throw BluetoothServiceError.stateNotPoweredOn
        }
        
        self.manager.scanForPeripherals(withServices: serviceUUIDs.isEmpty ? nil : serviceUUIDs)
    }
    
    func connectToPeripheral(_ peripheral: EBPeripheral) {
        self.manager.connect(peripheral.object)
    }
    
    func disconnectFromPeripheral(_ peripheral: EBPeripheral) {
        self.manager.cancelPeripheralConnection(peripheral.object)
    }
    
    func discoverServices(forPeripheral peripheral: EBPeripheral, serviceUUIDs: [CBUUID]?) {
        peripheral.object.discoverServices(serviceUUIDs)
    }
    
    func discoverCharacteristics(forService service: EBService, withCharacteristicUUIDs uuids: [CBUUID]?) {
        service.object.peripheral?.discoverCharacteristics(uuids, for: service.object)
    }
    
    func discoverDescriptors(forCharacteristic characteristic: EBCharacteristic) {
        guard let service = characteristic.object.service, let peripheral = service.peripheral else { return }
        peripheral.discoverDescriptors(for: characteristic.object)
    }
    
    func write(value data: Data, toCharacteristic characteristic: EBCharacteristic, type: CBCharacteristicWriteType) async throws {
        guard let service = characteristic.object.service, let peripheral = service.peripheral else { return }
        
        let key = EBCompositeKey(part1: peripheral.identifier, part2: UUID(uuidString: characteristic.object.uuid.uuidString)!)
        
        self.transientSubjects[key] = BluetoothSubject()
        
        try await withCheckedThrowingContinuation { continuation in
            
            var cancellables: [AnyCancellable] = []
            
            if let subject = self.transientSubjects[key] {
                subject.sink { error in
                    switch error {
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    case .finished:
                        continuation.resume()
                    }
                } receiveValue: { _ in
                    continuation.resume()
                }
                .store(in: &cancellables)
            }
            
            peripheral.writeValue(data, for: characteristic.object, type: type)
        }
    }
    
    func write(value data: Data, toDescriptor descriptor: EBDescriptor) async throws {
        
        guard let characteristic = descriptor.object.characteristic, let service = characteristic.service, let peripheral = service.peripheral else { return }
        
        let key = EBCompositeKey(part1: peripheral.identifier, part2: descriptor.id)
        
        self.transientSubjects[key] = BluetoothSubject()
        
        try await withCheckedThrowingContinuation { continuation in
            
            var cancellables: [AnyCancellable] = []
            
            if let subject = self.transientSubjects[key] {
                subject.sink { error in
                    switch error {
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    case .finished:
                        continuation.resume()
                    }
                } receiveValue: { _ in
                    continuation.resume()
                }
                .store(in: &cancellables)
            }
            
            peripheral.writeValue(data, for: descriptor.object)
        }
    }
    
    func notify(_ value: Bool, forCharacteristic characteristic: EBCharacteristic) {
        characteristic.object.service?.peripheral?.setNotifyValue(value, for: characteristic.object)
    }
}

@available(iOS 13.0, *)
extension BluetoothService: CBPeripheralDelegate {
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        self.peripheralsPublisher.send(EBPeripheral(peripheral, connected: true))
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        guard let error = error else { return }
        self.peripheralsPublisher.send(completion: .failure(.connectionError(EBPeripheral(peripheral, connected: false), error.localizedDescription)))
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        self.peripheralsPublisher.send(EBPeripheral(peripheral, connected: false))
    }
}

@available(iOS 13, *)
extension BluetoothService {
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        self.discoveredPublisher.send(.peripheral(EBPeripheral(peripheral, connected: false)))
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        self.discoveredPublisher.send(.services(services.map({ EBService($0) })))
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else { return }
        self.discoveredPublisher.send(.characteristics(characteristics.map({ EBCharacteristic($0) })))
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverDescriptorsFor characteristic: CBCharacteristic, error: Error?) {
        guard let descriptors = characteristic.descriptors else { return }
        self.discoveredPublisher.send(.descriptors(descriptors.map({ EBDescriptor($0) })))
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverIncludedServicesFor service: CBService, error: Error?) {
        //
    }
}

@available(iOS 13, *)
extension BluetoothService {
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        
        let key = EBCompositeKey(part1: peripheral.identifier, part2: characteristic.uuid.toUUID())
        
        if let subject = self.transientSubjects[key] {
            // If there is an error, send to subscriber
            if let error =  error {
                subject.send(completion: .failure(.connectionError(EBPeripheral(peripheral, connected: true), error.localizedDescription)))
                return
            }
            
            // If there is not an error, send success
            subject.send(completion: .finished)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor descriptor: CBDescriptor, error: Error?) {
        let key = EBCompositeKey(part1: peripheral.identifier, part2: descriptor.uuid.toUUID())
        
        if let subject = self.transientSubjects[key] {
            // If there is an error, send to subscriber
            if let error =  error {
                subject.send(completion: .failure(.unableToWrite(error.localizedDescription)))
                return
            }
            
            // If there is not an error, send success
            subject.send(completion: .finished)
        }
    }
}

@available(iOS 13, *)
extension BluetoothService {
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        self.valuePublisher.send(.characteristic(EBCharacteristic(characteristic)))
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor descriptor: CBDescriptor, error: Error?) {
        self.valuePublisher.send(.descriptor(EBDescriptor(descriptor)))
    }
}
