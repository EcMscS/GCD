//
//  MainVC.swift
//  WhitehousePetitions
//
//  Created by Jeffrey Lai on 11/4/19.
//  Copyright © 2019 Jeffrey Lai. All rights reserved.
//
//Challenge:
//Project 9
//Modify project 1 so that loading the list of NSSL images from our bundle happens in the background. Make sure you call reloadData() on the table view once loading has finished!
//Modify project 8 so that loading and parsing a level takes place in the background. Once you’re done, make sure you update the UI on the main thread!
//Modify project 7 so that your filtering code takes place in the background. This filtering code was added in one of the challenges for the project, so hopefully you didn’t skip it!


import UIKit

class MainVC: UITabBarController{
    
    var currentTabBarTag:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupTabBar()
    }

    func setupNavBar() {
        title = "General Petitions"
        navigationController?.navigationBar.tintColor = .systemYellow
        navigationController?.navigationBar.barTintColor = .systemBackground
        
        let creditBarButton = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(showCredits))
        creditBarButton.tintColor = .systemYellow
        navigationItem.rightBarButtonItem = creditBarButton
        
        let searchBarButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchPetitions))
        searchBarButton.tintColor = .systemYellow
        navigationItem.leftBarButtonItem = searchBarButton
    }
    
    func setupTabBar() {
        tabBar.tintColor = .systemYellow
        tabBar.barTintColor = .black
        
        let firstVC = FirstTabVC()
        let firstTab = UITabBarItem(tabBarSystemItem: .history, tag: 0)
        firstVC.tabBarItem = firstTab
        
        let secondVC = SecondTabVC()
        let secondTab = UITabBarItem(tabBarSystemItem: .featured, tag: 1)
        secondVC.tabBarItem = secondTab
        
        let viewControllerList = [firstVC, secondVC]
        viewControllers = viewControllerList
    }
    
    @objc func searchPetitions() {
        let searchAC = UIAlertController(title: "Search through Petitions", message: "Type in keyword(s) to search for", preferredStyle: .alert)
        searchAC.addTextField()
        
        let submitSearch = UIAlertAction(title: "Search", style: .default) { [weak self, weak searchAC] _ in
            guard let searchRequest = searchAC?.textFields?[0].text else { return }
            self?.submit(searchRequest)
        }
        
        searchAC.addAction(submitSearch)
        present(searchAC, animated: true)
    }
    
    func submit(_ search: String) {
        if currentTabBarTag == 1 {
            print("Tag 1 is \(search)")
            let name = Notification.Name("com.talismanombile.searchTabTwo")
            let searchDict:[String:String] = ["Search": search]
            NotificationCenter.default.post(name: name, object: nil, userInfo: searchDict)
        } else {
            print("Tag 0 is \(search)")
            let name = Notification.Name("com.talismanmobile.searchTabOne")
            let searchDict:[String:String] = ["Search": search]
            NotificationCenter.default.post(name: name, object: nil, userInfo: searchDict)
        }
    }


    @objc func showCredits() {
        let creditsAC = UIAlertController(title: "Where is this data from?", message: "We The People API of the Whitehouse", preferredStyle: .alert)
        let continueAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        creditsAC.addAction(continueAction)
        present(creditsAC, animated: true)
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        currentTabBarTag = item.tag
        
        if item.tag == 1 {
            title = "Featured Petitions"
        } else {
            title = "General Petitions"
        }
    }
    
}

