//
//  InstrumentationViewController.swift
//  FinalProject
//
//  Created by Stephen Akaeze on 8/4/18.
//  Copyright © 2018 Harvard University. All rights reserved.
//

import UIKit

let nc = NotificationCenter.default

struct gridSettings{
    var gridSize:Int = 10
    var gridTimerRate: Double = 0.0
}


let newRowNoticationName = Notification.Name(rawValue: "newRow")
let sendGridSettings = Notification.Name(rawValue: "newSettings")
var oldCurrentGridSettings = gridSettings()


class InstrumentationViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var currentGridSize: UITextField!
    @IBOutlet weak var currentGridSizestepper: UIStepper!
    @IBOutlet weak var refreshRateSlider: UISlider!
    @IBOutlet weak var refreshRateStatus: UISwitch!
    @IBOutlet weak var reFreshRateLabel: UILabel!
    var newGridSettings: gridSettings! = gridSettings()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.currentGridSize.text = "10"
        self.reFreshRateLabel.text = "0.0"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let info = ["newGridSettings": self.newGridSettings] as [String : Any]
        nc.post(name: sendGridSettings, object: self, userInfo:info)
    }
    
    
    @IBAction func newRowRequested(_ sender: UIBarButtonItem) {
        let nc = NotificationCenter.default
        let info = ["newEmptyRow": "Send"]
        nc.post(name: newRowNoticationName, object: nil, userInfo:info)
    }
    
    
    
    @IBAction func gridSizeEdited(_ sender: UITextField) {
        guard let text = sender.text else { return }
        guard let size = Double(text) else { return }
        guard size >= Double(self.currentGridSizestepper.minimumValue) && size <= Double(self.currentGridSizestepper.maximumValue) else {return }
        
        self.currentGridSize.text = "\(Int(size))"
        self.currentGridSizestepper.value = size
        self.newGridSettings.gridSize = Int(size)
        sender.resignFirstResponder()
    }
    
    
    @IBAction func gridSizeStepped(_ sender: UIStepper) {
        let newSize = Int(sender.value)
        self.currentGridSize.text = "\(newSize)"
        self.newGridSettings.gridSize = newSize
    }
    
    
    @IBAction func refreshRateChanged(_ sender: UISlider) {
        if (refreshRateStatus.isOn){
            reFreshRateLabel.text = "\(Double(sender.value))"
            newGridSettings.gridTimerRate = Double(sender.value)
        }
        else {
            refreshRateSlider.value = refreshRateSlider.minimumValue
            reFreshRateLabel.text = "0.0"
            newGridSettings.gridTimerRate = 0.0
        }
    }
    
    
    @IBAction func refreshStatusChanged(_ sender: UISwitch) {
        if (!(refreshRateStatus.isOn)){
            reFreshRateLabel.text = "0.0"
            refreshRateSlider.value = refreshRateSlider.minimumValue
            newGridSettings.gridTimerRate = 0.0
        }
    }
    
    
   

}
