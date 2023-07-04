//
//  PostViewController.swift
//  Navigation
//
//  Created by Башмаков Сергей on 02.07.2023.
//

import UIKit

class PostViewController: UIViewController {
    
    var titlePost: String = "Hello"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .lightGray
        self.navigationItem.title = titlePost
       
    }
    
    
}
