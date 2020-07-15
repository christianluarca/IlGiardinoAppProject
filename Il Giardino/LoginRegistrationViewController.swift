//
//  LoginRegistrationViewController.swift
//  Il Giardino
//
//  Created by Christian Luarca on 4/15/19.
//  Copyright © 2019 Surilis Labs. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import CoreData

class LoginRegistrationViewController: UIViewController {
    
    @IBOutlet weak var signInSelector: UISegmentedControl!
    @IBOutlet weak var signInLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    var container: NSPersistentContainer?
    
    var isSignIn : Bool = true
    
    let defaults = UserDefaults.standard
    
    let ref = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if defaults.bool(forKey: "signedIn") {
            setSignOutView()
        }
        else {
            setSignInView()
        }
    }
    
    @IBAction func signInButtonTapped(_ sender: UIButton) {
        
        if defaults.bool(forKey: "signedIn") {
            defaults.set(false, forKey: "signedIn")
            setSignInView()
        }
        else {
            if let email = emailTextField.text, let pass = passwordTextfield.text {
                //Check if it's sign in or register
                if isSignIn {
                    //Sign in the user with Firebase...
                    Auth.auth().signIn(withEmail: email, password: pass, completion: { (user, error ) in
                        
                        //...if the user isn't nil.
                        if let u = user {
                            print("\(email) signed in")
                            self.defaults.set(true, forKey: "signedIn")
                            self.navigationController?.popToRootViewController(animated: false)
                        }
                        else {
                            //Error, check error
                            print("\(email) could not be signed in")
                            print("Error:\(error)")
                            //The password is invalid or the user does not have a password
                        }
                    })
                }
                else {
                    //Register the user with Firebase...
                    Auth.auth().createUser(withEmail: email, password: pass, completion: { (user, error) in
                        
                        //...if the user is valid...
                        if let u = user {
                            let uid = u.user.uid
                            let userRef = self.ref.child("User").child(uid)
                            userRef.child("email").setValue(email)
                            userRef.child("rewardPoints").setValue(0)
                            print("\(email) registered")
                            
                            //Save locally
                            self.defaults.set(true, forKey: "signedIn")
                            self.navigationController?.popToRootViewController(animated: false)
                            
                        }
                        else {
                            print("\(email) could not be registered")
//                            print("Error:\(error)")
                            //regex
                            //The password must be 6 characters long or more
                        }
                    })
                }
            }
        }
    }
    
////    You can create a item in the database simply by referencing what it should be, even if it doesn't exit yet. Furthermore, you may set values for its keys; this creates the object, its keys, and the values of those keys simultaneously
//
//        let newUserRef = ref.child("User").child("user0")
//        newUserRef.child("name").setValue("Nikko")
//        newUserRef.child("age").setValue(25)
    
    @IBAction func signInSelectorChanged(_ sender: Any) {
        // Flip the boolean
        isSignIn = !isSignIn
        
        // Check the bool and set the button and labels
        if isSignIn {
            signInLabel.text = "Sign In"
            signInButton.setTitle("Sign In", for: .normal)
        }
        else {
            signInLabel.text = "Register"
            signInButton.setTitle("Register", for: .normal)
        }
    }
    
    func setSignInView() {
        signInSelector.isHidden = false
        signInLabel.isHidden = false
        signInLabel.text = "Sign in"
        emailTextField.isHidden = false
        passwordTextfield.isHidden = false
        signInButton.setTitle("Sign in", for: .normal)
    }
    
    func setSignOutView() {
        signInSelector.isHidden = true
        signInLabel.isHidden = true
        emailTextField.isHidden = true
        passwordTextfield.isHidden = true
        signInButton.setTitle("Sign out", for: .normal)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Dismiss the keyboard when the view is tapped on
        emailTextField.resignFirstResponder()
        passwordTextfield.resignFirstResponder()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nextVC = segue.destination as? HomeViewController {
            nextVC.container = container
        }
    }
    
}
