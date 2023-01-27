# EasyBLE

Swift BLE Library using CoreBluetooth and Combine for handling of asynchronous Bluetooth events.

## Subscribers

### BLE State

```swift
let ble = EasyBLE(serviceUUIDs: [])

// Subscribe for BLE state
self.bleState = ble.statePublisher?.sink(receiveValue: { state in
    if (state == .poweredOn) {
        print("BLE POWERED ON")
        ble.startDiscovering()
    }
})
```

### Discovery

```swift
// Subscribe for discoveries
self.discoveredSusbcriber = ble.discoveredPublisher?.sink(receiveValue: { load in
    switch load {
    case .descriptors(let descriptors):
        print("Discovered Descriptors: \(descriptors)")
        break
    case .characteristics(let characteristics):
        print("Discovered Characteristics: \(characteristics)")
        break
    case .services(let services):
        print("Discovered Services: \(services)")
        break
    case .peripheral(let peripheral):
        print("Discovered Peripheral: \(peripheral)")
        break
    }
})
```

### Peripheral Updates

```swift
// Subscribe for peripheral updates
self.peripheralsSubscriber = ble.peripheralPublisher?.sink(receiveValue: { peripherals in
    print("Peripherals Updated: \(peripherals)")
})
```

### Writes

```swift
// Subscribe for writes
self.valuesSubscriber = ble.valuePublisher?.sink(receiveValue: { load in
    switch load {
    case .descriptor(let descriptor):
        print("Descriptor Data: \(String(describing: descriptor.value))")
    case .characteristic(let characteristic):
        print("Characteristic Data: \(String(describing: characteristic.value))")
    }
})
```
