# EasyBLE

Swift BLE Library using CoreBluetooth and Combine for handling of asynchronous Bluetooth events.

```swift
// Example

let ble = EasyBLE(serviceUUIDs: [])

self.bleStateSubscriber = ble.statePublisher?.sink(receiveValue: { state in
    if (state == .poweredOn) {
        print("BLE POWERED ON")

        // Start discovering
        ble.startDiscovering()
    }
})

// Provides discovered peripheral
self.peripheralsSubscriber = ble.discoveredPublisher?.sink(receiveValue: { peripheral in
    print("Peripheral UUID: \(peripheral.id.uuidString)")
})

// Provides list of all recently connected peripherals as they are updated
self.peripheralsSubscriber = ble.peripheralPublisher?.sink(receiveValue: { peripherals in
    print("Peripherals Updated: \(peripherals)")
})
```
