//
//  LoginViewController.swift
//  DemoProject
//
//  Created by AryaOmnitalk MDA on 09/02/21.
//  Copyright © 2021 ProgrammingWithSwift. All rights reserved.
//

import UIKit
import CoreData

class LoginViewController: UIViewController {
    
    struct GlobalColorConstants {
        static let kColor_Blue:String = "#0075b8"
    }
    
    var result = NSArray()
    
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var userNameTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.layer.cornerRadius = 5.0
        loginButton.layer.borderColor = hexStringToUIColor(hex: GlobalColorConstants.kColor_Blue).cgColor
        loginButton.layer.borderWidth = 1.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    @IBAction func LoginAction(_ sender: Any) {
        if userNameTextField.text == "" || passwordTextField.text == ""
        {
            let alert = UIAlertController(title: "Information", message: "Please enter all the fields", preferredStyle: .alert)
            
            let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
            let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            
            alert.addAction(ok)
            alert.addAction(cancel)
            
            self.present(alert, animated: true, completion: nil)
            
        }else
        {
            
            self.CheckForUserNameAndPasswordMatch(username : userNameTextField.text! as String, password : passwordTextField.text! as String)
            
        }
    }
    
    func CheckForUserNameAndPasswordMatch( username: String, password : String)
    {
        let app = UIApplication.shared.delegate as! AppDelegate
        
        let context = app.persistentContainer.viewContext
        
        let fetchrequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        
        let predicate = NSPredicate(format: "username = %@", username)
        
        fetchrequest.predicate = predicate
        do
        {
            result = try context.fetch(fetchrequest) as NSArray
            
            if result.count>0
            {
                let objectentity = result.firstObject as! User
                
                if objectentity.username == username && objectentity.password == password
                {
                    print("Login Succesfully")
                    UserDefaults.standard.set(true, forKey: "loginstatus")
                    performSegue(withIdentifier: "login", sender: self )
                }
                else
                {
                    
                    let alert = UIAlertController(title: "Information", message: "Wrong username or password !!!", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
                    alert.addAction(ok)
                    self.present(alert, animated: true, completion: nil)
                }
            }else{
                
                let alertController = UIAlertController(title: "Alert", message: "User not register!!! \n Are you sure want to register?", preferredStyle: .alert)
                
                let OKAction = UIAlertAction(title: "Yes", style: .default) { (action:UIAlertAction!) in
                    
                    let app = UIApplication.shared.delegate as! AppDelegate
                    
                    let context = app.persistentContainer.viewContext
                    
                    let new_user = NSEntityDescription.insertNewObject(forEntityName: "User", into: context)
                    
                    new_user.setValue(self.userNameTextField.text, forKey: "username")
                    new_user.setValue(self.passwordTextField.text, forKey: "password")
                    
                    do
                    {
                        try context.save()
                        
                        
                        let alert = UIAlertController(title: "Information", message: "Registered  Sucessfully", preferredStyle: .alert)
                        let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
                        alert.addAction(ok)
                        self.present(alert, animated: true, completion: nil)
                    }
                    catch
                    {
                        let Fetcherror = error as NSError
                        print("error", Fetcherror.localizedDescription)
                    }
                    
                }
                alertController.addAction(OKAction)
                
                let cancelAction = UIAlertAction(title: "No", style: .cancel) { (action:UIAlertAction!) in
                    print("No button tapped");
                }
                alertController.addAction(cancelAction)
                
                self.present(alertController, animated: true, completion:nil)
                
            }
        }
            
        catch
        {
            let fetch_error = error as NSError
            print("error", fetch_error.localizedDescription)
        }
        
    }
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
}
