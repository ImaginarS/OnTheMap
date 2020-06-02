//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Sandra Q on 5/18/20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTextField.isSecureTextEntry = true
        passwordTextField.clearButtonMode = .whileEditing
        activityIndicator.hidesWhenStopped = true
    }
    
    @IBAction func loginTapped(_ sender: UIButton) {
        setLoggingIn(true)
        OTMClient.login(username: self.emailTextField.text ?? "", password: self.passwordTextField.text ?? "", completion: handleLoginResponse(success: error:))
    }
    
    @IBAction func signUpViaWebsiteTapped(_ sender: Any) {
        DispatchQueue.main.async {
            UIApplication.shared.open(OTMClient.Endpoints.webSignUp.url, options: [:], completionHandler: nil)
                }
    }
    
    func setLoggingIn(_ loggingIn: Bool) {
        DispatchQueue.main.async {
            if loggingIn {
                self.activityIndicator.startAnimating()
                
            } else {
                self.activityIndicator.stopAnimating()
                self.activityIndicator.hidesWhenStopped = true
            }
            self.emailTextField.isEnabled = !loggingIn
            self.passwordTextField.isEnabled = !loggingIn
            self.loginButton.isEnabled = !loggingIn
            
            self.activityIndicator.hidesWhenStopped = true
        }
    }
    
    func showLoginFailure(message: String) {
        setLoggingIn(false)
        let alertVC = UIAlertController(title: "Login failed. Check your credentials and try again.", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        show(alertVC, sender: nil)
    }
    
    func handleLoginResponse(success: Bool, error: Error?) {
        if success {
            setLoggingIn(false)
            DispatchQueue.main.async {
                let mapVC = self.storyboard?.instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
                self.present(mapVC, animated: true, completion: nil)
                OTMClient.getPublicUserData(completion: self.handleSessionResponse(success:error:))
            }
        }
        else {
            DispatchQueue.main.async {
                self.setLoggingIn(false)
                self.showLoginFailure(message: error?.localizedDescription ?? "")
            }
        }
    }
    
    //TODO: Handle Session response to get pin location on success
    func handleSessionResponse(success: Bool, error: Error?) {
        
    }
}
