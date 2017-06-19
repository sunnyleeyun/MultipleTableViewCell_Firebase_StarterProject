//
//  InitialViewController.swift
//  MultipleStarterProject
//
//  Created by Mac on 2017/6/19.
//  Copyright © 2017年 Mac. All rights reserved.
//

import UIKit

class InitialViewController: UIViewController {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    var uid = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func logIn(_ sender: Any) {
        
        if self.email.text != "" || self.password.text != ""{
        }
        
    }

    @IBAction func signUp(_ sender: Any) {
        
        if self.email.text != "" || self.password.text != ""{

        }
        
    }
    
    func doneLogIn(){
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let nextVC = storyboard.instantiateViewController(withIdentifier: "MainNavigationID") as! UINavigationController
        self.present(nextVC,animated:true,completion:nil)
        
    }
    
    func doneSignUp(){
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let nextVC = storyboard.instantiateViewController(withIdentifier: "SignUpViewControllerID")as! SignUpViewController
        self.present(nextVC,animated:true,completion:nil)
        
        
    }
    
    
    

}
