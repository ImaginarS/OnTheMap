//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Sandra Q on 5/18/20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore

class LoginViewController: UIViewController, Storyboarded, LoginButtonDelegate {
    
    var fbLoginButton = FBLoginButton()
    weak var coordinator: MainCoordinator?
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        fbLoginButton.delegate = self
        addFacebookLoginButton()
        setLoggingIn(false)
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
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        let login = LoginManager()
        login.logOut()
    }
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        if let token = AccessToken.current,
            !token.isExpired {
            coordinator?.viewStudentsLocations()
        } else {
            fbLoginButton.permissions = [ "email"]
            coordinator?.getFacebookData()
        }
        
    }
    
    func addFacebookLoginButton() {
        self.fbLoginButton.frame = CGRect(x: self.view.center.x - 160 , y: 560, width: 325, height: 45)
        self.view.addSubview(self.fbLoginButton)
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
        self.present(alertVC, animated: true, completion: nil)
        
    }
    
    func handleLoginResponse(success: Bool, error: Error?) {
        if success {
            setLoggingIn(false)
            self.coordinator?.viewStudentsLocations()
        }
        else {
            DispatchQueue.main.async {
                self.setLoggingIn(false)
                self.showLoginFailure(message: error?.localizedDescription ?? "")
            }
        }
    }
}

