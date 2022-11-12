// BaseUIViewController.swift 
// HUtillities 
//
// Created by Khouv Tannhuot on 10/11/22. 
// Copyright (c) 2022 Khouv Tannhuot. All rights reserved. 
//

import UIKit

open class BaseUIViewController: UIViewController {
    //MARK: - Properties
    public var tableView = UITableView()
    public var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    private let progressIndicator = ProgressIndicator()
    private let activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    
    private let refreshControl = UIRefreshControl()
    
    private lazy var backButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.addTarget(self, action: #selector(popView), for: .touchUpInside)
        btn.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        return btn
    }()
    
    private lazy var closeButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        btn.setImage(UIImage(systemName: "xmark"), for: .normal)
        return btn
    }()
    
    private lazy var rightButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.addTarget(self, action: #selector(handleRightBarButtonClick), for: .touchUpInside)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        return btn
    }()
    
    //MARK: - Life Cycle
    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        refreshControl.addTarget(self, action: #selector(handlePullRefresh), for: .valueChanged)
        showBackButton()
    }
}

//MARK: - Handlers
extension BaseUIViewController {
    @objc public func handleRightBarButtonClick() {}
    @objc public func handlePullRefresh(_ refreshControl: UIRefreshControl) {}
}

//MARK: Function
extension BaseUIViewController {
    // Handle Dismiss Keyboard
    public func handleDismissKeyboard() {
        let tab = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tab)
    }
    
    // Show Close Button
    public func showCloseButton() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: closeButton)
    }
    
    // Hide Left Bar Button
    public func hideLeftBarButton() {
        navigationItem.leftBarButtonItem = nil
    }
    
    // Show Right Bar Button
    public func showRightBarButton(title: String? = nil,
                            imageName: String? = nil,
                            isSystemImage: Bool = false) {
        if let title = title {
            rightButton.setTitle(title, for: .normal)
        }else{
            if isSystemImage {
                rightButton.setImage(UIImage(systemName: imageName!), for: .normal)
            } else {
                rightButton.setImage(UIImage(named: imageName!), for: .normal)
            }
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)
    }
    
    // Disable Right Bar Button
    public func disableRightBarButton(_ disable: Bool) {
        navigationItem.rightBarButtonItem?.isEnabled = !disable
    }
    
    // Add Table View
    public func addTableView(isGroupStyle: Bool = false) {
        if isGroupStyle {
            tableView = UITableView(frame: .zero, style: .grouped)
        }
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.refreshControl = refreshControl
        tableView.backgroundColor = .systemBackground
        view.addSubview(tableView)
        tableView.fillSuperview()
    }
    
    // Add Collection View
    public func addCollectionView() {
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.refreshControl = refreshControl
        collectionView.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        collectionView.fillSuperview()
    }
    
    // Show Dialog Two Buttons
    public func showDialogTwoButtons(title: String,
                              message: String,
                              okButtonTitle: String = "OK",
                              cancelButtonTitle: String = "Cancel",
                              okHandler: ((_: UIAlertAction)->Void)?,
                              cancelHandler: ((_: UIAlertAction) -> Void)?){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: okButtonTitle, style: .default, handler: okHandler))
        alert.addAction(UIAlertAction(title: cancelButtonTitle, style: .cancel, handler: cancelHandler))
        present(alert, animated: true, completion: nil)
    }
    
    // Show Dialog One Button
    public func showDialogOneButton(title: String,
                             message: String,
                             okButtonTitle: String = "OK",
                             okHandler: ((_: UIAlertAction)->Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: okButtonTitle, style: .default, handler: okHandler))
        present(alert, animated: true, completion: nil)
    }
    
    // Show Progress Indicator
    public func showProgressIndicator(title: String){
        view.isUserInteractionEnabled = false
        progressIndicator.text = title
        progressIndicator.backgroundColor = UIColor.gray
        view.addSubview(progressIndicator)
    }

    // Hide progress Indicator
    public func hideProgressIndicator() {
        view.isUserInteractionEnabled = true
        progressIndicator.removeFromSuperview()
    }
    
    // Show Loading
    public func showLoading() {
        view.addSubview(activityIndicator)
        activityIndicator.center(inView: view)
        activityIndicator.setDimensions(height: 60, width: 60)
        activityIndicator.color = .white
        activityIndicator.layer.cornerRadius = 10
        activityIndicator.backgroundColor = .systemGray
        activityIndicator.startAnimating()
        
    }
    
    // Hide Loading
    public func hideLoading() {
        activityIndicator.removeFromSuperview()
    }
}

// MARK: - Private Function
extension BaseUIViewController {
    // Pop View
    @objc private func popView() {
        navigationController?.popViewController(animated: true)
    }
    
    // Dismiss View
    @objc private func dismissView() {
        dismiss(animated: true, completion: nil)
    }
    
    // Show Back Button
    private func showBackButton() {
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    // Dismiss Keyboard
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - Progress Indicator
private class ProgressIndicator: UIVisualEffectView {
    
    var text: String? {
        didSet {
            label.text = text
            label.textColor = .label
        }
    }
    
    let activityIndictor: UIActivityIndicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    let label: UILabel = UILabel()
    let blurEffect = UIBlurEffect(style: .systemMaterial)
    let vibrancyView: UIVisualEffectView
    
    init() {
        self.vibrancyView = UIVisualEffectView(effect: UIVibrancyEffect(blurEffect: blurEffect))
        super.init(effect: blurEffect)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.text = ""
        self.vibrancyView = UIVisualEffectView(effect: UIVibrancyEffect(blurEffect: blurEffect))
        super.init(coder: aDecoder)
        self.setup()
    }
    
    func setup() {
        contentView.addSubview(vibrancyView)
        activityIndictor.color = .label
        contentView.addSubview(activityIndictor)
        contentView.addSubview(label)
        activityIndictor.startAnimating()
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        if let superview = self.superview {
            
            let width = superview.frame.size.width / 1.8
            let height: CGFloat = 70.0
            self.frame = CGRect(x: superview.frame.size.width / 2 - width / 2,
                                y: superview.frame.height / 2 - height / 2,
                                width: width,
                                height: height)
            vibrancyView.frame = self.bounds
            
            let activityIndicatorSize: CGFloat = 40
            activityIndictor.frame = CGRect(x: 15,
                                            y: height / 2 - activityIndicatorSize / 2,
                                            width: activityIndicatorSize,
                                            height: activityIndicatorSize)
            
            layer.cornerRadius = 8.0
            layer.masksToBounds = true
            label.text = text
            label.textAlignment = NSTextAlignment.center
            label.frame = CGRect(x: activityIndicatorSize + 5,
                                 y: 0,
                                 width: width - activityIndicatorSize - 15,
                                 height: height)
            label.font = UIFont.boldSystemFont(ofSize: 17)
        }
    }
}
