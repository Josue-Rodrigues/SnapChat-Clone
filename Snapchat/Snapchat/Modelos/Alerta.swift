//
//  Alerta.swift
//  Snapchat
//
//  Created by Josue Herrera Rodrigues on 02/11/21.
//

import UIKit

class Alerta {
    
    var titulo: String
    var mensagem: String
    var botao: String
    
    init(titulo: String, mensagem: String, botao: String) {
        
        self.titulo = titulo
        self.mensagem = mensagem
        self.botao = botao
    }
    
    func getAlerta () -> UIAlertController {
        
        let alerta = UIAlertController(title: titulo, message: mensagem, preferredStyle: .alert)
        
        let botao = UIAlertAction(title: botao, style: .cancel, handler: nil)
        
        alerta.addAction(botao)
        return alerta
        
    }
}
