//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Sandra Q on 5/21/20.
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Notice that this code works for both Scissors and Paper
        let controller = segue.destination as! UINavigationController
        controller.`self`()
    }
    
    @IBAction func loginTapped(_ sender: UIButton) {
        setLoggingIn(true)
        DispatchQueue.main.async {
            OTMClient.login(username: self.emailTextField.text ?? "", password: self.passwordTextField.text ?? "", completion: self.handleLoginResponse(success:error:))
        }
    }
    
    @IBAction func signUpViaWebsiteTapped(_ sender: Any) {
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
            
            // self.activityIndicator.hidesWhenStopped = true
            //self.loginViaWebsiteButton.isEnabled = !loggingIn
        }
    }
    
    func showLoginFailure(message: String) {
        let alertVC = UIAlertController(title: "Login Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        show(alertVC, sender: nil)
    }
    
    func handleLoginResponse(success: Bool, error: Error?) {
        if success {
            DispatchQueue.main.async {
              //  self.performSegue(withIdentifier: "completeLogin", sender: nil)
                
                self.performSegue(withIdentifier: "completeLogin", sender: nil)
             
//                    // Get the storyboard and ResultViewController
//                    let storyboard = UIStoryboard (name: "Main", bundle: nil)
//                    let resultVC = storyboard.instantiateViewController(withIdentifier: "MapViewController")as! MapViewController
                    
                    // Communicate the match
                   // self.navigationController?.pushViewController(resultVC, animated: true)
               // OTMClient.getPublicUserData(completion:self.handleSessionResponse(success:error:))

                
            }
        }
        else {
            setLoggingIn(false)
            DispatchQueue.main.async {
                self.showLoginFailure(message: error?.localizedDescription ?? "")
            }
        }
    }
    
    func handleSessionResponse(success: Bool, error: Error?) {
        if success {
         //   setLoggingIn(false)
            DispatchQueue.main.async {
                
            }
        } else {
            DispatchQueue.main.async {
                self.showLoginFailure(message: error?.localizedDescription ?? "")
            }
        }
    }
}

// MARK: - Navigation

//// In a storyboard-based application, you will often want to do a little preparation before navigation
//override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//    // Get the new view controller using segue.destination.
//    // Pass the selected object to the new view controller.
//}
//*/
