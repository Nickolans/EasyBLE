import Combine
import CoreBluetooth

@available(iOS 13.0, *)
protocol EasyBLEProtocol {
    func startDiscovering() throws
    func connectPeripheral(_ peripheral: EBPeripheral)
    func disconnectFromPeripheral(_ peripheral: EBPeripheral)
    func discoverServices(forPeripheral peripheral: EBPeripheral, serviceUUIDs: [CBUUID]?)
    func discoverCharacteristics(forService service: EBService, characteristicUUIDs: [CBUUID]?)
    func discoverDescriptors(forCharacteristic characteristic: EBCharacteristic)
}

@available(iOS 13.0, *)
public struct EasyBLE: EasyBLEProtocol {
    
    private var serviceUUIDs: [CBUUID]
    
    public private(set) var discoveredPublisher = BluetoothService.shared.discoveredPublisher
    public private(set) var statePublisher = BluetoothService.shared.statePublisher
    public private(set) var valuePublisher = BluetoothService.shared.valuePublisher
    public private(set) var peripheralPublisher = BluetoothService.shared.peripheralsPublisher

    public init(serviceUUIDs: [CBUUID]) {
        self.serviceUUIDs = serviceUUIDs
    }
    
    public func startDiscovering() throws {
        try BluetoothService.shared.discoverPeripherals()
    }
    
    public func connectPeripheral(_ peripheral: EBPeripheral) {
        BluetoothService.shared.connectToPeripheral(peripheral)
    }
    
    public func disconnectFromPeripheral(_ peripheral: EBPeripheral) {
        BluetoothService.shared.disconnectFromPeripheral(peripheral)
    }
    
    public func discoverServices(forPeripheral peripheral: EBPeripheral, serviceUUIDs: [CBUUID]?) {
        BluetoothService.shared.discoverServices(forPeripheral: peripheral, serviceUUIDs: serviceUUIDs)
    }
    
    public func discoverCharacteristics(forService service: EBService, characteristicUUIDs: [CBUUID]?) {
        BluetoothService.shared.discoverCharacteristics(forService: service, withCharacteristicUUIDs: characteristicUUIDs)
    }
    
    public func discoverDescriptors(forCharacteristic characteristic: EBCharacteristic) {
        BluetoothService.shared.discoverDescriptors(forCharacteristic: characteristic)
    }
    
    public func write(value data: Data, toCharacteristic characteristic: EBCharacteristic, type: CBCharacteristicWriteType) {
        BluetoothService.shared.write(value: data, toCharacteristic: characteristic, type: type)
    }
    
    public func notify(_ value: Bool, forCharacteristic characteristic: EBCharacteristic) {
        BluetoothService.shared.notify(value, forCharacteristic: characteristic)
    }
    
    public func write(value data: Data, toDescriptor descriptor: EBDescriptor) {
        BluetoothService.shared.write(value: data, toDescriptor: descriptor)
    }
}
