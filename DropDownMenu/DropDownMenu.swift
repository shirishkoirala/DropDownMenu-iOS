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
    public var rowHeight: CGFloat = 56
    public var listHeight: CGFloat = 150
    public var optionArray = [String]() {
        didSet {
            dataArray = optionArray
        }
    }
    // MARK: - Private Variables
    fileprivate weak var parentController: UIViewController?
    fileprivate var pointToParent = CGPoint(x: 0, y: 0)
    fileprivate var tableheightX: CGFloat = 100
    fileprivate var dataArray = [String]()
    fileprivate var keyboardHeight: CGFloat = 0
    
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
        isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(touchAction))
        addGestureRecognizer(gesture)
        let gesture1 = UITapGestureRecognizer(target: self, action: #selector(touchAction))
        backgroundView.addGestureRecognizer(gesture1)
        
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
        isSelected.toggle()
        isSelected ? showList(): hideList()
    }
    
    public func hideList() {
        UIView.animate(withDuration: 0.2,
                       delay: 0.2,
                       options: .curveEaseInOut,
                       animations: { () -> Void in
            self.tableView.frame = CGRect(x: self.pointToParent.x,
                                      y: self.pointToParent.y + self.frame.height,
                                      width: self.frame.width,
                                      height: 0)
        },
                       completion: { (_) -> Void in
            self.tableView.removeFromSuperview()
            self.backgroundView.removeFromSuperview()
        })
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
    
    public func showList() {
        if parentController == nil {
            parentController = parentViewController
        }
        backgroundView.frame = parentController?.view.frame ?? backgroundView.frame
        pointToParent = getConvertedPoint(self, baseView: parentController?.view)
        parentController?.view.insertSubview(backgroundView, aboveSubview: self)
        
        if listHeight > rowHeight * CGFloat(dataArray.count) {
            tableheightX = rowHeight * CGFloat(dataArray.count)
        } else {
            tableheightX = listHeight
        }
        tableView = UITableView(frame: CGRect(x: pointToParent.x,
                                          y: pointToParent.y + frame.height,
                                          width: frame.width,
                                          height: frame.height))
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.alpha = 0
        tableView.separatorStyle = .none
        tableView.layer.cornerRadius = 8
        tableView.backgroundColor = .clear
        tableView.layer.masksToBounds = true
        tableView.layer.borderWidth = 1
        tableView.layer.borderColor = UIColor.lightGray.cgColor
        
        tableView.rowHeight = rowHeight
        
        parentController?.view.addSubview(tableView)
        isSelected = true
        let height = (parentController?.view.frame.height ?? 0) - (pointToParent.y + frame.height + 5)
        var y = pointToParent.y + frame.height + 5
        if height < (keyboardHeight + tableheightX) {
            y = pointToParent.y - tableheightX
        }
        UIView.animate(withDuration: 0.2,
                       delay: 0,
                       options: .curveEaseInOut,
                       animations: { () -> Void in
            
            self.tableView.frame = CGRect(x: self.pointToParent.x,
                                      y: y,
                                      width: self.frame.width,
                                      height: self.tableheightX)
            self.tableView.alpha = 1
            
        },
                       completion: { (_) -> Void in
            self.layoutIfNeeded()
            
        })
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
    
    private lazy var backgroundView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
}

extension DropDownMenu: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "DropDownCell"
        
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
        }
        
//        if indexPath.row != selectedIndex {
//            cell!.backgroundColor = rowBackgroundColor
//        } else {
//            cell?.backgroundColor = selectedRowColor
//        }
        
//        if imageArray.count > indexPath.row {
//            cell!.imageView!.image = UIImage(named: imageArray[indexPath.row])
//        }
        cell!.textLabel!.text = "\(dataArray[indexPath.row])"
        cell!.textLabel!.textColor = .red
        cell!.tintColor = .blue
        
        cell!.selectionStyle = .none
        cell?.textLabel?.font = font
        cell?.textLabel?.textAlignment = textAlignment
        cell?.textLabel?.numberOfLines = 0
        cell?.textLabel?.lineBreakMode = .byWordWrapping
        return cell!
    }
}

extension UIView {
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 1, height: 1)
        layer.shadowRadius = 2
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func viewBorder(borderColor: UIColor, borderWidth: CGFloat?) {
        layer.borderColor = borderColor.cgColor
        if let borderWidth_ = borderWidth {
            layer.borderWidth = borderWidth_
        } else {
            layer.borderWidth = 1.0
        }
    }
    
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}
