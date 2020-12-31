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
    @IBOutlet var labLabels: [UILabel]!
    @IBOutlet var rgbLabels: [UILabel]!
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
                    let (red, green, blue) = color.rgb
                    let (l, a, b) = color.lab
                    DispatchQueue.main.async {
                        self.colorView.backgroundColor = UIColor(red: CGFloat(red) / 255, green: CGFloat(green) / 255, blue: CGFloat(blue) / 255, alpha: 1)
                        self.labLabels.first(where: { $0.restorationIdentifier == "l" })?.text = String(l)
                        self.labLabels.first(where: { $0.restorationIdentifier == "a" })?.text = String(a)
                        self.labLabels.first(where: { $0.restorationIdentifier == "b" })?.text = String(b)
                        
                        self.rgbLabels.first(where: { $0.restorationIdentifier == "red" })?.text = String(red)
                        self.rgbLabels.first(where: { $0.restorationIdentifier == "green" })?.text = String(green)
                        self.rgbLabels.first(where: { $0.restorationIdentifier == "blue" })?.text = String(blue)
                    }
                }
            } onError: { error in
                print("measure error: \(error)")
            }
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
