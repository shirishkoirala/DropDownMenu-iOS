//
//  ViewController.swift
//  DropDownMenu
//
//  Created by Shirish Koirala on 3/10/2024.
//

import UIKit

class ViewController: UIViewController {
    private let dataSource = ["Apple", "Mango", "Orange", "Banana", "Kiwi", "Watermelon"]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(dropDown)
        NSLayoutConstraint.activate([
            dropDown.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            dropDown.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 100),
            dropDown.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -100),
            dropDown.heightAnchor.constraint(equalToConstant: 42)
        ])
    }
    
    let dropDown: DropDownMenu = {
        let dropDown = DropDownMenu()
        dropDown.text = "Hello"
        dropDown.translatesAutoresizingMaskIntoConstraints = false
        return dropDown
    }()
}

