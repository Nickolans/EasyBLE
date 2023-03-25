import Combine
import CoreBluetooth

@available(iOS 13.0, *)
protocol EasyBLEProtocol {
    func startDiscovering()
    func connectPeripheral(_ peripheral: EBPeripheral)
    func disconnectFromPeripheral(_ peripheral: EBPeripheral)
    func discoverServices(forPeripheral peripheral: EBPeripheral, serviceUUIDs: [CBUUID]?)
    func discoverCharacteristics(forService service: EBService, characteristicUUIDs: [CBUUID]?)
    func discoverDescriptors(forCharacteristic characteristic: EBCharacteristic)
}

@available(iOS 13.0, *)
public struct EasyBLE: EasyBLEProtocol {
    
    private var serviceUUIDs: [CBUUID]
    
    public private(set) var statePublisher: PassthroughSubject<CBManagerState, Never>?
    public private(set) var peripheralPublisher: PassthroughSubject<Set<EBPeripheral>, Never>?
    
    // Discovered
    public private(set) var discoveredPublisher: PassthroughSubject<LoadType, Never>?
    public private(set) var valuePublisher: PassthroughSubject<ValueLoad, Never>?

    public init(serviceUUIDs: [CBUUID]) {
        self.serviceUUIDs = serviceUUIDs
        self.statePublisher = BluetoothService.shared.statePublisher
        self.discoveredPublisher = BluetoothService.shared.discoveredPublisher
        self.valuePublisher = BluetoothService.shared.valuePublisher
        self.peripheralPublisher = Peripherals.shared.peripheralsPublisher
    }
    
    public func startDiscovering() {
        BluetoothService.shared.discoverPeripherals()
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
    
    public func write(value data: Data, toDescriptor descriptor: EBDescriptor) {
        BluetoothService.shared.write(value: data, toDescriptor: descriptor)
    }
}
