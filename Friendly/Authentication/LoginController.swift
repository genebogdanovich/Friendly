//
//  LoginController.swift
//  Friendly
//
//  Created by Gene Bogdanovich on 29.12.20.
//

import UIKit
import Firebase
import SwiftUI

class LoginController: UIViewController {
    
    // MARK: - Views
    
    let emailTextField: UITextField = {
        let field = UITextField()
        field.placeholder = "Email"
        field.keyboardType = .emailAddress
        field.autocapitalizationType = .none
        field.borderStyle = .roundedRect
        field.font = UIFont.systemFont(ofSize: UIFont.labelFontSize)
        
        field.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        
        return field
    }()
    
    let passwordTextField: UITextField = {
        let field = UITextField()
        field.placeholder = "Password"
        field.isSecureTextEntry = true
        field.autocapitalizationType = .none
        field.borderStyle = .roundedRect
        field.font = UIFont.systemFont(ofSize: UIFont.labelFontSize)
        
        field.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        
        return field
    }()
    
    let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Log In", for: .normal)
        button.setTitleColor(UIColor(named: "ButtonTextColor"), for: .normal)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.systemFont(ofSize: UIFont.labelFontSize)
        button.layer.backgroundColor = UIColor(named: "InactiveButtonColor")?.cgColor
        
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        
        return button
    }()
    
    let dontHaveAccountButton: UIButton = {
        let button = UIButton()
        
        let attributedTitle = NSMutableAttributedString(string: "Don't have an account? ", attributes: [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),
        ])
        
        attributedTitle.append(NSMutableAttributedString(string: "Sign Up", attributes: [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14),
            NSAttributedString.Key.foregroundColor: UIColor(named: "LightBlueColor")!,
        ]))
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        
        button.addTarget(self, action: #selector(handleDontHaveAccount), for: .touchUpInside)
        
        return button
    }()
    
    // MARK: viewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        view.backgroundColor = .systemBackground
        navigationController?.isNavigationBarHidden = true
        configureLayout()
    }
    
    // MARK: - Handling user actions
    
    @objc fileprivate func handleDontHaveAccount() {
        let signupController = SignupController()
        navigationController?.pushViewController(signupController, animated: true)
    }
    
    @objc fileprivate func handleLogin() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        Firebase
            .Auth
            .auth()
            .signIn(
                withEmail: email,
                password: password,
                completion: { result, error in
                    
            if let error = error {
                print("Failed to sign in with email \(error).")
                self.showBasicAlert(withTitle: "Failed to log in", message: error.localizedDescription)
                
                return
            }
            print("Successfully logged in with user: \(result?.user.uid ?? "Unknown user").")
                    
            // FIXME: Reset data from the previous user here.
            self.dismiss(animated: true, completion: nil)
        })
    }
    
    @objc fileprivate func handleTextInputChange() {
        // FIXME: Do this with Combine.
        let formIsValid =
            emailTextField.text?.count ?? 0 > 0 &&
            isValidEmail(emailTextField.text ?? "") &&
            passwordTextField.text?.count ?? 0 > 0
        if formIsValid {
            loginButton.isEnabled = true
            loginButton.backgroundColor = UIColor(named: "ButtonColor")
        } else {
            loginButton.isEnabled = false
            loginButton.backgroundColor = UIColor(named: "InactiveButtonColor")
        }
    }
    
    // MARK: - Configure layout
    
    fileprivate func configureLayout() {
        let stackView = UIStackView(arrangedSubviews: [
            emailTextField,
            passwordTextField,
            loginButton
        ])
        
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        
        view.addSubview(stackView)
        
        stackView.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            right: view.rightAnchor,
            bottom: nil,
            left: view.leftAnchor,
            paddingTop: 40,
            paddingRight: 20,
            paddingBottom: 0,
            paddingLeft: 20,
            width: 0,
            height: 150
        )
        
        view.addSubview(dontHaveAccountButton)
        
        dontHaveAccountButton.anchor(
            top: nil,
            right: view.rightAnchor,
            bottom: view.bottomAnchor,
            left: view.leftAnchor,
            paddingTop: 0,
            paddingRight: 0,
            paddingBottom: 0,
            paddingLeft: 0,
            width: 0,
            height: 50
        )
    }
}
