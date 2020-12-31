//
//  ViewController.swift
//  Demo
//
//  Created by chenlongmingob@gmail.com on 2020/12/22.
//

import UIKit
import ColorMeterKit
import RxSwift
import CoreBluetooth

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIAdaptivePresentationControllerDelegate, PeripheralTableViewCellDelegate {
    @IBOutlet var button: UIButton!
    @IBOutlet var tableView: UITableView!
    
    var cm = CMKit()
    
    var items: [CBPeripheral] = []
    
    var disposable: Disposable?
    
    var tableItemsChangeQueue = DispatchQueue(label: "table_change")

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func scan() {
        if !cm.isScanning {
            print("scan")
            // clear peripherl list
            items = []
            tableView.reloadData()
            
            cm.startScan()
            disposable = cm.observeScanned()
                .subscribe(
                    onNext: { [weak self] state in
                        if let peripheral = state.peripheral, let strongSelf = self {
                            strongSelf.tableItemsChangeQueue.async {
                                strongSelf.items.append(peripheral)
                                DispatchQueue.main.async {
                                    strongSelf.tableView.insertRows(at: [IndexPath(row: strongSelf.items.count - 1, section: 0)], with: .right)
                                }
                            }
                        }
                    },
                    onError: { print("scan error: \($0)") },
                    onCompleted: { print("scan complete") },
                    onDisposed: { print("scan disposed") }
                )
        } else {
            print("stop")
            cm.stopScan()
            disposable?.dispose()
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "peripheralcell", for: indexPath)
        if let cell = cell as? PeripheralTableViewCell {
            cell.peripheral = items[indexPath.row]
            cell.delegate = self
        }
        return cell
    }
    
    func peripheralTalbeCell(peripheral: CBPeripheral) {
        performSegue(withIdentifier: "peripheraldetail", sender: peripheral)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "peripheraldetail", let vc = segue.destination as? PeripheralDetailViewController, let peripheral = sender as? CBPeripheral {
            vc.peripheral = peripheral
            vc.cm = cm
        }
    }
    
    deinit {
        if cm.isScanning {
            cm.stopScan()
        }
        disposable?.dispose()
    }
}

