//
//  MainTableViewController.swift
//  MultipleStarterProject
//
//  Created by Mac on 2017/6/19.
//  Copyright © 2017年 Mac. All rights reserved.
//

import UIKit

class MainTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet weak var DishesTableView: UITableView!
    var uid = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        DishesTableView.delegate = self
        DishesTableView.dataSource = self
        


        let rightButtonItem = UIBarButtonItem.init(
            title: "新增",
            style: .done,
            target: self,
            action: #selector(done)
        )
        self.navigationItem.rightBarButtonItem = rightButtonItem
        
        fetchMealsList()


    
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func done(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let nextVC = storyboard.instantiateViewController(withIdentifier: "DishesViewControllerID") as! DishesViewController
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func fetchMealsList(){
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DishesTableViewCell
        
        
        return cell
    }
    

}
