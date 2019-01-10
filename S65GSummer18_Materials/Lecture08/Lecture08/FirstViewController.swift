//
//  FirstViewController.swift
//  Lecture08
//
//  Created by Van Simmons on 7/23/18.
//  Copyright © 2018 ComputeCycles, LLC. All rights reserved.
//

import UIKit

private let WeatherURL = "https://api.openweathermap.org/data/2.5/weather?q=Boston&appid=77e555f36584bc0c3d55e1e584960580"

private let ConfigurationURL = "https://www.dropbox.com/s/i4gp5ih4tfq3bve/S65g.json?dl=1"

class FirstViewController: UIViewController {

    var fetcher = Fetcher()
    
    @IBOutlet weak var status: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func myFunc() throws -> String {
        return "myFunc"
    }

    @IBAction func fetch(_ sender: UIButton) {
        guard let url = URL(string: ConfigurationURL) else { return }
        fetcher.fetch(url: url) { (response) in
            let op = BlockOperation {
                switch response {
                case .success(let data):
                    do {
                        var configuration = try JSONDecoder().decode([Configuration].self, from: data)
                        print("\(configuration)")
                    } catch {
                        print(error.localizedDescription)
                    }

                    self.status.text = "SUCCESS!"
                case .failure(let msg):
                    self.status.text = "Failure"
                }
            }
            OperationQueue.main.addOperation(op)
        }
    }
}

