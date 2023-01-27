import Combine
import CoreBluetooth

@available(iOS 13.0, *)
protocol EasyBLEProtocol {
    func startDiscovering()
    func connectPeripheral(_ peripheral: Peripheral)
    func disconnectFromPeripheral(_ peripheral: Peripheral)
}

@available(iOS 13.0, *)
public struct EasyBLE: EasyBLEProtocol {
    
    private var serviceUUIDs: [CBUUID]
    
    public private(set) var statePublisher: PassthroughSubject<CBManagerState, Never>?
    public private(set) var peripheralPublisher: PassthroughSubject<Set<Peripheral>, Never>?
    public private(set) var discoveredPublisher: PassthroughSubject<Peripheral, Never>?

    public init(serviceUUIDs: [CBUUID]) {
        self.serviceUUIDs = serviceUUIDs
        
        Peripherals.shared = Peripherals()
        BluetoothService.shared = BluetoothService(serviceUUIDs: serviceUUIDs)
        
        if let bluetoothShared = BluetoothService.shared {
            self.statePublisher = bluetoothShared.statePublisher
            self.discoveredPublisher = bluetoothShared.discoveredPublisher
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
        //
    }
}
