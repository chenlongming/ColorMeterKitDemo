//
//  PeripheralTableViewCellDelegate.swift
//  Demo
//
//  Created by chenlongmingob@gmail.com on 2020/12/22.
//

import Foundation
import CoreBluetooth

protocol PeripheralTableViewCellDelegate {
    func peripheralTalbeCell(peripheral: CBPeripheral)
}
