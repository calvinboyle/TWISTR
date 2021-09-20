void setup() {
  Serial.begin(9600);
}

void loop() {
  int adc = analogRead(A0);
  Serial.println(adc);
  delay(10);
}
