# EasyBLE

Swift BLE Library using CoreBluetooth and Combine for handling of asynchronous Bluetooth events.

- [EasyBLE](#easyble)
- [Discover Peripherals](#discover-peripherals)
- [Discover Services](#discover-services)
- [Discover Characteristics](#discover-characteristics)
- [Discover Descriptors](#discover-descriptors)
- [Peripheral Updates](#discover-descriptors)
- [Write to Characteristic](#write-to-characteristic)
- [Write to descriptor](#write-to-descriptor)
- [Notify](#notify)

## EasyBle

---

**Summary**

Create an instance of EasyBLE.

**Arguments:**

- `serviceUUIDs` - `[String]`

**Return:**

`EasyBLE`

```swift
let ble = EasyBLE(serviceUUIDs: [])

do {
    try ble.startDiscovering()
} catch {
    print(error.localizedDescription)
}
```

## Discover Peripherals

---

**Summary**

Begin discovery of peripherals. Discovered peripherals will be published to the `discoveredPublisher`.

**Return:**

`throws BluetoothServiceError`

```swift
do {
    try ble.startDiscovering()
} catch {
    print(error.localizedDescription)
}

// Subscribe for publisher of discovered peripherals
self.discoveredSusbcriber = ble.discoveredPublisher.sink(receiveValue: { load in
    switch load {
    case .peripheral(let peripheral):
        print("Discovered Peripheral: \(peripheral)")
        break
    default:
        break
    }
})
```

## Discover Services

---

**Summary**

Discover services of peripheral. Discovered services will be published to the `discoveredPublisher`.

```swift
self.discoveredSusbcriber = ble.discoveredPublisher.sink(receiveValue: { load in
    switch load {
    case .peripheral(let peripheral):
        // Discover services
        ble.discoverServices(forPeripheral: peripheral, serviceUUIDs: nil)
        break
    case .services(let services):
        print("Discovered Services: \(services)")
        break
    default:
        break
    }
})
```

## Discover Characteristics

---

**Summary**

Discover characteristics of service. Discovered characteristics will be published to the `discoveredPublisher`.

```swift
self.discoveredSusbcriber = ble.discoveredPublisher.sink(receiveValue: { load in
    switch load {
    case .peripheral(let peripheral):
        // Discover services
        ble.discoverServices(forPeripheral: peripheral, serviceUUIDs: nil)
        break
    case .services(let services):
        for service in services {
            ble.discoverCharacteristics(forService: service, characteristicUUIDs: nil)
        }
        break
    case .characteristics(let characteristics):
        print("Discovered Characteristics: \(characteristics)")
        break
    default:
        break
    }
})
```

## Discover Descriptors

---

**Summary**

Discover descriptors of characteristic. Discovered descriptors will be published to the `discoveredPublisher`.

```swift
self.discoveredSusbcriber = ble.discoveredPublisher.sink(receiveValue: { load in
    switch load {
    case .peripheral(let peripheral):
        // Discover services
        ble.discoverServices(forPeripheral: peripheral, serviceUUIDs: nil)
        break
    case .services(let services):
        for service in services {
            ble.discoverCharacteristics(forService: service, characteristicUUIDs: nil)
        }
        break
    case .characteristics(let characteristics):
        for characteristic in characteristics {
            ble.discoverDescriptors(forCharacteristic: characteristic)
        }
        break
    case .descriptors(let descriptors):
        print("Discovered Descriptors: \(descriptors)")
        break
    }
})
```

## Peripheral Updates

---

**Summary**

Subscriber to peripheral updates such as when a peripheral connects or disconnects.

```swift
// Subscribe for peripheral updates
self.peripheralsSubscriber = ble.peripheralPublisher.sink(receiveCompletion: { error in
    // Error
    switch error {
    case .failure(let error):
        switch error {
        case .connectionError(let peripheral, let description):
            print("Peripheral: \(peripheral), error description: \(description)")
            break
        default:
            break
        }
    default:
        break
    }
}, receiveValue: { peripheral in
    // Success
    print("Peripheral: \(peripheral)")
})
```

## Write to Characteristic

---

**Summary**

Write to characteristic. Writing to a characteristic, reading, or enabling notification for a characteristic will trigger the `valuesPublisher`.

```swift
ble.write(value: data, toCharacteristic: characteristic, type: .withResponse)

// Subscribe for value
self.valuesSubscriber = ble.valuePublisher.sink(receiveValue: { load in
    switch load {
    case .characteristic(let characteristic):
        print("Characteristic Data: \(String(describing: characteristic.value))")
    }
    default:
        break
})
```

## Write to Descriptor

---

**Summary**

Write to descriptor. Writing to a descriptor or reading will trigger the `valuesPublisher`.

```swift
ble.write(value: data, toDescriptor: descriptor)

// Subscribe for value
self.valuesSubscriber = ble.valuePublisher.sink(receiveValue: { load in
    switch load {
    case .descriptor(let descriptor):
        print("Descriptor Data: \(String(describing: descriptor.getValue()))")
    default:
        break
})
```

## Notify

---

**Summary**

Enable notifications for a characteristic. Writing to a characteristic, reading, or enabling notification for a characteristic will trigger the `valuesPublisher`.

```swift
ble.notify(true, forCharacteristic: characteristic)

// Subscribe for value
self.valuesSubscriber = ble.valuePublisher.sink(receiveValue: { load in
    switch load {
    case .characteristic(let characteristic):
        print("Characteristic Data: \(String(describing: characteristic.value))")
    }
    default:
        break
})
```
