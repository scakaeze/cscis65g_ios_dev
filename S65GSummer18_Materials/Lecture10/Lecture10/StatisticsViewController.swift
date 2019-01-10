//
//  SecondViewController.swift
//  Lecture10
//
//  Created by Van Simmons on 7/30/18.
//  Copyright © 2018 ComputeCycles, LLC. All rights reserved.
//

import UIKit

class StatisticsViewController: UIViewController {

    @IBOutlet weak var numLiving: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(engine(notified:)), name: EngineNoticationName, object: nil)
    }

    @objc func engine(notified: Notification) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

