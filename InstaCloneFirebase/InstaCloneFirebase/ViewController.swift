//
//  ViewController.swift
//  InstaCloneFirebase
//
//  Created by midDeveloper on 21.08.2023.
//

import UIKit
import Firebase
import FirebaseAuth

class ViewController: UIViewController {

    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
    }

    @IBAction func signInCliked(_ sender: Any) {
        if emailText.text != "" && passwordText.text != ""{
            Auth.auth().signIn(withEmail: emailText.text!, password: passwordText.text!) { authData, err in
                if err != nil{
                    self.makeAlert(TitleText: "Error !", MessageText: err?.localizedDescription ?? "Error")
                }else{
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
        }else{
               makeAlert(TitleText: "Error !", MessageText: "Email or Password can't not be null !")
        }
        
    }
    
    @IBAction func signUpClicked(_ sender: Any) {
        if emailText.text != "" && passwordText.text != ""{
            Auth.auth().createUser(withEmail: emailText.text!,password: passwordText.text!) { authData, err in
                if err != nil{
                    self.makeAlert(TitleText: "Error !", MessageText: err?.localizedDescription ?? "Error")
                }else{
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                    
                }
            }
        }else{
           makeAlert(TitleText: "Error !", MessageText: "Email or Password can't not be null !")
        }
        
    }
    
    func makeAlert(TitleText:String,MessageText:String)  {
        let alert = UIAlertController(title: TitleText, message: MessageText, preferredStyle: UIAlertController.Style.actionSheet)
        let okBtn = UIAlertAction(title: "ok", style: UIAlertAction.Style.default)
        alert.addAction(okBtn)
        present(alert, animated: true)
    }
}

