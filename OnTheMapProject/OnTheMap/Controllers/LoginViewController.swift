//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Sandra Q on 5/18/20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FacebookLogin

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var fbLoginButton = FBLoginButton()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        emailTextField.text = "sandyequel@yahoo.com"
        passwordTextField.text = "Testing12345"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addFacebookLoginButton()
    }
    
    @objc func buttonAction(_ sender: UIButton){
        setLoggingIn(true)
        faceBookLogin()
    }
    
    func addFacebookLoginButton() {
        fbLoginButton.frame = CGRect(x: view.center.x - 160 , y: 535, width: 325, height: 45)
        view.addSubview(fbLoginButton)
        fbLoginButton.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
    }
    
    func faceBookLogin() {
        let loginManager = LoginManager()
        
        loginManager.logIn(permissions: [.publicProfile], viewController: self){
            (result) in
            print(result)
            switch result {
                case .cancelled:
                    self.setLoggingIn(false)
                case .failed(let error):
                    print(error.localizedDescription)
                    self.setLoggingIn(false)
                case .success:
                    self.getFacebookData()
            }
            
        }
    }
    
    func getFacebookData() {
        if AccessToken.current != nil {
            let tokenString = String(describing: AccessToken.current?.tokenString)
            
            print(tokenString)
            
            GraphRequest(graphPath: "me", parameters: ["fields": "name"]).start { (connection, result, error) in
                if error == nil {
                    let dict = result as! [String: AnyObject] as NSDictionary
                    let name = dict.object(forKey: "name") as! String
                    
                    OTMClient.Auth.firstName = name
                } else {
                    print(error?.localizedDescription ?? error ?? "")
                }
            }
            setLoggingIn(false)
            DispatchQueue.main.async {
                let mapVC = self.storyboard?.instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
                self.present(mapVC, animated: true, completion: nil)
            }
        }
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
            }
        }
        else {
            DispatchQueue.main.async {
                self.setLoggingIn(false)
                self.showLoginFailure(message: error?.localizedDescription ?? "")
            }
        }
    }
}
