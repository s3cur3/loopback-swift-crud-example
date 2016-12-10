//
//  MyTableViewController.swift
//  loopback-swift-crud-example
//
//  Created by Kevin Goedecke on 12/22/15.
//  Copyright © 2015 kevingoedecke. All rights reserved.
//

import UIKit
import LoopBack

class MyTableViewController: UITableViewController  {
    
    var widgets = [Widget]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = editButtonItem
		
		AppDelegate.widgetRepository.all(
			success: { (fetchedWidgets) -> Void in
				self.widgets = fetchedWidgets as! [Widget]
				self.tableView.reloadData()
		},
			failure: { (error: Error?) -> Void in
				print(error!)
		});
    }
	
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            widgets[indexPath.row].destroy(success: { () -> Void in
                self.widgets.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .fade)
                }, failure: { (error: Error?) -> Void in
					print("Error writing to URL: \(error!)")
            })
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return widgets.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as! WidgetTableViewCell
        cell.nameLabel.text = widgets[indexPath.row].name
		if let bars = widgets[indexPath.row].bars {
			cell.valueLabel.text = String(describing: bars)
		}
		else {
			cell.valueLabel.text = "None"
		}
		
        return cell
    }
    
    // MARK: - Edit and Add Widget Segue operations
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail" {
            let widgetDetailViewController = segue.destination as! WidgetViewController
            if let selectedWidgetCell = sender as? WidgetTableViewCell {
                let indexPath = tableView.indexPath(for: selectedWidgetCell)!
                let selectedWidget = widgets[indexPath.row]
                widgetDetailViewController.widget = selectedWidget
            }
        }
        else if segue.identifier == "AddItem" {
            NSLog("Adding new widget")
        }
        
    }
    
    @IBAction func unwindToWidgetList(_ sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? WidgetViewController, let widget = sourceViewController.widget {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                widgets[selectedIndexPath.row] = widget
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
            else    {
                let newIndexPath = IndexPath(row: widgets.count, section: 0)
                self.widgets.append(widget)
                self.tableView.insertRows(at: [newIndexPath], with: .bottom)
            }
        }
    }
}
