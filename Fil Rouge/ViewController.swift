//
//  ViewController.swift
//  Fil Rouge
//
//  Created by Duc Luu on 31/07/2023.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var bubbleView: UIView!
    @IBOutlet var bottomConstrain: NSLayoutConstraint!
    @IBOutlet var passText: UITextField!
    @IBOutlet var emailText: UITextField!
    @IBOutlet var container: UIView!
    @IBOutlet var connectBtn: UIButton!
    @IBOutlet var messageText: UILabel!
    @IBOutlet var emailStackV: UIStackView!
    @IBOutlet var wrongEmail: UIImageView!
    @IBOutlet var wrongPass: UIImageView!
    @IBOutlet var passStackV: UIStackView!
    @IBOutlet var iconEmail: UIImageView!
    @IBOutlet var iconPass: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Login"
        //Gestion du clavier
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        //Fin gestion du clavier
        container.layer.cornerRadius = 30
        container.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        bubbleView.layer.cornerRadius = 15
        emailStackV.layer.cornerRadius = 20
        passStackV.layer.cornerRadius = 20
        wrongEmail.isHidden = true
        wrongPass.isHidden = true
        passText.isSecureTextEntry = true
        connectBtn.layer.cornerRadius = 25
        
        // Active l'action de la méthode textFieldDidChange quand je tape
        emailText.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        passText.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @IBAction func login() {
        
        // Récupérer les valeurs des champs texte
        guard let email = emailText.text, let password = passText.text else {
            return
        }
        // Vérifier si l'email est valide
        if !isValidEmail(email: email) {
            messageText.text = "Pas facile de taper avec des gros doigts..."
            return
        }
        // Vérifier si le mot de passe est valide
        if !isValidPassword(password: password) {
            messageText.text = "Pas facile de taper avec des gros doigts..."
            return
        }
        // Si toutes les conditions sont respectées, envoie vers le controlleur suivant
        let homeViewController = storyboard?.instantiateViewController(identifier: "MyTabBarController")
        homeViewController?.modalPresentationStyle = .fullScreen
        present(homeViewController!, animated: true)
    }
    
    // Regex email
    func isValidEmail(email: String) -> Bool {
        let emailRegex = "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    // Regex password
    func isValidPassword(password: String) -> Bool {
        let passwordRegex = "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,}$"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordPredicate.evaluate(with: password)
    }
    
    //Gestion du clavier
    // Cette méthode est appelée lorsque le champ de saisie devient le premier répondant
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Affiche le clavier
        textField.becomeFirstResponder()
    }
    // Cette méthode est appelée lorsque le champ de saisie va cesser d'être le premier répondant
    func textFieldDidEndEditing(_ textField: UITextField) {
        // Masque le clavier
        textField.resignFirstResponder()
    }
    // Cette méthode est appelée lorsque l'utilisateur appuie sur le bouton "retour" du clavier
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Masque le clavier lorsque l'utilisateur appuie sur "retour"
        textField.resignFirstResponder()
        return true
    }
    // Cette méthode est appelée lorsque l'utilisateur appuie en dehors du champ de saisie
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Masque le clavier lorsque l'utilisateur appuie en dehors du champ de saisie
        self.view.endEditing(true)
    }
    //Faire monter la vue au dessus du clavier quand il s'affiche
    @objc func keyboardWillShow(_ notification: Notification) {
        // Récupérer la taille du clavier
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            // Déplacer la vue vers le haut de la hauteur du clavier
            let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
            UIView.animate(withDuration: duration) {
                self.bottomConstrain.constant = keyboardSize.height
                self.view.layoutIfNeeded()
            }
        }
    }
    
    //Faire revenir la vue à la contrainte 0 quand le clavier est masqué
    @objc func keyboardWillHide(_ notification: Notification) {
        // Rétablir la position originale de la vue
        let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        UIView.animate(withDuration: duration) {
            self.bottomConstrain.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    //retirer les notifications lorsque la vue de contrôleur de vue est supprimée (pour éviter les fuites de mémoire)
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //Fin gestion du clavier
    //Afficher dans message.text ce qu'on tape
    @objc func textFieldDidChange(_ textField: UITextField) {
        // Mettre à jour le contenu de message.text avec le texte tapé dans les champs de saisie
        messageText.text = "Tap tap tap tap tap tap..."
        // Vérifier si le texte du champ de saisie correspond au regex
        if textField == emailText {
            let isValidEmail = isValidEmail(email: textField.text ?? "")
            // Si c'est pas valide, le texte est rouge sinon vert
            textField.textColor = isValidEmail ? UIColor.systemMint : UIColor.systemRed
            // Si le champ est vide, l'image du check disparait
            wrongEmail.isHidden = textField.text?.isEmpty == true
            // Il y a un check vert si c'est valide sinon une croix rouge
            wrongEmail.image = isValidEmail ? UIImage(named: "ico_rose") : UIImage(named: "ico_cross_rose")
        } else if textField == passText {
            let isValidPassword = isValidPassword(password: textField.text ?? "")
            // Si c'est pas valide, le texte est rouge sinon vert
            textField.textColor = isValidPassword ? UIColor.systemMint : UIColor.systemRed
            // Si le champ est vide, l'image du check disparait
            wrongPass.isHidden = textField.text?.isEmpty == true
            // Il y a un check vert si c'est valide sinon une croix rouge
            wrongPass.image = isValidPassword ? UIImage(named: "ico_rose") : UIImage(named: "ico_cross_rose")
        }
        // Vérifier si les deux conditions sont respectées
        let isValidEmail = isValidEmail(email: emailText.text ?? "")
        let isValidPassword = isValidPassword(password: passText.text ?? "")
        if isValidEmail && isValidPassword {
            // Si les deux conditions sont respectées, envoyer un message spécifique à messageText
            messageText.text = "Waaaaaaa ! C'est tout vert !"
            // Mettre le dégradé de vert pour le fond du bouton
            connectBtn.backgroundColor = UIColor.greenGradient() // Remplacez UIColor.greenGradient() par la fonction qui génère le dégradé de vert
        } else {
            // Si les conditions ne sont pas respectées, mettre en gris le fond du bouton
            connectBtn.backgroundColor = UIColor.lightGray
            
        }
        if emailText.text?.isEmpty == true && passText.text?.isEmpty == true{
            messageText.text = " "
        }
        
    }
}
// Gestion du dégradé
extension UIColor {
    static func greenGradient() -> UIColor {
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.systemGreen.withAlphaComponent(0.3).cgColor, UIColor.systemMint.cgColor]
        gradientLayer.locations = [0, 1]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0)
        
        let size = CGSize(width: 170, height: 50) // Prend la taille du bouton
        gradientLayer.frame = CGRect(origin: .zero, size: size)
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return UIColor(patternImage: image!)
    }
}



