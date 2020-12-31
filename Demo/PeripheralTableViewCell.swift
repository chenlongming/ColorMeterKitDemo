//
//  PeripheralTableViewCell.swift
//  Demo
//
//  Created by chenlongmingob@gmail.com on 2020/12/22.
//

import UIKit
import CoreBluetooth

class PeripheralTableViewCell: UITableViewCell {
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var uuidLabel: UILabel!
    
    var delegate: PeripheralTableViewCellDelegate?
    var peripheral: CBPeripheral! {
        didSet {
            nameLabel.text = peripheral.name
            uuidLabel.text = peripheral.identifier.uuidString
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    @IBAction func detail() {
        delegate?.peripheralTalbeCell(peripheral: peripheral)
    }
}
