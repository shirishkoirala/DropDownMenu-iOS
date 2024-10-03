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
        
        let button = UIButton(primaryAction: nil)

        let actionClosure = { (action: UIAction) in
            print(action.title)
        }

        var menuChildren: [UIMenuElement] = []
        for fruit in dataSource {
            menuChildren.append(UIAction(title: fruit, handler: actionClosure))
        }
        
        button.menu = UIMenu(options: .displayInline, children: menuChildren)
        
        button.showsMenuAsPrimaryAction = true
        button.changesSelectionAsPrimaryAction = true
        
        button.frame = CGRect(x: 150, y: 200, width: 100, height: 40)
        self.view.addSubview(button)
    }


}

