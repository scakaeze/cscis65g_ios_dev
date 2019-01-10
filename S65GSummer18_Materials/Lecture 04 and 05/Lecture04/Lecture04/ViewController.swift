//
//  ViewController.swift
//  Lecture04
//
//  Created by Van Simmons on 7/9/18.
//  Copyright © 2018 ComputeCycles, LLC. All rights reserved.
//

import UIKit

let transform: CGAffineTransform = CGAffineTransform(rotationAngle: -3.14159265358979323846/4.0)

class ViewController: UIViewController {

    @IBOutlet weak var xView: XView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func step(_ sender: Any) {
        xView.grid = xView.grid.next()
    }
    
}

