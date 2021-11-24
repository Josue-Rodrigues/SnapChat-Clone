//
//  DetalhesSnapViewController.swift
//  Snapchat
//
//  Created by Josue Herrera Rodrigues on 18/11/21.
//

import UIKit
import SDWebImage
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class DetalhesSnapViewController: UIViewController {
    
    @IBOutlet weak var imagem: UIImageView!
    @IBOutlet weak var detalhes: UILabel!
    @IBOutlet weak var contador: UILabel!
    
    var snap = Snap()
    var tempo = 11
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: snap.urlImagem)
        
        detalhes.text = "Carregando..."
        
        imagem.sd_setImage(with: url) { imagem, erro, cache, url in
            
            if erro == nil {
                
                self.detalhes.text = self.snap.descricao
                
                // Criando um Timer para contagem do tempo antes de fechar a tela
                Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                    
                    self.tempo = self.tempo - 1
                    self.contador.text = String(self.tempo)
                    
                    if self.tempo == 0 {
                        // Parando a contagem
                        timer.invalidate()
                        // Fechando a tela atual e retornando para tela principal
                        self.dismiss(animated: true, completion: nil)
                        
                    }
                }
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        let autencacao = Auth.auth()
        if let idUsuarioLogado = autencacao.currentUser?.uid {
            
            let database = Database.database().reference()
            let usuarios = database.child("usuarios")
            let snaps = usuarios.child(idUsuarioLogado).child("snaps")
            
            // Deletando as informacoes do banco de dados do Firebase
            snaps.child(snap.identificador).removeValue()
            
            let storage = Storage.storage().reference()
            let imagens = storage.child("imagens")
            
            // Deletando a imagem do Storage do Firebase
            imagens.child("\(snap.idImagem).jpg").delete { erro in
                
                if erro == nil {
                    print("Sucesso as excluir a imagem")
                }else{
                    print("Erro ao excluir a imagem")
                }
            }
        }
    }
}
