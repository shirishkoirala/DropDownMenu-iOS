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
    public var selectedIndex: Int?
    var selectedBackgroundColor = UIColor.gray
    
    // MARK: - Private Variables
    fileprivate weak var parentController: UIViewController?
    fileprivate var pointToParent = CGPoint(x: 0, y: 0)
    fileprivate var tableheightX: CGFloat = 100
    fileprivate var dataArray = [String]()
    fileprivate var keyboardHeight: CGFloat = 0
    
    private let padding = 20.0
    private var insets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    
    private var arrow: UIImageView?
    
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
        
        arrow = UIImageView(frame: CGRect(x: (center.x - arrowSize / 2) - padding, y: center.y - arrowSize / 2, width: arrowSize, height: arrowSize))
        arrow?.image = UIImage(systemName: "chevron.down")
        arrow?.contentMode = .scaleAspectFit
        arrowContainerView.addSubview(arrow!)
    }
    
    @objc public func touchAction() {
        isSelected.toggle()
        isSelected ? showList(): hideList()
    }
    
    public func hideList() {
        let rotation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.fromValue = NSNumber(value: Double.pi)
        rotation.toValue = NSNumber(value: 0)
        rotation.duration = 0.5
        rotation.repeatCount = 1
        rotation.fillMode = .forwards
        rotation.isRemovedOnCompletion = false
        arrow?.layer.add(rotation, forKey: "rotationAnimation")

        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseInOut, animations: { () -> Void in
            self.tableView.frame = CGRect(x: self.pointToParent.x, y: self.pointToParent.y + self.frame.height, width: self.frame.width, height: 0)
        }, completion: { (_) -> Void in
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
        
        tableView = UITableView(frame: CGRect(x: pointToParent.x, y: pointToParent.y + frame.height, width: frame.width, height: frame.height))
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.alpha = 0
        tableView.separatorStyle = .none
        tableView.layer.cornerRadius = 8
        tableView.backgroundColor = .white
        tableView.layer.masksToBounds = true
        tableView.layer.borderWidth = 1
        tableView.layer.borderColor = UIColor.lightGray.cgColor
        
        tableView.rowHeight = rowHeight
        
        parentController?.view.addSubview(tableView)
        let rotation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = NSNumber(value: Double.pi)
        rotation.duration = 0.5
        rotation.repeatCount = 1
        rotation.fillMode = .forwards
        rotation.isRemovedOnCompletion = false
        arrow?.layer.add(rotation, forKey: "rotationAnimation")
        isSelected = true
        let height = (parentController?.view.frame.height ?? 0) - (pointToParent.y + frame.height + 5)
        var y = pointToParent.y + frame.height + 5
        if height < (keyboardHeight + tableheightX) {
            y = pointToParent.y - tableheightX
        }
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: { () -> Void in
            self.tableView.frame = CGRect(x: self.pointToParent.x, y: y, width: self.frame.width, height: self.tableheightX)
            self.tableView.alpha = 1
        }, completion: { (_) -> Void in
            self.layoutIfNeeded()
            self.tableView.flashScrollIndicators()
            if let selectedIndex = self.selectedIndex {
                self.tableView.scrollToRow(at: IndexPath(row: selectedIndex, section: 0), at: .middle, animated: true)
            }
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
        tableView.showsVerticalScrollIndicator = true
        return tableView
    }()
    
    private lazy var backgroundView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
}

extension DropDownMenu: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "DropDownCell"
        
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
        }
        
        if indexPath.row != selectedIndex {
            cell!.backgroundColor = .white
        } else {
            cell?.backgroundColor = selectedBackgroundColor
        }
        
        cell!.textLabel!.text = "\(dataArray[indexPath.row])"
        cell!.textLabel!.textColor = .black
        
        cell!.selectionStyle = .none
        cell?.textLabel?.font = font
        cell?.textLabel?.textAlignment = textAlignment
        cell?.textLabel?.numberOfLines = 0
        cell?.textLabel?.lineBreakMode = .byWordWrapping
        return cell!
    }
}

extension DropDownMenu: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentIndex = (indexPath as NSIndexPath).row
        let selectedText = dataArray[currentIndex]
        selectedIndex = currentIndex
        tableView.cellForRow(at: indexPath)?.alpha = 0
        
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            tableView.cellForRow(at: indexPath)?.alpha = 1.0
            tableView.cellForRow(at: indexPath)?.backgroundColor = self.selectedBackgroundColor
            self.tableView.reloadData()
        }, completion: { (_) -> Void in
            self.text = "\(selectedText)"
            self.touchAction()
        })
    }
}

extension UIView {
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
