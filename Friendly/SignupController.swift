//
//  SignupController.swift
//  Friendly
//
//  Created by Gene Bogdanovich on 28.12.20.
//

import UIKit
import Firebase

class SignupController: UIViewController {
    
    // MARK: - Views
    
    let emailTextField: UITextField = {
        let view = UITextField()
        view.placeholder = "Email"
        view.autocapitalizationType = .none
        view.backgroundColor = UIColor(white: 0, alpha: 0.03)
        view.borderStyle = .roundedRect
        view.font = UIFont.systemFont(ofSize: 14)
        view.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        
        return view
    }()
    
    let usernameTextField: UITextField = {
        let view = UITextField()
        view.placeholder = "Username"
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
    
    let signupButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign Up", for: .normal)
        button.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleSignup), for: .touchUpInside)
        
        return button
    }()
    
    let alreadyHaveAccountButton: UIButton = {
        let button = UIButton()
        
        let attributedTitle = NSMutableAttributedString(string: "Already have an account? ", attributes: [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),
            NSAttributedString.Key.foregroundColor: UIColor.lightGray,
        ])
        
        attributedTitle.append(NSMutableAttributedString(string: "Sign In", attributes: [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),
            NSAttributedString.Key.foregroundColor: UIColor.rgb(red: 17, green: 155, blue: 247),
        ]))
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        
        button.addTarget(self, action: #selector(handleAlreadyHaveAccount), for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureLayout()
        
    }
    
    // MARK: - Handling user actions
    
    @objc fileprivate func handleTextInputChange() {
        // FIXME: Do this with Combine.
        let formIsValid =
            emailTextField.text?.count ?? 0 > 0 &&
            isValidEmail(emailTextField.text ?? "") &&
            usernameTextField.text?.count ?? 0 > 0 &&
            passwordTextField.text?.count ?? 0 > 0
        
        if formIsValid {
            signupButton.isEnabled = true
            signupButton.backgroundColor = UIColor.rgb(red: 17, green: 155, blue: 247)
        } else {
            signupButton.isEnabled = false
            signupButton.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        }
        
    }
    
    @objc fileprivate func handleSignup() {
        // FIXME: Refactor this out.
        guard let email = emailTextField.text, email.count > 0, isValidEmail(email) else { return }
        guard let username = usernameTextField.text, username.count > 0 else { return }
        guard let password = passwordTextField.text, password.count > 0 else { return }
        
        Auth.auth().createUser(withEmail: email, password: password, completion: { result, error in
            if let error = error {
                print("Failed to create user with error: \(error)")
                return
            }
            print("Successfully created user.")
            
        })
    }
    
    @objc fileprivate func handleAlreadyHaveAccount() {
        
    }
    
    
    // MARK: - Configure layout
    
    fileprivate func configureLayout() {
        // Input fields
        let stackView = UIStackView(arrangedSubviews: [
            emailTextField,
            usernameTextField,
            passwordTextField,
            signupButton,
        ])
        
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 10
        
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
            height: 200
        )
        
        // Footer
        view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.anchor(
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


// Taken from https://stackoverflow.com/questions/25471114/how-to-validate-an-e-mail-address-in-swift
func isValidEmail(_ email: String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    
    let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailPred.evaluate(with: email)
}
