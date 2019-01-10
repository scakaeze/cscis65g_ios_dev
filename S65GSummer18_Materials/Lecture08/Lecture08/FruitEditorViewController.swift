//
//  FruitEditorViewController.swift
//  Lecture08
//
//  Created by Van Simmons on 7/23/18.
//  Copyright © 2018 ComputeCycles, LLC. All rights reserved.
//

import UIKit

typealias UpdateClosure = (String) -> Void

class FruitEditorViewController: UIViewController {

    @IBOutlet weak var gridView: GridView!
    @IBOutlet weak var textField: UITextField!
    var fruit: String?
    var updateClosure: UpdateClosure?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.text = fruit
    }
         @IBAction func reallySave(_ sender: UIButton) {
        guard let newFruit = textField.text else { return }
        updateClosure?(newFruit)
        dismiss(animated: true, completion: nil)
    }

    @IBAction func save(_ sender: UIBarButtonItem) {
        guard let newFruit = textField.text else { return }
        updateClosure?(newFruit)
        dismiss(animated: true, completion: nil)
    }

}
