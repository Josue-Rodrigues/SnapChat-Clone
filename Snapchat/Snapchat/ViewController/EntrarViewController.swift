
//  EntrarViewController.swift
//  Snapchat
//
//  Created by Josue Herrera Rodrigues on 26/10/21.

import UIKit
import FirebaseAuth

class EntrarViewController: UIViewController {
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var senha: UITextField!
    
    @IBAction func entrar(_ sender: Any) {
        
        if let email = email.text {
            if let senha = senha.text {
                
                // Checando se os campos de E-mail e Senha foram preenchidos
                if email == "" || senha == "" {
                    
                    let alerta = Alerta(titulo: "ATENÇÃO!!", mensagem: "Os campos de E-mail e Senha devem ser preenchidos, para que então possa ser feito a autenticação e login de sua conta.", botao: "Tentar novamente!")
                    
                    self.present(alerta.getAlerta(), animated: true, completion: nil)
                    
                }else{
                    
                    // Autenticando e fazendo o login do usuario de acordo com E-MAIL e SENHA
                    let autenticacao = Auth.auth()
                    autenticacao.signIn(withEmail: email, password: senha) { usuario, erro in
                        // Validando se o erro e nulo
                        if erro == nil {
                            // Validando se a informacao de usuario foi preenchida atraves da autenticacao
                            if usuario == nil {
                                
                                let alerta = Alerta(titulo: "ATENÇÃO!!", mensagem: "Erro de autenticação, tentar novamente!!", botao: "Tentar novamente!")
                                
                                self.present(alerta.getAlerta(), animated: true, completion: nil)
                                
                            }else{
                                print("Sucesso ao logar")
                                
                                // Redirecionando o usuario para tela principal ao clicar no botao caso nao haja nenhum erro durante o processo
                                self.performSegue(withIdentifier: "loginSegue", sender: nil)
                            }
                            
                        }else{
                            
                            let erroR = erro! as NSError
                            // Identificando o nome do erro e apresentando respostas ao Usuario conforme cada erro
                            if let codigoErro = erroR.userInfo["FIRAuthErrorUserInfoNameKey"] {
                                
                                let erroTexto = codigoErro as! String
                                var mensagemErro = ""
                                
                                switch erroTexto {
                                    
                                case "ERROR_INVALID_EMAIL" :
                                    mensagemErro = "E-mail invalido, digite um e-mail valido e tente novamente!"
                                    break
                                    
                                case "ERROR_USER_NOT_FOUND" :
                                    mensagemErro = "Usuario não cadastrado!"
                                    break
                                    
                                case "ERROR_WRONG_PASSWORD" :
                                    mensagemErro = "Senha digitada não confere com o E-mail preenchido!"
                                    break
                                    
                                default:
                                    mensagemErro = "E-mail e/ou senha digita estão incorreto!"
                                }
                                
                                let alerta = Alerta(titulo: "ATENÇÃO!!", mensagem: "Dados Invalidos: \(mensagemErro)", botao: "Tentar novamente!")
                                
                                self.present(alerta.getAlerta(), animated: true, completion: nil)
                            }
                        }
                    }
                }
            }
            
        }else{
            
            let alerta = Alerta(titulo: "ATENÇÃO!!", mensagem: "Verifique os dados digitados e tente novamente.", botao: "Tentar novamente!")
            
            self.present(alerta.getAlerta(), animated: true, completion: nil)
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // Função para ocultar ou apresentar o Navigation Bar na tela (True = Oculta / False = Apresenta)
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
    }
    
    // Fechando o teclado apos clicar fora do campo
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        
    }
}
