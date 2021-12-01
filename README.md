# SnapChat-Clone
 
Projeto mobile desenvolvido em **_Swift_**, com a função de envio de fotos entre seus usuarios.

Foi utilizado para desenvolvimento do aplicativo a plataforma do FireBase para realização dos serviços de autenticação (*Authentication*), armazenamento das informações em banco dados (*Realtime Database*) e arquivamento das imagens através do *Storage*. Para recuperação e tratamento das imagens recebidas e enviadas, foi utilizado o Framework **_SDWebImage_**.

### Funcionalidades Básicas:

- Tela principal com campo de Login e Cadastro
- Tela de cadastro *(Nome, E-mail, Senha e Confirmar Senha)*
- Tela de Login *(E-mail e Senha)*
- Tela de listagem do Snaps recebidos apresentando o nome do Usuario que enviou
- Tela com os detalhe do Snap enviado
  * _Apresentando a imagem enviada, descrição e contendo um contador numerico decrecente o qual estabelece o tempo permitido para visualização daquele Snap_
- Tela de seleção de imagem através de uma biblioteca local ou uso da camera do celular
- Campo para descricao da imagem selecionada ou texto de sua escolha para envio ao usuario de destino
- Tela escolha do usuario ao qual deseja realizar o envio do Snap *(Nome e E-mail do usuario)*
