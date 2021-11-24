//
//  UsuariosTableViewController.swift
//  Snapchat
//
//  Created by Josue Herrera Rodrigues on 04/11/21.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class UsuariosTableViewController: UITableViewController {
    
    var usuarios: [Usuario] = []
    var detalhesUsuario = DetalhesUsuario()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Acessando o Database e recuperando suas referencias
        let database = Database.database().reference()
        // Acessando o NÓ de USUARIOS
        let usuarios = database.child("usuarios")
        // Criando um OBSERVADOR para alertar sempre que for add um novo usuario
        usuarios.observe(DataEventType.childAdded) { Snapshot in
            
            // Convertendo os dados recuperados em um DICIONARIO
            let dados = Snapshot.value as? NSDictionary
            
            // Recuperando dados do usuario logado
            let autenticacao = Auth.auth()
            let idUsuarioLogado = autenticacao.currentUser?.uid
            
            // Recuperando os valores e salvando dentro de uma variavel
            let emailUsuario = dados?["E-mail"] as! String
            let nomeUsuario = dados?["nome"] as! String
            let idUsuario = Snapshot.key
            
            // Criando o objeto usuario que recebera um Array de Usuario conforme os dados recuperados
            let usuario = Usuario(email: emailUsuario, nome: nomeUsuario, uid: idUsuario)
            
            // Adicionando o usuario no Array, excluindo da lista apenas o usuario logado
            if idUsuario != idUsuarioLogado {
                self.usuarios.append(usuario)
                
            }
            // Recarregando a TableView
            self.tableView.reloadData()
        }
    }
    
    // Quantidade de secao que tera a TableView
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // Quantidade de linhas que tera a TableView
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.usuarios.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Identificando a celula atraves do Identifier
        let celula = tableView.dequeueReusableCell(withIdentifier: "celulaReuso", for: indexPath)
        
        // Recuperando as informacoes e salvando dentro da TextLabel e DetailTextLabel
        let usuario = self.usuarios[ indexPath.row ]
        
        celula.textLabel?.text = usuario.nome
        celula.detailTextLabel?.text = usuario.email
        
        // Retornando as informacoes e apresentando na celula
        return celula
    }
    
    // Ao selecionar a linha sera executada as acoes abaixo
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Recuperando as informacoes armazenadas na linha atraves do Indexpath e salvando na variavel
        let usuarioSelecionado = self.usuarios[ indexPath.row ]
        // Recuperando o ID do usuario Selecionado e salvando na variavel
        let idUsuarioSelecionado = usuarioSelecionado.uid
        
        // Criando um alerta notificando o usuario de qual contato foi solicitado e se ele realmente deseja continuar com o envio
        let alerta = UIAlertController(title: "ATENÇÃO!!", message: "Você acaba de selecionar o contato do(a) \(usuarioSelecionado.nome), para envio de um Snap, deseja realmente continuar?", preferredStyle: .alert)
        
        // Caso confirmado sera dado continuidade no processo de recuperacao e dos dados e envio do SNAP
        let confirmar = UIAlertAction(title: "Confirmar", style: .cancel, handler: {(action) in
            
            let database = Database.database().reference()
            let usuarios = database.child("usuarios")
            // Recuperando as referencias do NÓ de usuario e acessando o ID do usuario e criando o NÓ de SNAPS
            let snaps = usuarios.child(idUsuarioSelecionado).child("snaps")
            
            // Recuperando as informacoes do Usuario Logado atraves do FireBase
            let autenticacao = Auth.auth()
            let idUsuarioLogado = autenticacao.currentUser?.uid
            
            let usuarioLogado = usuarios.child(idUsuarioLogado!)
            // Criando um OBSERVE para o NÓ do IdUsuarioLogado
            usuarioLogado.observeSingleEvent(of: DataEventType.value) { snapshot in
                
                let dados = snapshot.value as? NSDictionary
                
                // Salvando as informacoes recuperadas dentro da LET SNAP e dando o valor para cada campo
                let snap = [
                    "de": dados?["E-mail"] as! String,
                    "nome": dados?["nome"] as! String,
                    "descricao": self.detalhesUsuario.descricao,
                    "idImagem": self.detalhesUsuario.idImagem,
                    "urlImagem": self.detalhesUsuario.urlImagem
                ]
                
                // Criando um Id aleatorio para ser criado dentro do nó SNAP
                snaps.childByAutoId().setValue(snap)
                
                // Criando um alerta caso tenha sido possivel salvar as informacoes e enviar ao usuario selecionado
                let alerta = UIAlertController(title: "CONGRATULATION!!", message: "Dados enviados com sucesso para \(usuarioSelecionado.nome), gostaria de enviar um novo Snap?", preferredStyle: .alert)
                
                // Apos confirmar ele sera direcionado para a tela de envio de Snap, atraves do comando "PERFORMSEGUE"
                let confirmar = UIAlertAction(title: "Confirmar", style: .cancel, handler: {(action) in self.performSegue(withIdentifier: "RetornoUsuarioSegue", sender: nil) })
                
                // Apos cancelar ele sera direcionado para a tela principal
                let voltar = UIAlertAction(title: "Voltar", style: .destructive, handler: {(action) in self.navigationController?.popToRootViewController(animated: true) })
                
                // Adicionando os botoes ao alerta
                alerta.addAction(confirmar)
                alerta.addAction(voltar)
                
                // Apresentando na tela
                self.present(alerta, animated: true, completion: nil)
            }
        })
        
        // Apos cancelar ele sera direcionado para a tela principal
        let cancelar = UIAlertAction(title: "Cancelar", style: .destructive, handler: nil)
        
        // Adicionando os botoes ao alerta
        alerta.addAction(confirmar)
        alerta.addAction(cancelar)
        
        // Apresentando na tela
        self.present(alerta, animated: true, completion: nil)
    }
}
