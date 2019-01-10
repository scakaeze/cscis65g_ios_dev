//
//  FruitTableViewController.swift
//  Lecture08
//
//  Created by Van Simmons on 7/23/18.
//  Copyright © 2018 ComputeCycles, LLC. All rights reserved.
//

import UIKit



class FruitTableViewController: UITableViewController {
    var curr_index:IndexPath = IndexPath.init(row: 0, section: 0)
    
    var sectionNames: [String] = ["One", "Two", "Three"]
    var data: [[String]] = [
        ["apple", "banana", "cucumber"],
        ["pineapple", "grapefruit"],
        ["lemon", "lime", "pear", "blueberry", "lemon", "lime", "pear", "blueberry", "lemon", "lime", "pear", "blueberry", "lemon", "lime", "pear", "blueberry", "lemon", "lime", "pear", "blueberry", "lemon", "lime", "pear", "blueberry", "lemon", "lime", "pear", "blueberry", "lemon", "lime", "pear", "blueberry", "lemon", "lime", "pear", "blueberry", "lemon", "lime", "pear", "blueberry"]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionNames.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "White"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        cell.textLabel?.text = data[indexPath.section][indexPath.row]
        cell.detailTextLabel?.text = "here's a subtitle"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionNames[section]
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            self.data[indexPath.section].remove(at: indexPath.row)
            tableView.reloadData()
        }
        
        let edit = UITableViewRowAction(style: .normal, title: "Edit") { (action, indexPath) in
            self.tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
//////////////
            self.curr_index = indexPath
            self.performSegue(withIdentifier: "Edit", sender: self)
        }
        
        edit.backgroundColor = UIColor.blue
        delete.backgroundColor = UIColor.purple
        return [delete, edit]
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            var newData = data[indexPath.section]
            newData.remove(at: indexPath.row)
            data[indexPath.section] = newData
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.reloadData()
        }
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? FruitEditorViewController else { return }
        //guard let indexPath = self.tableView.indexPathForSelectedRow else { return }
        destination.fruit = data[curr_index.section][curr_index.row]
        
        destination.updateClosure = { (fruit) in
            self.data[self.curr_index.section][self.curr_index.row] = fruit
            self.tableView.reloadData()
        }
    }
    
    
    
    
    

}
