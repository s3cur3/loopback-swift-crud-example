//
//  WidgetViewController.swift
//  loopback-swift-crud-example
//
//  Created by Kevin Goedecke on 12/23/15.
//  Copyright © 2015 kevingoedecke. All rights reserved.
//

import UIKit

class WidgetViewController: UIViewController   {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var numberValueSlider: UISlider!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
        navigationController!.popViewController(animated: true)
    }
    
    var widget: Widget?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let button = sender as? UIBarButtonItem {
			if saveButton === button {
				if let _ = widget {
					widget!.name = nameTextField.text ?? ""
					widget!.bars = Int(numberValueSlider.value) as NSNumber
					widget?.save(success: { () -> Void in
						print("Successfully updated Widget: Name \(self.widget!.name), bars \(self.widget!.bars)")
					}, failure: { (error: Error?) -> Void in
						print(error!)
					})
				}
				else    {
					if let name = nameTextField.text, name != "" {
						widget = AppDelegate.widgetRepository.model(with: nil) as? Widget
						widget!.name = name
						widget!.bars = Int(numberValueSlider.value) as NSNumber
						widget?.save(success: { () -> Void in
							print("Successfully created new Widget: Name \(self.widget!.name), bars \(self.widget!.bars)")
						}, failure: { (error: Error?) -> Void in
							print(error!)
						})
					}
				}
			}
		}
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let widget = widget  {
            nameTextField.text = widget.name
            numberValueSlider.value = Float(widget.bars)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
