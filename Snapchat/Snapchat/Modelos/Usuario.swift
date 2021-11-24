//
//  usuario.swift
//  Snapchat
//
//  Created by Josue Herrera Rodrigues on 05/11/21.
//

import UIKit

class Usuario {
    
    var email: String
    var nome: String
    var uid: String
    
    init(email: String, nome: String, uid: String) {
        
        self.email = email
        self.nome = nome
        self.uid = uid
    }
}
