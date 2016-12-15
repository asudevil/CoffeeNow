//
//  ChangeSettings.swift
//  CoffeeNow
//
//  Created by admin on 12/13/16.
//  Copyright © 2016 CodeWithFelix. All rights reserved.
//

import UIKit

class ChangeSettings: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let cellIdentifier = "Cell"
    
    var tableView: UITableView  =   UITableView()
    let settingsSection1 = ["Account","Privacy","Notifications", "Language", "Sounds"]
    let settingsSection2 = ["Messages","Nearby Places","Friends","Events","Location","Favorites", "Blocking"]
    
    let sectionHeaders = ["Privacy", "Contacts"]
    let sectionFooters = ["Set your privacy preferences","Edit your contacts settings"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height), style: UITableViewStyle.grouped)
        tableView.delegate      =   self
        tableView.dataSource    =   self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        self.view.addSubview(self.tableView)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         var numOfRows = 0
        
        switch section {
        case 0:
            numOfRows = settingsSection1.count
        case 1:
            numOfRows = settingsSection2.count
        default: break
        }
        return numOfRows
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "cell")
        
        switch indexPath.section {
        case 0:
            cell.textLabel!.text = settingsSection1 [indexPath.row]
            
        case 1:
            cell.textLabel!.text = settingsSection2 [indexPath.row]
        default: break
        }
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionHeaders[section]
    }
//    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
//        return sectionFooters[section]
//    }
   
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let view = UIView()
        let footerVersion = UILabel(frame: CGRect(x: 8, y: 1, width: tableView.frame.width, height: 15))
        footerVersion.textAlignment = .center
        footerVersion.font = UIFont.systemFont(ofSize: 14)
        footerVersion.textColor = UIColor.lightGray
        footerVersion.text = sectionFooters[section]
        
        view.addSubview(footerVersion)
        return view
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            print(settingsSection1[indexPath.row])
        case 1:
            print(settingsSection2[indexPath.row])
        default: break
        }
    }
}
