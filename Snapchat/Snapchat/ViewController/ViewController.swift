//
//  ViewController.swift
//  Snapchat
//
//  Created by Josue Herrera Rodrigues on 21/10/21.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let autenticacao = Auth.auth()
        
        // Colocando um ouvinte para identificar se foi possivel recuperar o usuario
        autenticacao.addStateDidChangeListener { autenticacao, usuario in
            
            if usuario != nil {
                
                // Executando um timer de 0,1 segundo ate o proximo codigo
                Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { Timer in
                    self.performSegue(withIdentifier: "telaPrincipalSegue", sender: nil)
                }
            }
        }
    }
    
    //  Função para ocultar ou apresentar o Navigation Bar na tela (True = Oculta / False = Apresenta)
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
    }
}

