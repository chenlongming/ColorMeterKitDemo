//
//  PeripheralSettingsViewController.swift
//  Demo
//
//  Created by chenlongmingob@gmail.com on 2020/12/22.
//

import UIKit
import RxSwift
import ColorMeterKit

class PeripheralSettingsViewController: UIViewController {
    
    var cm: CMKit?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    @IBAction func whiteCalibrate() {
        cm?.whiteCalibrate().subscribe(onNext: { print("white calibrate") }, onError: { print("white calibrate error \($0)") })
    }
    
    @IBAction func blackCalibrate() {
        cm?.blackCalibrate().subscribe(onNext: { print("white calibrate") }, onError: { print("white calibrate error \($0)") })
    }
}
