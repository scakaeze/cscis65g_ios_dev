//
//  InstrumentationViewController.swift
//  Lecture10
//
//  Created by Van Simmons on 7/30/18.
//  Copyright © 2018 ComputeCycles, LLC. All rights reserved.
//

import UIKit

class InstrumentationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func setOnOff(_ sender: UISwitch) {
        Engine.sharedInstance.interval = sender.isOn ? 0.5 : 0.0
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func add(_ sender: UIBarButtonItem) {
    }
    
}
