import Combine
import CoreBluetooth

@available(iOS 13.0, *)
protocol EasyBLEProtocol {
    func startDiscovering()
    func connectPeripheral(_ peripheral: Peripheral)
    func disconnectFromPeripheral(_ peripheral: Peripheral)
    func discoverServices(forPeripheral peripheral: Peripheral, serviceUUIDs: [CBUUID]?)
    func discoverCharacteristics(forService service: Service, characteristicUUIDs: [CBUUID]?)
    func discoverDescriptors(forCharacteristic characteristic: Characteristic)
}

@available(iOS 13.0, *)
public struct EasyBLE: EasyBLEProtocol {
    
    private var serviceUUIDs: [CBUUID]
    
    public private(set) var statePublisher: PassthroughSubject<CBManagerState, Never>?
    public private(set) var peripheralPublisher: PassthroughSubject<Set<Peripheral>, Never>?
    
    // Discovered
    public private(set) var discoveredPublisher: PassthroughSubject<LoadType, Never>?
    public private(set) var valuePublisher: PassthroughSubject<ValueLoad, Never>?

    public init(serviceUUIDs: [CBUUID]) {
        self.serviceUUIDs = serviceUUIDs
        
        Peripherals.shared = Peripherals()
        BluetoothService.shared = BluetoothService(serviceUUIDs: serviceUUIDs)
        
        if let bluetoothShared = BluetoothService.shared {
            self.statePublisher = bluetoothShared.statePublisher
            self.discoveredPublisher = bluetoothShared.discoveredPublisher
            self.valuePublisher = bluetoothShared.valuePublisher
        }
        
        if let peripheralsShared = Peripherals.shared {
            self.peripheralPublisher = peripheralsShared.peripheralsPublisher
        }
    }
    
    public func startDiscovering() {
        BluetoothService.shared?.discoverPeripherals()
    }
    
    public func connectPeripheral(_ peripheral: Peripheral) {
        BluetoothService.shared?.connectToPeripheral(peripheral)
    }
    
    public func disconnectFromPeripheral(_ peripheral: Peripheral) {
        BluetoothService.shared?.disconnectFromPeripheral(peripheral)
    }
    
    public func discoverServices(forPeripheral peripheral: Peripheral, serviceUUIDs: [CBUUID]?) {
        BluetoothService.shared?.discoverServices(forPeripheral: peripheral, serviceUUIDs: serviceUUIDs)
    }
    
    public func discoverCharacteristics(forService service: Service, characteristicUUIDs: [CBUUID]?) {
        BluetoothService.shared?.discoverCharacteristics(forService: service, withCharacteristicUUIDs: characteristicUUIDs)
    }
    
    public func discoverDescriptors(forCharacteristic characteristic: Characteristic) {
        BluetoothService.shared?.discoverDescriptors(forPeripheral: characteristic.service.peripheral, forCharacteristic: characteristic)
    }
    
    public func write(value data: Data, toCharacteristic characteristic: Characteristic, type: CBCharacteristicWriteType) {
        BluetoothService.shared?.write(value: data, toCharacteristic: characteristic, type: type)
    }
    
    public func write(value data: Data, toDescriptor descriptor: Descriptor) {
        BluetoothService.shared?.write(value: data, toDescriptor: descriptor)
    }
}
