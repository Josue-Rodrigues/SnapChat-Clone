//
//  FotoViewController.swift
//  Snapchat
//
//  Created by Josue Herrera Rodrigues on 29/10/21.

import UIKit
import FirebaseStorage

class FotoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imagem: UIImageView!
    @IBOutlet weak var descricao: UITextField!
    @IBOutlet weak var botaoProximo: UIButton!
    
    var imagePicker = UIImagePickerController()
    var idImagem = NSUUID().uuidString
    
    @IBAction func proximoPasso(_ sender: Any) {
        
        // Desabilitando o botão e mudando seu titulo
        botaoProximo.isEnabled = false
        botaoProximo.setTitle("Carregando...", for: .normal)
        
        // Iniciando o Storege
        let armazenamento = Storage.storage().reference()
        // Criando a pasta IMAGENS
        let imagens = armazenamento.child("imagens")
        
        if let imagemSelecionada = imagem.image {
            
            // Convertendo a foto selecionada para o formato de DADOS e comprimindo o padrao de qualidade da mesma
            if let imagemDados = imagemSelecionada.jpegData(compressionQuality: 0.5) {
                
                // Salvando a imagem dentro do firebase e dando um nome aleatorio.JPG
                imagens.child("\(self.idImagem).jpg").putData(imagemDados, metadata: nil) { metaDados, erro in
                    
                    if erro == nil {
                        print("Sucesso ao fazer upload do arquivo")
                        
                        // Criando a referentecia da URL da iamgem (Buscando ela dentro do caminho)
                        let referenciaUrl = Storage.storage().reference().child("imagens/\(self.idImagem).jpg")
                        
                        // Buscando a URL e efetuando o dela dentro da variavel "urlRef"
                        referenciaUrl.downloadURL { urlRef, error in
                            if error == nil {
                                
                                // Transportando a referencia da URL da foto para a proxima tela
                                self.performSegue(withIdentifier: "selecionarUsuarioSegue", sender: urlRef)
                                
                                // Habilitando o botao novamente e retornando o seu titulo original
                                self.botaoProximo.isEnabled = true
                                self.botaoProximo.setTitle("Proximo", for: .normal)
                                
                            } else {
                                print("Erro ao fazer download da URL")
                            }
                        }
                        
                    }else{
                        print("Erro ao fazer upload do arquivo")
                        
                        // Criando um alerta caso não seja possivel salvar a imagem no SNAP
                        let alerta = Alerta(titulo: "ATENÇÃO!!", mensagem: "Erro ao salvar o arquivo, por favor tente novamente", botao: "Tentar novamente!")
                        
                        self.present(alerta.getAlerta(), animated: true, completion: nil)
                        
                    }
                }
            }
        }
    }
    
    // Funcao para envio de informacoes entre telas atraves de um SEGUE
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Referenciando a SEGUE escolhida
        if segue.identifier == "selecionarUsuarioSegue" {
            
            // Criando a referentecia da URL da imagem (Buscando ela dentro do caminho)
            let referenciaUrl = Storage.storage().reference().child("imagens/\(self.idImagem).jpg")
            
            // Buscando a URL e efetuando o download dela dentro da variavel "urlRef"
            referenciaUrl.downloadURL { urlRef, error in
                if error == nil {
                    
                    // Convertendo a URL em STRIG
                    let urlRecuperada = urlRef?.absoluteString
                    // Mandando as informacoes para a ViewController - USUARIOTABLEVIEWCONTROLLER - atraves das VAR abaixo
                    let usuarioViewController = segue.destination as! UsuariosTableViewController
                    
                    usuarioViewController.detalhesUsuario.descricao = self.descricao.text!
                    usuarioViewController.detalhesUsuario.idImagem = self.idImagem
                    usuarioViewController.detalhesUsuario.urlImagem = urlRecuperada!
                    
                } else {
                    print("Erro ao fazer download da URL")
                }
            }
        }
    }
    
    @IBAction func selecionarCamera(_ sender: Any) {
        
        // Definindo o local de onde devera ser retirado as imagens (CAMERA = Acesso a camera do usuario)
        imagePicker.sourceType = .camera
        // Apresentando a imagem na tela para o usuario
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func selecionarAlbum(_ sender: Any) {
        
        // Definindo o local de onde devera ser retirado as imagens (SAVEPHOTOSALBUM = Fotos tiradas recentementes)
        imagePicker.sourceType = .savedPhotosAlbum
        // Apresentando a imagem na tela para o usuario
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // Recuperando a imagem selecionada e salvando dentro do ImagePicker
        let imagemRecuperada = info[ UIImagePickerController.InfoKey.originalImage ] as! UIImage
        // Salvando a imagem recuperada dentro da UIIMAGEVIEW
        imagem.image = imagemRecuperada
        botaoProximo.isEnabled = true
        
        // Retornando a tela anterior apos escolha da foto desejada
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Criando o gerenciador das imagens
        imagePicker.delegate = self
        // Desabilitando o botao e aguardando um imagem ser carregada
        botaoProximo.isEnabled = false
        
    }
    
    // Fechando o teclado apos clicar fora do campo
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        
    }
}
