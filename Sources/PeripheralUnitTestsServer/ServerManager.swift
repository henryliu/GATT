//
//  ServerManager.swift
//  GATT
//
//  Created by Alsey Coleman Miller on 4/3/16.
//  Copyright © 2016 PureSwift. All rights reserved.
//

import Foundation
import Bluetooth
import GATT
import GATTTest

let sleepTime: UInt32 = 60

let peripheral: PeripheralManager = {
    
    let peripheral = PeripheralManager()
    
    peripheral.log = { print($0) }
    
    #if os(macOS)
        peripheral.waitForPoweredOn()
    #endif
    
    for service in TestProfile.services {
        
        let _ = try! peripheral.add(service: service)
    }
    
    peripheral.willRead = willRead
    peripheral.willWrite = willWrite
    
    try! peripheral.start()
    
    print("Sleeping for \(sleepTime) seconds...")
    
    sleep(sleepTime)
    
    return peripheral
}()

private(set) var readServices: [BluetoothUUID] = []

private(set) var writtenServices: [BluetoothUUID] = []

private func willRead(central: Central, UUID: BluetoothUUID, value: Data, offset: Int) -> ATT.Error? {
    
    print("Central \(central.identifier) will read characteristic \(UUID)")
    
    readServices.append(UUID)
    
    return nil
}

private func willWrite(central: Central, UUID: BluetoothUUID, value: Data, newValue: Data) -> ATT.Error? {
    
    print("Central \(central.identifier) will write characteristic \(UUID)")
    
    writtenServices.append(UUID)
    
    return nil
}
