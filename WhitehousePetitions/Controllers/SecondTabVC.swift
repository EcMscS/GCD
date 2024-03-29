//
//  SecondTabVC.swift
//  WhitehousePetitions
//
//  Created by Jeffrey Lai on 11/6/19.
//  Copyright © 2019 Jeffrey Lai. All rights reserved.
//
//Use of PerformSelector 

import UIKit

let searchTabTwoNotificationKey = "com.talismanombile.searchTabTwo"

class SecondTabVC: UITableViewController {

    var petitions = [Petition]()
    var searchedPetitions = [Petition]()
    let whitehousePetitionURL = "https://api.whitehouse.gov/v1/petitions.json?signatureCountFloor=10000&limit=100"
    let workingURL:String = "https://www.hackingwithswift.com/samples/petitions-2.json"
    var displayAll = true
    
    let searchKey = Notification.Name(rawValue: searchTabTwoNotificationKey)
    
    override func viewDidLoad() {
        super.viewDidLoad()


        setupObservers()
        setupView()
        setupTableView()
        performSelector(inBackground: #selector(fetchData), with: nil)
    }

    func setupObservers() {
        NotificationCenter.default.addObserver(forName: searchKey, object: nil, queue: nil, using: catchNotification(notification:))
    }
    
    func setupView() {
        view.backgroundColor = .systemBackground

    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(SubtitleTableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    @objc func fetchData() {
        let urlString = whitehousePetitionURL
        
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                //It's ok to Parse JSON Data
                self.parse(json: data)
                return
            }
        }

    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            performSelector(onMainThread: #selector(reload), with: nil, waitUntilDone: false)
        } else {
            performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
        }
    }
    
    @objc func reload() {
        tableView.reloadData()
    }
    
    @objc func showError() {
        let ac = UIAlertController(title: "Loading Error", message: "Please check your network connection and try again", preferredStyle: .alert)
        let alert = UIAlertAction(title: "OK", style: .default, handler: nil)
        ac.addAction(alert)
    }
    
    @objc func catchNotification(notification: Notification) {
        guard let searchWords = notification.userInfo!["Search"] as? String else { return }
        
        DispatchQueue.global(qos: .userInitiated).async {
                if searchWords.isEmpty {
                    self.displayAll = true
                } else {
                    self.searchedPetitions.removeAll()
                    self.displayAll = false
                    var resultsCount = 0
                    for each in self.petitions {
                        if each.title.lowercased().contains(searchWords.lowercased()) {
                            self.searchedPetitions.insert(each, at: 0)
                            resultsCount += 1
                        }
                    }
                    
                    DispatchQueue.main.async {
                        self.showResultCount(count: resultsCount, words: searchWords)
                    }

                }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func showResultCount(count: Int, words: String) {
        let resultAC = UIAlertController(title: "Searched for '\(words)' in Petition Title", message: "Found \(count) Petitions", preferredStyle:.alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        resultAC.addAction(action)
        present(resultAC, animated: true)
    }

    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if displayAll == true {
            return petitions.count
        } else {
            return searchedPetitions.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        var petition = Petition(title: "", body: "", signatureCount: 0)
        if displayAll == true {
            petition = petitions[indexPath.row]
        } else {
            petition = searchedPetitions[indexPath.row]
        }
        
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewVC()
        
        if displayAll == true {
            vc.detailItem = petitions[indexPath.row]
        } else {
            vc.detailItem = searchedPetitions[indexPath.row]
        }
        
        navigationController?.pushViewController(vc, animated: true)
    }
    

}
