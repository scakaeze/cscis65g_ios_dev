//
//  ViewController.swift
//  Assignment3
//
//  Created by Van Simmons on 6/5/17.
//  Copyright © 2017 Harvard University. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var GridView: GridView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func step(_ sender: Any) {
        GridView.grid = GridView.grid.next()
    }
    
}

