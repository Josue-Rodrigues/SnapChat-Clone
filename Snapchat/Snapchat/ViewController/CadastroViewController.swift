//
//  CadastroViewController.swift
//  Snapchat
//
//  Created by Josue Herrera Rodrigues on 26/10/21.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class CadastroViewController: UIViewController {
    
    @IBOutlet weak var emailCadastrar: UITextField!
    @IBOutlet weak var senhaCadastrar: UITextField!
    @IBOutlet weak var confirmarSenha: UITextField!
    @IBOutlet weak var nomeCadastrar: UITextField!
    
    @IBAction func cadastrar(_ sender: Any) {
        
        if let emailR = emailCadastrar.text {
            if let senhaR = senhaCadastrar.text {
                if let confirmaSenhaR = confirmarSenha.text {
                    if let nomeCadastradoR = nomeCadastrar.text {
                        
                        // Verificando se todos os campos foram preenchidos e criando um alerta caso contrario
                        if nomeCadastradoR == "" || emailR == "" || senhaR == "" || confirmaSenhaR == "" {
                            
                            // Criando um alerta caso um dos campos não sejam preenchido
                            let alerta = Alerta(titulo: "ATENÇÃO!!", mensagem: "Todos os campos devem ser preenchidos, para que possamos dar continuidade ao cadastro do usuario.", botao: "Tentar novamente!")
                            
                            self.present(alerta.getAlerta(), animated: true, completion: nil)
                            
                        }else{
                            
                            // Verificando se a senha e o confirmar senhas sao iguais
                            if senhaR == confirmaSenhaR {
                                
                                // Criando a conta atraves do FireBase
                                let autenticacao = Auth.auth()
                                autenticacao.createUser(withEmail: emailR, password: senhaR) { usuario, erro in
                                    if erro == nil {
                                        if usuario == nil {
                                            print("Erro ao cadastrar usuario")
                                            
                                        }else{
                                            
                                            // Criando as referencias do banco de dados do Firebase
                                            let armazenamento = Database.database().reference()
                                            // Criando o nó principal de USUARIOS
                                            let usuarios = armazenamento.child("usuarios")
                                            // Recuperando o ID do usuario atraves do Firebase
                                            let idUsuario = Auth.auth().currentUser
                                            // Criando um Dicionario com os dados do usuario para usar no valor do ID do USUARIO
                                            let usuarioDados = ["nome":nomeCadastradoR, "e-mail":emailR]
                                            // Criando o nó com o ID do USUARIO que esta logado
                                            usuarios.child(idUsuario!.uid).setValue(usuarioDados)
                                            
                                            // Criando um alerta informando o sucesso ao realizar o cadastro
                                            let alerta = UIAlertController(title: "CONGRATULATION!!", message: "Cadastro realizado com sucesso. Aproveite o app e indique para sua rede de amigos", preferredStyle: .alert)
                                            
                                            // Apos confirmar ele sera direcionado para a tela principal, atraves do comando "PERFORMSEGUE"
                                            let confirmar = UIAlertAction(title: "Confirmar", style: .cancel, handler: {(action) in self.performSegue(withIdentifier: "cadastroLoginSegue", sender: nil) })
                                            
                                            alerta.addAction(confirmar)
                                            
                                            self.present(alerta, animated: true, completion: nil)
                                        }
                                        
                                    }else{
                                        
                                        // Identificando e classificando o erro (Convertendo para o tipo NSErro)
                                        let erroR = erro! as NSError
                                        
                                        // Buscar dentro do USERINFO as informacao entre colchites [] a qual se trata no nome chave do erro
                                        if let codigoErro = erroR.userInfo["FIRAuthErrorUserInfoNameKey"] {
                                            
                                            let erroTexto = codigoErro as! String
                                            var mensagemErro = ""
                                            
                                            // Interpretando os possiveis erros e retornando mensagens
                                            switch erroTexto {
                                                
                                            case "ERROR_INVALID_EMAIL" :
                                                mensagemErro = "E-mail invalido, digite um e-mail valido!"
                                                break
                                                
                                            case "ERROR_WEAK_PASSWORD" :
                                                mensagemErro = "Senha deve conter no minimo 6 caracteres, sendo letras e numeros"
                                                break
                                                
                                            case "ERROR_EMAIL_ALREADY_IN_USE" :
                                                mensagemErro = "Este E-mail ja esta sendo utilizado, cria a conta com um novo E-mail"
                                                break
                                                
                                            default:
                                                mensagemErro = "Dados digitados estão incorretos"
                                            }
                                            
                                            let alerta = Alerta(titulo: "ATENÇÃO!!", mensagem: "Dados Invalidos: \(mensagemErro)", botao: "Tentar novamente!")
                                            
                                            self.present(alerta.getAlerta(), animated: true, completion: nil)
                                        }
                                    }
                                }
                                
                            }else{ /* Se caso as senhas digitas sejam diferentes, então.... */
                                
                                let alerta = Alerta(titulo: "ATENÇÃO!!", mensagem: "Verificar senhas digitadas e tentar novamente.", botao: "Confirmar")
                                
                                self.present(alerta.getAlerta(), animated: true, completion: nil)
                            }
                        }
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //  Fechando o teclado apos clicar fora do campo
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        
    }
    
    //  Função para ocultar ou apresentar o Navigation Bar na tela (True = Oculta / False = Apresenta)
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
    }
}
