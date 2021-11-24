# SnapChat-Clone
 
Projeto mobile desenvolvido em Swift, para envio de fotos entre usuarios.

Foi utilizado a plataforma do FireBase para realização dos serviços de autenticação (Authentication), armazenamento das informações em banco dados (Realtime Database) e arquivamento das imagens através do Storage. Para recuperação e tratamento das imagens recebidas e enviadas, foi utilizado o Framework SDWebImage.

Funcionalidades Básicas:

- Tela principal com campo de Login e Cadastro
- Tela de cadastro (Nome, E-mail, Senha e Confirmar Senha)
- Tela de Login (E-mail e Senha)
- Tela de listagem do Snaps recebidos apresentando o nome do Usuario que enviou
- Tela com os detalhe do Snap enviado
  * Aprensentando a imagem enviada, descrição e contendo um contador numerico decrecente o qual estabelece o tempo permitido para visualização daquele Snap
- Tela de seleção de imagem através de uma biblioteca local ou uso da camera do celular
  * Campo para descricao da imagem escolhido ou texto de sua escolha para envio ao usuario de destino *
- Tela escolha do usuario ao qual deseja realizar o envio do Snap (Nome e E-mail do usuario)
