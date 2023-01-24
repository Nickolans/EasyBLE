import Combine
import CoreBluetooth

@available(iOS 13.0, *)
public struct EasyBLE {
    
    private var serviceUUIDs: [CBUUID]
    
    public private(set) var statePublisher: PassthroughSubject<CBManagerState, Never>?
    public private(set) var peripheralPublisher: PassthroughSubject<Set<Peripheral>, Never>?
    public private(set) var discoveredPublisher: PassthroughSubject<UUID, Never>?

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
}
