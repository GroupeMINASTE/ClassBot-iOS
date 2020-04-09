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
        tableView.register(LabelTableViewCell.self, forCellReuseIdentifier: "labelCell")
        tableView.register(CoursTableViewCell.self, forCellReuseIdentifier: "coursCell")
        tableView.register(DevoirsTableViewCell.self, forCellReuseIdentifier: "devoirsCell")
        
        // Refresh control
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(reloadContent(_:)), for: .valueChanged)
        
        // Migrate from old host to new configuration if required
        migrateHostToConfiguration()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Load content
        loadContent()
    }
    
    func loadContent() {
        // Check if host is configured
        if let configuration = getConfiguration() {
            // Fetch API
            APIRequest("GET", configuration: configuration, path: "/api/liste").execute(APIList.self) { data, status in
                // Check data
                if let data = data {
                    // Set data
                    self.list = data
                } else {
                    // Set empty data
                    self.list = APIList()
                }
                
                // Update tableView
                self.tableView.reloadData()
                
                // End refreshing
                self.refreshControl?.endRefreshing()
            }
        } else {
            // Show configuration controller
            showConfiguration()
        }
    }
    
    public func migrateHostToConfiguration() {
        // Get user defaults
        let data = UserDefaults.standard
        
        // If host is defined
        if let host = data.string(forKey: "host") {
            // Remove host from data
            data.removeObject(forKey: "host")
            data.synchronize()
            
            // Set the new configuration
            setConfiguration(configuration: host.toAPIConfiguration())
        }
    }
    
    @objc func reloadContent(_ sender: UIRefreshControl) {
        // Reload content
        loadContent()
    }
    
    // MARK: - Host management
    
    func getConfiguration() -> APIConfiguration? {
        // Get user defaults
        let data = UserDefaults.standard
        
        // Return configuration
        if let configuration = data.data(forKey: "configuration") {
            do {
                return try JSONDecoder().decode(APIConfiguration.self, from: configuration)
            } catch let jsonError {
                print(jsonError)
            }
        }
        
        // Nothing configured
        return nil
    }
    
    func setConfiguration(configuration: APIConfiguration) {
        // Get user defaults
        let data = UserDefaults.standard
        
        // Write configuration
        do {
            data.set(try JSONEncoder().encode(configuration), forKey: "configuration")
            data.synchronize()
        } catch let jsonError {
            print(jsonError)
        }
    }
    
    func showConfiguration() {
        // Show configuration controller
        let configVC = ConfigurationViewController() { configuration in
            // Save data
            self.setConfiguration(configuration: configuration)
            
            // Load content again
            self.loadContent()
        }
        present(UINavigationController(rootViewController: configVC), animated: true, completion: nil)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? list?.cours?.count ?? 1 : section == 1 ? list?.devoirs?.count ?? 1 : 3
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "cours".localized() : section == 1 ? "devoirs".localized() : "more".localized()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            // Create cell
            if let cours = list?.cours?[indexPath.row] {
                return (tableView.dequeueReusableCell(withIdentifier: "coursCell", for: indexPath) as! CoursTableViewCell).with(cours: cours)
            } else {
                return (tableView.dequeueReusableCell(withIdentifier: "labelCell", for: indexPath) as! LabelTableViewCell).with(text: "chargement".localized())
            }
        } else if indexPath.section == 1 {
            // Create cell
            if let devoirs = list?.devoirs?[indexPath.row] {
                return (tableView.dequeueReusableCell(withIdentifier: "devoirsCell", for: indexPath) as! DevoirsTableViewCell).with(devoirs: devoirs)
            } else {
                return (tableView.dequeueReusableCell(withIdentifier: "labelCell", for: indexPath) as! LabelTableViewCell).with(text: "chargement".localized())
            }
        } else {
            if indexPath.row == 0 {
                // Configuration
                return (tableView.dequeueReusableCell(withIdentifier: "labelCell", for: indexPath) as! LabelTableViewCell).with(text: "configuration".localized(), accessory: .disclosureIndicator)
            } else if indexPath.row == 1 {
                // Groupe MINASTE
                return (tableView.dequeueReusableCell(withIdentifier: "labelCell", for: indexPath) as! LabelTableViewCell).with(text: "Groupe MINASTE", accessory: .disclosureIndicator)
            } else if indexPath.row == 2 {
                // Delta
                return (tableView.dequeueReusableCell(withIdentifier: "labelCell", for: indexPath) as! LabelTableViewCell).with(text: "delta".localized(), accessory: .disclosureIndicator)
            }
        }
        
        fatalError("Unknown cell!")
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2 {
            if indexPath.row == 0 {
                // Configuration
                showConfiguration()
            } else if indexPath.row == 1 {
                // Groupe MINASTE
                if let url = URL(string: "https://www.groupe-minaste.org/") {
                    UIApplication.shared.open(url)
                }
            } else if indexPath.row == 2 {
                // Delta
                if let url = URL(string: "https://apps.apple.com/app/delta-math-helper/id1436506800") {
                    UIApplication.shared.open(url)
                }
            }
        }
    }

}
