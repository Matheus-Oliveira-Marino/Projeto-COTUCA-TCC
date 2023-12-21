#include <WiFi.h>
#include <WebSocketsServer.h>
#include <Wire.h>
#include <LiquidCrystal_I2C.h>
#include <IOXhop_FirebaseESP32.h> 
#include <ArduinoJson.h>    

const char* ssid = "nayoliver";
const char* password = "nayoliver55";
const int maxTentativas = 2;
bool userRecebido = false;
int random1 = 1;
int random2 = 2;

#define FIREBASE_HOST "https://wcm-tecnology-default-rtdb.firebaseio.com/" // link do banco de dados
#define FIREBASE_AUTH "9fmLVu470vwcIwcM7rPXL27aHWiR3f5XgV6HQMfJ"   // senha do banco de dados

String userUID;
WebSocketsServer webSocket = WebSocketsServer(80);

LiquidCrystal_I2C lcd(0x27, 16, 2);

int x;
int y;
float consumoPorLitro = 2.01; // SANASA - consumo a cada mil litros em Campinas - SP.
float valorLitros = 0; // Valor em Litros
float metroCubico = 0; // Consumo de água por metro cúbico 
float consumoEmReais = 0;
float totalLitrosConsumidos = 0;  // Variável para controlar o total de litros consumidos

  #define PinoWaterFlow 2
  #define pinoSensorInfravermelho 4
  #define pinoRele 23

  long currentMillis = 0;
  long previousMillis = 0;
  int interval = 1000;
  boolean ledState = LOW;
  float calibrationFactor = 8.0;
  volatile byte pulseCount;
  byte pulse1Sec = 0;
  float flowRate;
  unsigned int flowMilliLitres;
  unsigned long totalMilliLitres;



unsigned long tempo_antes = 0;

// Chamado sempre que houver um evento WebSocket.
void webSocketEvent(uint8_t num, WStype_t type, uint8_t *payload, size_t length) {
  String receivedUID; // Mova a declaração para fora do bloco switch

  switch (type) {
    case WStype_TEXT:
      // Recebeu um texto (no nosso caso, o UID)
      Serial.printf("[%u] Recebido Payload: %s\n", num, payload);

      // Converter o payload em uma string
      receivedUID = String((char*)payload);

      // Atribuir a string à variável userUID
      userUID = receivedUID;
      Serial.println(userUID);
      
      
    break;

    default:
      break;

      
  }
}

  void IRAM_ATTR pulseCounter()
  {
    pulseCount++;
  }

void setup() 
{
  Serial.flush();
  lcd.clear();
  delay(3000);
  Serial.begin(9600, SERIAL_8N1);
  lcd.init();
  lcd.backlight();
  WiFi.begin(ssid, password); //inicia comunicação com wifi com rede definida anteriormente
  int tentativas = 0;

  while (tentativas < maxTentativas)
  {
    Serial.print("Tentativa " + String(tentativas + 1) + ": Conectando com o wifi.....");
    lcd.clear();
    lcd.setCursor(0, 0);
    lcd.print("Connecting to ");
    lcd.setCursor(1, 7);
    lcd.print("WI-FI... ");

    int tempoInicial = millis();
    while (WiFi.status() != WL_CONNECTED && millis() - tempoInicial < 15000) 
    {
     delay(1000);
    }
    Serial.println();

    if (WiFi.status() == WL_CONNECTED)
    {
      Serial.println("Conexão Wi-Fi estabelecida");
      lcd.clear();
      lcd.setCursor(0, 0);
      lcd.print("Connected to ");
      lcd.setCursor(0, 1);
      lcd.print("WI-FI: " + WiFi.SSID());
      delay(1000);
      lcd.clear();

      //Inicialização do Firebase
      Firebase.begin(FIREBASE_HOST, FIREBASE_AUTH);

      webSocket.begin();
      webSocket.onEvent(webSocketEvent);
      Serial.println("Servidor WebSocket iniciado na porta 80");
      Serial.print("Endereço IP: ");
      Serial.println(WiFi.localIP());

      pinMode(PinoWaterFlow, INPUT_PULLUP); // Inicializando sensor de Fluxo 
      pulseCount = 0;
      flowRate = 0.0;
      flowMilliLitres = 0;
      totalMilliLitres = 0;
      previousMillis = 0;
      attachInterrupt(digitalPinToInterrupt(PinoWaterFlow), pulseCounter, FALLING); // contagem de Pulsos a cada nivel lógico LOW;
      pinMode(pinoRele, OUTPUT);
      pinMode(pinoSensorInfravermelho, INPUT);
      digitalWrite(pinoSensorInfravermelho, LOW);
      digitalWrite(pinoRele, 1);
      delay(300);
      break;
    } 
    else 
    {
      Serial.println();
      Serial.println("Falha ao conectar-se a rede Wi-Fi.");
      lcd.clear();
      lcd.setCursor(0, 0);
      lcd.print("No worries :D ");
      lcd.setCursor(0, 1);
      lcd.print("Attempt 2...");
      delay(1000);
      lcd.clear();
      tentativas++;      
    }

    if (tentativas >= maxTentativas) 
    {
      Serial.println();
      Serial.println("Numero máximo de tentativas atingido. Verifique sua rede Wi-Fi.");
      lcd.clear();
      lcd.setCursor(0, 0);
      lcd.print("Connection error");
      lcd.setCursor(0, 1);
      lcd.print("trying again...");
      delay(1000);
      // Lidar com a falha após o número máximo de tentativas aqui
      Serial.flush(); // Limpa o buffer serial
      setup();
      Serial.println("\n");
      
    }
  }
}

void loop() // Inicio da função loop
{
  // Lida com a abertura e fechamento de conexões, recebe mensagens WebSocket e lida com eventos associados.
  webSocket.loop();
  int estadoSensor = digitalRead(pinoSensorInfravermelho);

      if (!userUID.isEmpty()) 
      {
        //Rotas para acesso a registros no Realtime Database
        String pathLitrosMin = "/users/" + userUID + "/litrosPorMinuto";
        String pathVazao = "/users/" + userUID + "/vazao";
        String pathReais = "/users/" + userUID + "/reais";

         if(digitalRead(pinoSensorInfravermelho) == 0)
         {
            digitalWrite(pinoRele, 0);  
            delay(250);
            // Enviando dados para o Firebase
            // Obtém o tempo atual em milissegundos desde que o programa começou a ser executado. 
           
            // Verifica se passou tempo suficiente desde a última medição.
            currentMillis = millis();
            
            //Isso é feito comparando a diferença entre o tempo atual (currentMillis) e o tempo da última medição (previousMillis) com um intervalo desejado (interval).
            if (currentMillis - previousMillis > interval) 
            {
              pulse1Sec = pulseCount; // Armazena o número de pulsos ocorridos no último segundo
              pulseCount = 0;

              //  Calcula a taxa de fluxo com base no número de pulsos no último segundo e no tempo decorrido
              // A constante 1000.0 converte milissegundos para segundos
              // O resultado é dividido pelo fator de calibração, que é usado para ajustar a precisão da medição.
              flowRate = ((1000.0 / (currentMillis - previousMillis)) * pulse1Sec) / calibrationFactor;
              previousMillis = currentMillis;

              flowMilliLitres = (flowRate / 60) * 1000;
              totalMilliLitres += flowMilliLitres;

              valorLitros = totalMilliLitres / 1000;
              metroCubico = valorLitros / 1000;

              consumoEmReais = (metroCubico * 6.70) + 35.36; // Valor do consumo

              // Enviando dados para o Firebase
              Firebase.setFloat(pathLitrosMin.c_str(), int(flowRate));
              Firebase.setFloat(pathReais.c_str(), consumoEmReais);
              Firebase.setInt(pathVazao.c_str(), int(totalMilliLitres)); 
              delay(250);
          

              // Atualizando display LCD
              lcd.clear();
              lcd.setCursor(0, 0);
              lcd.print("volume: ");
              lcd.print(int(flowRate));
              lcd.print("L/M");

              lcd.setCursor(0, 1);
              lcd.print("total: ");
              lcd.print(totalMilliLitres);
              lcd.print("ml/ ");
              lcd.print(totalMilliLitres/1000);
              lcd.print("L"); 

              // Resetando o contador de tempo
              previousMillis = currentMillis;     
            }            
         }
          else
          {
            digitalWrite(pinoRele, 1);
            flowMilliLitres = 0;
            flowRate = 0;

              lcd.clear();
              lcd.setCursor(0, 0);
              lcd.print("volume: ");
              lcd.print(int(flowRate));
              lcd.print("L/M");

              lcd.setCursor(0, 1);
              lcd.print("total: ");
              lcd.print(totalMilliLitres);
              lcd.print("ml/ ");
              lcd.print(totalMilliLitres/1000);
              lcd.print("L"); 
          }                     
      }
      
} // fim da função loop

  
