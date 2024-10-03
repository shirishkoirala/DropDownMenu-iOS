//
//  DropDownMenu.swift
//  DropDownMenu
//
//  Created by Shirish Koirala on 3/10/2024.
//

import UIKit

class DropDownMenu: UITextField {
    // MARK: - Public Variables
    public var arrowSize: CGFloat = 15
    
    // MARK: - Private Variables
    fileprivate weak var parentController: UIViewController?
    
    private let padding = 20.0
    private var insets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    
    
    // MARK: - System Methods
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    public required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setupViews()
    }
    
    // MARK: - Custom Methods
    private func setupViews() {
        layer.cornerRadius = 8
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 1
        let gesture = UITapGestureRecognizer(target: self, action: #selector(touchAction))
        addGestureRecognizer(gesture)
        
        let size = frame.height
        let arrowView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: size, height: size))
        let arrowContainerView = UIView(frame: arrowView.frame)
        rightView = arrowView
        rightViewMode = .always
        
        rightView?.addSubview(arrowContainerView)
        
        let arrow = UIImageView(frame: CGRect(x: (center.x - arrowSize / 2) - padding, y: center.y - arrowSize / 2, width: arrowSize, height: arrowSize))
        arrow.image = UIImage(systemName: "chevron.down")
        arrow.contentMode = .scaleAspectFit
        arrowContainerView.addSubview(arrow)
    }
    
    @objc public func touchAction() {
        
    }

    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: insets)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: insets)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: insets)
    }
    
    private func getConvertedPoint(_ targetView: UIView, baseView: UIView?) -> CGPoint {
        var pnt = targetView.frame.origin
        if nil == targetView.superview {
            return pnt
        }
        var superView = targetView.superview
        while superView != baseView {
            pnt = superView!.convert(pnt, to: superView!.superview)
            if nil == superView!.superview {
                break
            } else {
                superView = superView!.superview
            }
        }
        return superView!.convert(pnt, to: baseView)
    }
    
    // MARK: - Views
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.alpha = 0
        tableView.separatorStyle = .none
        tableView.layer.cornerRadius = 8
        return tableView
    }()
}

extension DropDownMenu: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
