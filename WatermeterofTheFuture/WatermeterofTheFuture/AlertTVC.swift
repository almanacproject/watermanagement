//
//  AlertTVC.swift
//  WatermeterofTheFuture
//
//  Created by Thomas Gilbert on 26/04/16.
//  Copyright © 2016 Thomas Gilbert. All rights reserved.
//

import UIKit

class AlertTVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var alertTable: UITableView!
    
    var alertList: [Alert] = [] {
        didSet {
            alertTable?.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 100
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AlertCell", forIndexPath: indexPath) as! WaterEventCell

        cell.utilityTextLabel.text = "Thomas"
        
        //cell.utilityTextLabel.text = alertList[indexPath.row].Title
        //cell.alertTimeStamp?.text = NSDateFormatter.localizedStringFromDate(alertList[indexPath.row].TimeStamp!, dateStyle: .MediumStyle, timeStyle: .MediumStyle)

        return cell
    }
}
