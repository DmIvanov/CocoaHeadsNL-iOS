//
//  LocatedCompaniesViewController.swift
//  CocoaHeadsNL
//
//  Created by Bart Hoffman on 03/06/15.
//  Copyright (c) 2015 Stichting CocoaheadsNL. All rights reserved.
//

import Foundation
import UIKit
import Crashlytics

class LocatedCompaniesViewController: UITableViewController {

    var companyDict = NSDictionary()
    var companiesArray = NSMutableArray()

    override func viewDidLoad() {
        super.viewDidLoad()

        let backItem = UIBarButtonItem(title: "Companies", style: .Plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backItem
    }

    override func viewWillAppear(animated: Bool) {

            if (companyDict.objectForKey("company") != nil) {
                companiesArray = companyDict.objectForKey("company") as! NSMutableArray
            }
    }

    //MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowDetail" {

            if let indexPath = self.tableView.indexPathForCell(sender as! UITableViewCell) {
                let company = self.companiesArray.objectAtIndex(indexPath.row) as! Company
                let dataSource = CompanyDataSource(object: company)
                dataSource.fetchAffiliateLinks()

                let detailViewController = segue.destinationViewController as! DetailViewController
                detailViewController.dataSource = dataSource
                
                Answers.logContentViewWithName("Show company details",
                                               contentType: "Company",
                                               contentId: company.name!,
                                               customAttributes: nil)
            }
        }
    }

    //MARK: - UITableViewDelegate

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return companiesArray.count
    }

    //MARK: - UITableViewDataSource

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("defaultCell", forIndexPath: indexPath)

        if let company = companiesArray.objectAtIndex(indexPath.row) as? Company {

            cell.textLabel!.text = company.name
            cell.imageView?.image =  company.smallLogoImage
        }
        return cell
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }

    //MARK: - UITableViewDelegate

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.performSegueWithIdentifier("ShowDetail", sender: tableView.cellForRowAtIndexPath(indexPath))
    }

}
