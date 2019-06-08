//
//  ViewController.swift
//  SearchBarInTable
//
//  Created by Xiaodan Wang on 10/20/17.
//  Copyright © 2017 Xiaodan Wang. All rights reserved.
// Partially finessed by Justin Lindberg
//

import UIKit
import UserNotifications

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet var table: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    
    var animalArray = [Animal]()
    var currentAnimalArray = [Animal]() //update table
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let content = UNMutableNotificationContent()
        content.title = "Black Dollar Goal Reached!"
        content.body = "Congrats consumer! You have reached the goal of contributing $60 Black Dollars this month."
        content.sound = UNNotificationSound.default()
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
        
        let request = UNNotificationRequest(identifier: "testIdentifier", content: content, trigger: trigger)
        
//        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
            if let error = error {
                print("notification error! \(error)")
            }
            print("notification completion handler!")
        })
        
        setUpBlackOwnedBusinesses() // Used to begin creating and visualizing these businessses.
        setUpSearchBar()
        alterLayout()
            //Notifications API That Ya Boy Is Integrating Himself
        
//        let content = UNMutableNotificationContent()
//        content.title = "Title"
//        content.body = "Body"
//        content.sound = UNNotificationSound.default()
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
//        let request = UNNotificationRequest(identifier: "testIdentifier", content: content, trigger: trigger)
//
//       UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        
    }
    
    
    private func setUpBlackOwnedBusinesses() {
        //Remember cat = CLothing Brand, bear = Health & Beauty and dog = Restaurant
        // Few Businesses
        animalArray.append(Animal(name: "Soulful Xpressions", category: .cat, image:"1"))
        animalArray.append(Animal(name: "For The Leaux", category: .cat, image:"2"))
        animalArray.append(Animal(name: "ManScape", category: .bear, image:"3"))
        // Few Businesses
        animalArray.append(Animal(name: "Very Rare Brand", category: .cat, image:"4"))
        animalArray.append(Animal(name: "Mama G's Country Kitchen", category: .dog, image:"5"))
        animalArray.append(Animal(name: "Lffls Dress Shoes", category: .bird, image:"6"))
        animalArray.append(Animal(name: "The Marathon Clothing", category: .cat, image: "7"))
        animalArray.append(Animal(name: "Lo-Lo's Chicken & Waffles", category: .dog, image:"8"))
        
        currentAnimalArray = animalArray
    }
    
    private func setUpSearchBar() {
        searchBar.delegate = self
    }
    
    func alterLayout() {
        table.tableHeaderView = UIView()
        // search bar in section header
        table.estimatedSectionHeaderHeight = 50
        // search bar in navigation bar
        //navigationItem.leftBarButtonItem = UIBarButtonItem(customView: searchBar)
        navigationItem.titleView = searchBar
        searchBar.showsScopeBar = false // you can show/hide this dependant on your layout
        searchBar.placeholder = "Let's Search Black Owned!"
    }
        
    // Table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentAnimalArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? TableCell else {
            return UITableViewCell()
        }
        cell.nameLbl.text = currentAnimalArray[indexPath.row].name
        cell.categoryLbl.text = currentAnimalArray[indexPath.row].category.rawValue
        cell.imgView.image = UIImage(named:currentAnimalArray[indexPath.row].image)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    // These two functions can be used if you want to show the search bar in the section header
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        return searchBar
//    }
    
//    // search bar in section header
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return UITableViewAutomaticDimension
//    }
    
    // Search Bar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        currentAnimalArray = animalArray.filter({ animal -> Bool in
            switch searchBar.selectedScopeButtonIndex {
            case 0:
                if searchText.isEmpty { return true }
                return animal.name.lowercased().contains(searchText.lowercased())
            case 1:
                if searchText.isEmpty { return animal.category == .dog }
                return animal.name.lowercased().contains(searchText.lowercased()) &&
                animal.category == .dog
            case 2:
                if searchText.isEmpty { return animal.category == .cat }
                return animal.name.lowercased().contains(searchText.lowercased()) &&
                animal.category == .cat
                // TODO: STILL WORK ON THE DIFFERENT CATEGORIES & TRULY UNDERSTANDING THIS SYSTEM.
//            case 3: if searchText.isEmpty { return animal.category == .bear }
////                return animal.name.lowercased().contains(searchText.lower)
            default:
                return false
            }
        })
        table.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        switch selectedScope {
        case 0:
            currentAnimalArray = animalArray
        case 1:
            currentAnimalArray = animalArray.filter({ animal -> Bool in
                animal.category == AnimalType.dog
            })
        case 2:
            currentAnimalArray = animalArray.filter({ animal -> Bool in
                animal.category == AnimalType.cat
            })
        case 3:
            currentAnimalArray = animalArray.filter({ animal -> Bool in
                animal.category == AnimalType.bear
            })
        default:
            break
        }
        table.reloadData()
    }
}

class Animal {
    let name: String
    let image: String
    let category: AnimalType
    
    init(name: String, category: AnimalType, image: String) {
        self.name = name
        self.category = category
        self.image = image
    }
}

enum AnimalType: String {
    case cat = "Apparel"
    case bird = "Footwear"
    case dog = "Restaurant"
    case bear = "Health & Beauty"
}


