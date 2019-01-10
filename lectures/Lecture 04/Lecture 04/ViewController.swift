//
//  ViewController.swift
//  Lecture 04
//
//  Created by Stephen Akaeze on 7/13/18.
//  Copyright © 2018 Stephen Akaeze. All rights reserved.
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

