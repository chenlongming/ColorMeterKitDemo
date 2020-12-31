//
//  PeripheralDetailViewController.swift
//  Demo
//
//  Created by chenlongmingob@gmail.com on 2020/12/22.
//

import UIKit
import CoreBluetooth
import RxSwift
import ColorMeterKit

class PeripheralDetailViewController: UIViewController {
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var colorView: UIView!
    @IBOutlet var labLabels: [UIView]!
    @IBOutlet var rgbLabels: [UIView]!
    @IBOutlet var measureButton: UIButton! {
        didSet {
            measureButton.isEnabled = false
        }
    }
    
    
    var cm: CMKit!
    
    var peripheral: CBPeripheral!
    
    var disposeBag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        connect()
    }
    

    func connect() {
        nameLabel.text = peripheral.name
        _ = cm.connect(peripheral).subscribe(
            onNext: { [weak self] _ in
                DispatchQueue.main.async {
                    self?.measureButton.isEnabled = true
                }
            },
            onError: { print("connection error: \($0)") },
            onDisposed: { print("dispose") }
        )
    }
    
    
    @IBAction func measure() {
        _ = cm.measureWithResponse()
            .subscribe { data in
                if let data = data {
                    let color = CMColor(spectral: data.refs.map({ Double($0) }), waveStart: Int(data.waveStart), lightSource: .init(angle: .deg10, category: .D65))
                    print("Lab: \(color.lab!), XYZ: \(color.xyz!), RGB: \(color.rgb!)")
                }
            } onError: { error in
                print("measure error: \(error)")
            }
        
//        _ = cm.getStorageData(0).subscribe(onNext: { print($0!) }, onError: { print("error \($0)") })
        
//        _ = cm.getStorageCount()
//            .concatMap { count -> Observable<Int> in
//                return .from(0 ..< count)
//            }
//            .concatMap { index -> Observable<MeasureData?> in
//                return self.cm.getStorageData(UInt16(index)).retry(2).map { data in
//                    print("------------------------ index: \(index) ------------------------")
//                    print(data)
//                    print("------------------------ end ------------------------")
//                    return data
//                }
//            }
//            .subscribe()
        
//        _ = cm.getPeripheralDetail()
//            .subscribe(onNext: { print($0) })
//        _ = cm.setToleranceParameter(.init(L: 2, a: 2, b: 2, c: 2, H: 2, dE_ab: 3, dE_ch: 2, dE_cmc: 2, dE_94: 2, dE_00: 2)).subscribe()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func toSettings() {
        performSegue(withIdentifier: "settings", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "settings", let vc = segue.destination as? PeripheralSettingsViewController {
            vc.cm = cm
        }
    }

    deinit {
        print("deinit")
        _ = cm.disconnect().subscribe(onNext: { _ in print("disconnect") })
    }
}
