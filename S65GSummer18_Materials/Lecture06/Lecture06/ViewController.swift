//
//  ViewController.swift
//  Lecture06
//
//  Created by Van Simmons on 7/16/18.
//  Copyright © 2018 ComputeCycles, LLC. All rights reserved.
//

import UIKit

class ViewController: UIViewController, GridViewDataSource, UITextFieldDelegate, EngineDelegate {
    
    @IBOutlet weak var intervalTextField: UITextField!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var gridView: XView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gridView.dataSource = self
        
        Engine.sharedInstance.delegate = self
        Engine.sharedInstance.updateClosure = { (engine:Engine) -> Void in
            self.gridView.setNeedsDisplay()
        }
        
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(engine(notified:)), name: EngineNoticationName, object: nil)
    }
    
    @objc func engine(notified: Notification) {
        self.gridView.setNeedsDisplay()
    }

    //MARK: EngineDelegate
    func engine(didUpdate: Engine) {
        self.gridView.setNeedsDisplay()
    }
    
    var size:Int {
        get { return Engine.sharedInstance.size }
        set { Engine.sharedInstance.size = newValue }
    }
    
    subscript(pos: Position) -> CellState {
        get { return Engine.sharedInstance.grid[pos] }
        set { Engine.sharedInstance.grid[pos] = newValue }
    }
    
    @IBAction func step(_ sender: Any) {
        Engine.sharedInstance.grid = Engine.sharedInstance.grid.next()
        gridView.setNeedsDisplay()
    }
    
    @IBAction func changeInterval(_ sender: UISlider) {
        let interval = Double(Int(sender.value))
        if Engine.sharedInstance.interval != interval {
            Engine.sharedInstance.interval = interval
        }
        intervalTextField.text = "\(slider.value)"
    }
    
    //MARK: UITextFieldDelegate
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("hey we are editing")
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("hey we ended")
    }
    
    @IBAction func didEndOnExit(_ textField: UITextField) {
        guard let text = textField.text else { slider.value = 0.0; return }
        guard let interval = Double(text) else { slider.value = 0.0; return }
        guard interval >= Double(slider.minimumValue)
            && interval <= Double(slider.maximumValue) else { slider.value = 0.0; return }
        slider.value = Float(interval)
        if Engine.sharedInstance.interval != interval {
            Engine.sharedInstance.interval = interval
        }
        textField.resignFirstResponder()
    }
    
}

