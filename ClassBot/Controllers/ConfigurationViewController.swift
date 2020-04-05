//
//  ConfigurationViewController.swift
//  ClassBot
//
//  Created by Nathan FALLET on 05/04/2020.
//  Copyright © 2020 Nathan FALLET. All rights reserved.
//

import UIKit

class ConfigurationViewController: UIViewController, UITextFieldDelegate {
    
    var completionHandler: (String) -> ()
    let scrollView = UIScrollView()
    let contentView = UIView()
    var hostLabel = UILabel()
    var hostField = UITextField()
    var submitButton = UIButton()
    var instructionsButton = UIButton()
    var bottomConstraint: NSLayoutConstraint!
    var checking = false
    
    init(completionHandler: @escaping (String) -> ())  {
        self.completionHandler = completionHandler
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "configuration".localized()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "cancel".localized(), style: .plain, target: self, action: #selector(close(_:)))

        view.backgroundColor = .background
        
        view.addSubview(scrollView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        bottomConstraint = scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        bottomConstraint.isActive = true
        
        scrollView.addSubview(contentView)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        contentView.addSubview(hostLabel)
        contentView.addSubview(hostField)
        contentView.addSubview(submitButton)
        contentView.addSubview(instructionsButton)
        
        hostLabel.translatesAutoresizingMaskIntoConstraints = false
        hostLabel.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor, constant: 30).isActive = true
        hostLabel.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor, constant: 15).isActive = true
        hostLabel.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor, constant: -15).isActive = true
        hostLabel.font = .boldSystemFont(ofSize: 17)
        hostLabel.textAlignment = .center
        hostLabel.text = "hostLabel".localized()
        hostLabel.numberOfLines = 0
        
        hostField.translatesAutoresizingMaskIntoConstraints = false
        hostField.topAnchor.constraint(equalTo: hostLabel.bottomAnchor, constant: 15).isActive = true
        hostField.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor, constant: 15).isActive = true
        hostField.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor, constant: -15).isActive = true
        hostField.placeholder = "hostField".localized()
        hostField.textAlignment = .center
        
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        submitButton.topAnchor.constraint(equalTo: hostField.bottomAnchor, constant: 30).isActive = true
        submitButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        submitButton.widthAnchor.constraint(equalToConstant: 300).isActive = true
        submitButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        submitButton.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
        submitButton.setTitle("submitButton".localized(), for: .normal)
        submitButton.setTitle("verification".localized(), for: .disabled)
        submitButton.setTitleColor(.white, for: .normal)
        submitButton.backgroundColor = .systemBlue
        submitButton.layer.cornerRadius = 10
        submitButton.clipsToBounds = true
        
        instructionsButton.translatesAutoresizingMaskIntoConstraints = false
        instructionsButton.topAnchor.constraint(equalTo: submitButton.bottomAnchor, constant: 16).isActive = true
        instructionsButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        instructionsButton.bottomAnchor.constraint(lessThanOrEqualTo: contentView.layoutMarginsGuide.bottomAnchor).isActive = true
        instructionsButton.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
        instructionsButton.setTitle("instructionsButton".localized(), for: .normal)
        instructionsButton.setTitleColor(.systemBlue, for: .normal)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardChanged(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardChanged(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func close(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func buttonClicked(_ sender: UIButton) {
        if sender == submitButton {
            // Get host
            if !checking, let host = hostField.text, !host.isEmpty {
                // Check
                checking = true
                submitButton.isEnabled = false
                
                // Query API
                APIRequest("GET", host: host, path: "/api/classbot").execute(APIVerification.self) { data, status in
                    // Check data and bool
                    if let data = data, data.classbot == true {
                        // Validate and dismiss
                        self.completionHandler(host)
                        self.dismiss(animated: true, completion: nil)
                    } else {
                        // Host is not correct
                        self.checking = false
                        self.submitButton.isEnabled = true
                        
                        // Show an alert
                        let alert = UIAlertController(title: "error_host_title".localized(), message: "error_host_description".localized(), preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "ok".localized(), style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
        } else if sender == instructionsButton, let url = URL(string: "https://github.com/GroupeMINASTE/ClassBot/blob/master/README.md") {
            UIApplication.shared.open(url)
        }
    }
    
    @objc func keyboardChanged(_ sender: NSNotification) {
        if let userInfo = sender.userInfo {
            // Adjust frame to keyboard
            let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
            let isKeyboardShowing = sender.name == UIResponder.keyboardWillShowNotification
            bottomConstraint.constant = isKeyboardShowing ? -((keyboardFrame?.height ?? 0)) : 0
            
            // And animate the transition
            UIView.animate(withDuration: 0, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return false
    }

}
