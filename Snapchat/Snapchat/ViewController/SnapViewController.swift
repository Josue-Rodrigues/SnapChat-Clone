//
//  SnapViewController.swift
//  Snapchat
//
//  Created by Josue Herrera Rodrigues on 28/10/21.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class SnapViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var snaps: [Snap] = []
    
    @IBOutlet weak var apresentacaoUsuario: UILabel!
    @IBOutlet weak var TableView: UITableView!
    
    @IBAction func logoff(_ sender: Any) {
        
        // Criando um alerta informando e confirmando se o Usuario realmente deseja sair e esta acao so sera executada ao clicar no botao confirmar
        let alerta = UIAlertController(title: "ATENÇÃO!!", message: "Você esta prestes a sair do SnapChat, deseja realmente fazer isto??", preferredStyle: .alert)
        
        let cancelar = UIAlertAction(title: "Cancelar", style: .destructive, handler: nil)
        let confirmar = UIAlertAction(title: "Confimar", style: .default) { (action) in
            
            do {
                
                let autenticacao = Auth.auth()
                //  Realizando o Logoff do usuario
                try autenticacao.signOut()
                //  Caso o usuario clique em continuar a tela atual sera fechada ele sera direcionado para a tela de inicio
                self.dismiss(animated: true, completion: nil)
                
            } catch {
                print("Errou ao deslogar o usuario")
                
            }
        }
        
        alerta.addAction(cancelar)
        alerta.addAction(confirmar)
        
        self.present(alerta, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let autenticacao = Auth.auth()
        if let idUsuarioLogado = autenticacao.currentUser?.uid {
            
            // Recuperando as informacoes dentro do Nó de usuario
            let database = Database.database().reference()
            let usuario = database.child("usuarios")
            // Identificando o ID do usuario e criando o NÓ de SNAPS
            let snaps = usuario.child(idUsuarioLogado).child("snaps")
            // Inserindo um OUVINDO ao NÓ de usuario avisar quando um novo Snap for adicionado
            snaps.observe(DataEventType.childAdded) { snapshot in
                
                // Convertendo os valores recuperados em SNAPSHOT em Dicionario
                let dados = snapshot.value as? NSDictionary
                // Inicializando a constante snap com a MODEL SNAP
                let snap = Snap()
                
                // Recuperando as informacoes e dando valores a ela
                snap.identificador = snapshot.key
                snap.nome = dados?["nome"] as! String
                snap.descricao = dados?["descricao"] as! String
                snap.urlImagem = dados?["urlImagem"] as! String
                snap.idImagem = dados?["idImagem"] as! String
                
                self.snaps.append(snap)
                self.TableView.reloadData()
                
            }
            
            // Criando um observe para cada vez que for removido um usuario identificar e remover a linha de SNAP referente
            snaps.observe(DataEventType.childRemoved) { snapshot in
                
                var indice = 0
                for snap in self.snaps {
                    if snap.identificador == snapshot.key {
                        self.snaps.remove(at: indice)
                    }
                    
                    indice = indice + 1
                }
                
                self.TableView.reloadData()
            }
        }
    }
    
    // Quantidade de linhas que serão apresentadas na TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let totalSnaps = snaps.count
        // Caso o usuario não tenha nenhum SNAP sera apresentada somente uma linha
        if totalSnaps == 0 {
            return 1
        }
        
        return totalSnaps
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let celula = tableView.dequeueReusableCell(withIdentifier: "celulaReuso", for: indexPath)
        
        let totalSnaps = snaps.count
        // Caso o usuario nao tenha nenhuma SNAP devera apresentar a mensagem abaixo
        if totalSnaps == 0 {
            celula.textLabel?.text = "Nenhum Snap para você :)"
            
        }else{
            
            let snap = self.snaps[ indexPath.row ]
            celula.textLabel?.text = snap.nome
            
        }
        
        return celula
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let totalSnaps = snaps.count
        if totalSnaps > 0 {
            
            let snap = self.snaps[indexPath.row]
            self.performSegue(withIdentifier: "detalhesSnapSegue", sender: snap)
            
        }
    }
    
    // Funcao para envio de informacoes de uma tela para outra atraves da SEGUE - detalhesSnapSegue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "detalhesSnapSegue" {
            // Enviando as informacoes abaixo para a DETALHESSNAPVIEWCONTROLLER
            let detalhesSnapViewController = segue.destination as! DetalhesSnapViewController
            
            detalhesSnapViewController.snap = sender as! Snap
        }
    }
}
