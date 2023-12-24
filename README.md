Projeto de TCC executado no Colégio Técnico de Campinas - COTUCA, utilizando tecnologia para redução do consumo de água no planeta, bem como realizar o gerenciamento do mesmo de forma inteligente.

O projeto foi construído utilizando dispositivos eletroeletrônicos, sendo o microcontrolador o ESP32, e foi utilizada a programação em C para controle de todo o processo de cada componente. Foi desenvolvido também um aplicativo mobile(IOS e Android) para controle mais rigoroso do usuário quanto ao consumo de água de sua residência, estabelecimento, etc. A linguagem utilizada para o aplicativo foi o Dart, e também foi utilizado algumas bibliotecas para que fosse desenvolvido o projeto com mais precisão: 

Em C:
Websocket --> Comunicação Peer-to-Peer entre o ESP32 e o app; 

Wifi --> Comunicação dos dispositivos eletrônicos com o Firebase, sendo este responsável por armazenar os valores de leitura de um sensor de fluxo em seu "Realtime Database";

IOXhop_FirebaseESP32 --> Comunicação do dispositivo lógico com o servidor do banco de dados em nuvem, para leitura e escrita de dados;

LiquidCrystal_I2C --> Valores de leitura de vazão e total são apresentados num display I2C do projeto.

Em Dart: 

Web_socket_channel --> Estabelecer comunicação com o ESP32;

http --> realizar requisições de GET para obter os dados do Firebase para mostrar em uma tela do aplicativo;

firebase_auth --> Permite a autenticação de usuários, podendo realizar o cadastro, login e geração de UID para cada usuário;
