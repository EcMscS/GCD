//
//  MainVC.swift
//  WhitehousePetitions
//
//  Created by Jeffrey Lai on 11/4/19.
//  Copyright © 2019 Jeffrey Lai. All rights reserved.
//
//Challenge:
//1) Add a Credits button to the top-right corner using UIBarButtonItem. When this is tapped, show an alert telling users the data comes from the We The People API of the Whitehouse.
//2) Let users filter the petitions they see. This involves creating a second array of filtered items that contains only petitions matching a string the user entered. Use a UIAlertController with a text field to let them enter that string. This is a tough one, so I’ve included some hints below if you get stuck.
//3) Experiment with the HTML – this isn’t a HTML or CSS tutorial, but you can find lots of resources online to give you enough knowledge to tinker with the layout a little.

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

