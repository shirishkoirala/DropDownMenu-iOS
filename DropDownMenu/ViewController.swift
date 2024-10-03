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
            dropDown.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 150),
            dropDown.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -150),
            dropDown.heightAnchor.constraint(equalToConstant: 42)
        ])
        
        dropDown.optionArray = dataSource
        
        view.addSubview(textVew)
        NSLayoutConstraint.activate([
            textVew.topAnchor.constraint(equalTo: dropDown.bottomAnchor, constant: 20),
            textVew.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 100),
            textVew.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -100),
            textVew.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    let dropDown: DropDownMenu = {
        let dropDown = DropDownMenu()
        dropDown.text = "Hello"
        dropDown.translatesAutoresizingMaskIntoConstraints = false
        return dropDown
    }()
    
    let textVew: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.text = "Hello World"
        textView.textColor = .red
        return textView
    }()
}

