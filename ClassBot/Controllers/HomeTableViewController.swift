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
        title = "name".localized()
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Register cells
        tableView.register(CoursTableViewCell.self, forCellReuseIdentifier: "coursCell")
        tableView.register(DevoirsTableViewCell.self, forCellReuseIdentifier: "devoirsCell")
        
        // Refresh control
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(reloadContent(_:)), for: .valueChanged)
        
        // Load content
        loadContent()
    }
    
    func loadContent() {
        // Get user defaults
        let data = UserDefaults.standard
        
        // Check if workspace is configured
        if let host = data.string(forKey: "host") {
            // Fetch API
            APIRequest("GET", host: host, path: "/api/liste").execute(APIList.self) { data, status in
                // Check data
                if let data = data {
                    // Set data
                    self.list = data
                    
                    // Update tableView
                    self.tableView.reloadData()
                }
                
                // End refreshing
                self.refreshControl?.endRefreshing()
            }
        } else {
            // Show configuration controller
            let configVC = ConfigurationViewController() { host in
                // Save data
                data.set(host, forKey: "host")
                data.synchronize()
                
                // Load content again
                self.loadContent()
            }
            present(UINavigationController(rootViewController: configVC), animated: true, completion: nil)
        }
    }
    
    @objc func reloadContent(_ sender: UIRefreshControl) {
        // Reload content
        loadContent()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? list?.cours?.count ?? 0 : list?.devoirs?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "cours".localized() : "devoirs".localized()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0, let cours = list?.cours?[indexPath.row] {
            // Create cell
            return (tableView.dequeueReusableCell(withIdentifier: "coursCell", for: indexPath) as! CoursTableViewCell).with(cours: cours)
        } else if indexPath.section == 1, let devoirs = list?.devoirs?[indexPath.row] {
            // Create cell
            return (tableView.dequeueReusableCell(withIdentifier: "devoirsCell", for: indexPath) as! DevoirsTableViewCell).with(devoirs: devoirs)
        }
        
        fatalError("Unknown cell!")
    }

}
