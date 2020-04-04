//
//  HomeTableViewController.swift
//  ClassBot
//
//  Created by Nathan FALLET on 04/04/2020.
//  Copyright © 2020 Nathan FALLET. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {
    
    var list: APIList?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Navigation bar
        title = "ClassBot"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Register cells
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? list?.cours?.count ?? 0 : list?.devoirs?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Cours" : "Devoirs"
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }

}
