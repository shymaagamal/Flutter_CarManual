#include <ESP8266WiFi.h>
#include <FirebaseArduino.h>
#include <SPI.h>
#include <MFRC522.h>
// Set these to run example.
#define FIREBASE_HOST "final-dd271-default-rtdb.firebaseio.com"
#define FIREBASE_AUTH "cHQDlmnZv0wfJrd6El59aPm2tlBatXd5QskeJFl9"
#define WIFI_SSID "CMP_LAB1"
//#define WIFI_PASSWORD "BME1Stud"



constexpr uint8_t RST_PIN = 0;     // Configurable, see typical pin layout above
constexpr uint8_t SS_PIN = 2;     // Configurable, see typical pin layout above
MFRC522 rfid(SS_PIN, RST_PIN); // Instance of the class
MFRC522::MIFARE_Key key;
int tag;

void setup() {
  Serial.begin(9600);
  SPI.begin(); // Init SPI bus
  rfid.PCD_Init(); // Init MFRC522
  // connect to wifi.
  WiFi.begin(WIFI_SSID);
  Serial.print("connecting");
  while (WiFi.status() != WL_CONNECTED) {
    Serial.print(".");
    delay(500);
  }
  Serial.println();
  Serial.print("connected: ");
  Serial.println(WiFi.localIP());
  
  Firebase.begin(FIREBASE_HOST, FIREBASE_AUTH);
}

int n = 0;

void loop() {


  if (rfid.PICC_ReadCardSerial()) {
    for (byte i = 0; i < 2; i++) {
      tag += rfid.uid.uidByte[i];
    }
    Firebase.setInt("Man/Place/X",tag);
    // handle error
    if (Firebase.failed()) {
        Serial.print("setting /number failed:");
        Serial.println(Firebase.error());  
        return;
    }
    Serial.println(tag);
    tag = 0;
    //rfid.PICC_HaltA();
    rfid.PCD_StopCrypto1();
  }


  
  // set value
  
  
}
