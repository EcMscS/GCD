//
//  FirstTabVC.swift
//  WhitehousePetitions
//
//  Created by Jeffrey Lai on 11/6/19.
//  Copyright © 2019 Jeffrey Lai. All rights reserved.
//

import UIKit

let searchTabOneNotificationKey = "com.talismanmobile.searchTabOne"

class FirstTabVC: UITableViewController {

    var keywords:String = ""
    var petitions = [Petition]()
    var searchedPetitions = [Petition]()
    var displayAll = true
    
    let searchKey = Notification.Name(rawValue: searchTabOneNotificationKey)
    
    let whitehousePetitionURL = "https://api.whitehouse.gov/v1/petitions.json?limit=100"
    let workingURL:String = "https://www.hackingwithswift.com/samples/petitions-1.json"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupObservers()
        setupView()
        setupTableView()
        fetchData()
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
    
    func fetchData() {
        displayAll = true
        let urlString = workingURL
        
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                //It's ok to Parse JSON Data
                parse(json: data)
                return
            }
        }
        
        showError()
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            tableView.reloadData()
        }
    }
    
    func showError() {
        let ac = UIAlertController(title: "Loading Error", message: "Please check your network connection and try again", preferredStyle: .alert)
        let alert = UIAlertAction(title: "OK", style: .default, handler: nil)
        ac.addAction(alert)
    }
    
    @objc func catchNotification(notification: Notification) {
        guard let searchWords = notification.userInfo!["Search"] as? String else { return }
        
        if searchWords.isEmpty {
            displayAll = true
        } else {
            searchedPetitions.removeAll()
            displayAll = false
            var resultsCount = 0
            for each in petitions {
                if each.title.lowercased().contains(searchWords.lowercased()) {
                    searchedPetitions.insert(each, at: 0)
                    resultsCount += 1
                }
            }
            showResultCount(count: resultsCount, words: searchWords)
        }
    
        tableView.reloadData()
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
