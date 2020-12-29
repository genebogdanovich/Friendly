//
//  LoginController.swift
//  Friendly
//
//  Created by Gene Bogdanovich on 29.12.20.
//

import UIKit
import Firebase

class LoginController: UIViewController {
    
    // MARK: - Views
    
    let emailTextField: UITextField = {
        let view = UITextField()
        view.placeholder = "Email"
        view.keyboardType = .emailAddress
        view.autocapitalizationType = .none
        view.backgroundColor = UIColor(white: 0, alpha: 0.03)
        view.borderStyle = .roundedRect
        view.font = UIFont.systemFont(ofSize: 14)
        view.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        
        return view
    }()
    
    let passwordTextField: UITextField = {
        let field = UITextField()
        field.placeholder = "Password"
        field.isSecureTextEntry = true
        field.autocapitalizationType = .none
        field.backgroundColor = UIColor(white: 0, alpha: 0.03)
        field.borderStyle = .roundedRect
        field.font = UIFont.systemFont(ofSize: 14)
        field.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        
        return field
    }()
    
    let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Log In", for: .normal)
        button.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        
        return button
    }()
    
    let dontHaveAccountButton: UIButton = {
        let button = UIButton()
        
        let attributedTitle = NSMutableAttributedString(string: "Don't have an account? ", attributes: [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),
            NSAttributedString.Key.foregroundColor: UIColor.lightGray,
        ])
        
        attributedTitle.append(NSMutableAttributedString(string: "Sign Up", attributes: [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),
            NSAttributedString.Key.foregroundColor: UIColor.rgb(red: 17, green: 155, blue: 247),
        ]))
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        
        button.addTarget(self, action: #selector(handleDontHaveAccount), for: .touchUpInside)
        
        return button
    }()
    
    // MARK: - Handling user actions
    
    @objc fileprivate func handleDontHaveAccount() {
        print("handleDontHaveAccount")
        let signupController = SignupController()
        navigationController?.pushViewController(signupController, animated: true)
    }
    
    @objc fileprivate func handleLogin() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        Firebase.Auth.auth().signIn(withEmail: email, password: password, completion: { result, error in
            if let error = error {
                print("Failed to sign in with email \(error)")
            }
            print("Successfully logged in with user: \(result?.user.uid ?? "Unknown")")
            
            let keyWindow = UIApplication.shared.connectedScenes
                .filter { $0.activationState == .foregroundActive }
                .map { $0 as? UIWindowScene }
                .compactMap { $0 }
                .first?.windows
                .filter { $0.isKeyWindow }.first
            
            // FIXME: This will cause `bad state` that needs to be reset.
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
            loginButton.backgroundColor = UIColor.rgb(red: 17, green: 155, blue: 247)
        } else {
            loginButton.isEnabled = false
            loginButton.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        }
        
    }
    
    // MARK: viewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.isNavigationBarHidden = true
        configureLayout()

        
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
            top: view.topAnchor,
            right: view.rightAnchor,
            bottom: nil,
            left: view.leftAnchor,
            paddingTop: 40,
            paddingRight: 40,
            paddingBottom: 0,
            paddingLeft: 40,
            width: 0,
            height: 140
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
