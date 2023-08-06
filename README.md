## Sobre

**Musclemate** é projeto é composto por um aplicativo móvel desenvolvido em Flutter com o com seu backend desenvolvido em Java e com um banco de dados Postgres.

![Recurso-gráfico](https://github.com/Mazzotti1/Musclemate/assets/70278577/2ac25a05-f106-4caf-b864-416474d98e1a)


A base de dados foi construída com Postgres e alocada no serviço da RDS e o servidor da API foi hosteado pelo EC2 da AWS

A combinação dessas tecnologias agrupadas por container com Docker permitiu uma experiência de desenvolvimento ágil e escalável.

## Eu construí o APP de ponta a ponta e claro não podia faltar o Design no Figma! Segue o link para conferir a primeira versão da UI do app: <a href="https://www.figma.com/file/kVahFfSf5aYkkgWJkWFVxe/MuscleMate?mode=dev" >Clique aqui!</a>

## Utilização

O aplicativo móvel foi desenvolvido para ser um parceiro de registro de dados dos treinamentos de musculação do usuário,mostrando por meio dos dados e de gráficos a sua evolução.
E o projeto conta com um sistema de rede social, fazendo com que os usuários consigam avaliar os treinos um dos outros e deixar comentários sobres os treinos!

![recordScreen](https://github.com/Mazzotti1/Musclemate/assets/70278577/7b2b6bca-504b-40ac-b536-a1ddf6303a81)


A API foi desenvolvida com segurança e encriptação de dados de ponta a ponta, com as mais diversas funções. Os usuários podem interagir sobre seus perfis, comentar sobre seus treinos registrados
e seguir uns aos outros para não perder os próximos treinos!


![perfilScreen](https://github.com/Mazzotti1/Musclemate/assets/70278577/38f14305-e52f-43a4-95e7-7d69fc92504d)
![graphsSreen](https://github.com/Mazzotti1/Musclemate/assets/70278577/e113154d-ef04-4a0f-a126-0b66148968ef)


No momento que o usuário está logado ele recebe um mini tutorial para cada tela que entra, para se habituar as funções do aplicativo

![loginScreen](https://github.com/Mazzotti1/Musclemate/assets/70278577/ab4b5c30-2f2d-4159-bb59-3983d4e5c731)
![recordingScreen](https://github.com/Mazzotti1/Musclemate/assets/70278577/c12d0336-5c33-4163-8e14-a956c9a7c568)

Quando o usuário está logado ele também libera a opção de poder registrar um treino, baseado no grupo muscular que ele escolhe, ou um treino padrão já pré definido anteriormente.

![recordScreen](https://github.com/Mazzotti1/Musclemate/assets/70278577/fa7dcca7-26de-427a-a0f0-04796c2196d7)


## O projeto é composto por:

- **API única:** Uma API desenvolvida especificamente para esse projeto, com intuito de ser extremamente funcional e segura;

- **Registro, Login e controle de perfil:** Usuário tem a possibilidade de se registrar, se logar, mudar os dados do perfil, adcionar mais informações como endereço por exemplo, e também com a funcionalidade de troca de foto do perfil;

![configScreen](https://github.com/Mazzotti1/Musclemate/assets/70278577/186c872b-0f5b-4457-afa4-bdccbc35424d)
![perfilScreen](https://github.com/Mazzotti1/Musclemate/assets/70278577/103afa7b-ea4e-464e-b439-52d78487eba5)


- **Banco de dados:** Banco de dados desenvolvido com PostgresSql, para agilizar ainda mais o processo da criação de tabelas e unificação da minha API, e deixar o banco mais escalavel com valor de custo mais baixo.

- **Firebase bucket:** Para controlar as fotos de perfil dos usuários eu optei por em vez de salvar localmente no dispositivo a foto escolhida, ou salvar no meu próprio banco de dados , eu criei um bucket no Firebase da Google para armazenar em uma pasta específica com o nome do usuário que salvou a foto, e no meu banco de dados eu salvo apenas o URI na tabela de usuário, então assim eu diminuí drasticamente o uso do meu espaço no banco de dados para controle de fotos.

- **AWS EC2:** Para hospedar minha API em um servidor para rodar 24/7, eu usei o EC2 da AWS, criei uma VM com ubuntu e conectei com a instanância que havia criado do EC2 por conexão ssh, então clonei minha API para dentro da VM e rodei com a biblioteca PM2

- **Recuperação de senha:** Para aqueles usuários que esqueceram suas senhas, criei um sistema que o usuário pode clicar em "esqueci minha senha" na tela de login e então vai ser redirecionado para a tela de dizer o email dele, logo o aplicativo ja verifica se esse email existe na base de dados, caso não exista ele diz para o usuário que o email pode estar inválido, caso seja um email existente, o aplicativo usando os serviços do MAILGUN vai disparar um email com um código de recuperação para o usuário trocar a senha.


- **Google Auth:** O usuário tem a possibilidade de se registrar com uma conta google e sempre se logar com a mesma apenas clicando em "Continuar com Google", essa implementação ajuda muito aqueles usuários que preferem a praticidade ao se registrar e logar, e pelo fato do flutter também ser desenvolvido pelo Google, a utilização do Firebase é extremamente fácil .

![loginScreen](https://github.com/Mazzotti1/Musclemate/assets/70278577/8011d7b0-9af2-4a60-9b64-34d8099cac4a)


## Principais tecnologias utilizadas:

<div>
    <img src="https://img.shields.io/badge/FLUTTER-000B1D?style=for-the-badge&logo=FLUTTER&logoColor=white" />
    <img src="https://img.shields.io/badge/JAVA-000B1D?style=for-the-badge&logo=JAVA&logoColor=white" />
    <img src="https://img.shields.io/badge/POSTGRESQL-000B1D.svg?style=for-the-badge&logo=POSTGRESQL&logoColor=%white" /> 
    <img src="https://img.shields.io/badge/SPRINGBOOT-000B1D?style=for-the-badge&logo=SPRINGBOOT&logoColor=white" /> 
    <img src="https://img.shields.io/badge/DOCKER-000B1D.svg?style=for-the-badge&logo=DOCKER&logoColor=white" /> 
    <img src="https://img.shields.io/badge/FIREBASE-000B1D.svg?style=for-the-badge&logo=FIREBASE&logoColor=white" /> 
    <img src="https://img.shields.io/badge/AWS-000B1D.svg?style=for-the-badge&logo=amazon-aws&logoColor=white" />
    <img src="https://img.shields.io/badge/GOOGLE-000B1D.svg?style=for-the-badge&logo=google&logoColor=white" /> 
  
</div>

## Engenharia de usabilidade e acessibilidade do aplicativo <br>

Para garantir a melhor experiência de usuário possível, o aplicativo foi desenvolvido com base em conceitos de engenharia de usabilidade, tornando a interação com ele intuitiva e eficiente. Além disso, a acessibilidade foi um requisito fundamental durante o processo de desenvolvimento, com a inclusão de recursos que permitem que todas as pessoas possam utilizar o aplicativo, independentemente de suas habilidades físicas ou cognitivas.

## Grandes dificuldades encontradas:

  Criação e desenvolvimento de uma base de dados que fosse firme robusta e eficaz
   
   Responsividade para todos os dispositivos, eu criei desde o inicio o frontend com o máximo de valores "Flex" para que a tela fosse responsiva na maioria dos dispositivos móveis, mas acredito que eu poderia ter dado mais atenção a essa questão.
   
## Melhorias que podem ser implementadas:

- **1)**  Além das estatísticas e números que os usuários podem compartilhar e criar uma comunidade treino, seria muito interessante em um futuro adcionar sistema de ranks e conquistas, e prêmios visuais para treinos ou recordes batidos

---

<table>
    <td>
      Feito por <a href="https://github.com/Mazzotti1">Gabriel Mazzotti</a>
    </td>
</table>
<table>
    <td>
        <a href="https://github.com/Mazzotti1/BarberCutApp/blob/main/LICENSE">Licence</a>
    </td>
</table>

