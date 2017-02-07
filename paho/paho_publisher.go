package main

import (
  "fmt"
  //import the Paho Go MQTT library
  MQTT "github.com/eclipse/paho.mqtt.golang"

  "time"
)

//define a function for the default message handler
var f MQTT.MessageHandler = func(client MQTT.Client, msg MQTT.Message) {
  fmt.Printf("TOPIC: %s\n", msg.Topic())
  fmt.Printf("MSG: %s\n", msg.Payload())
}

func main() {
	


  //create a ClientOptions struct setting the broker address, clientid, turn
  //off trace output and set the default message handler
  opts := MQTT.NewClientOptions().AddBroker("tcp://localhost:1883")
  opts.SetClientID("go-simple")
  opts.SetDefaultPublishHandler(f)

  //create and start a client using the above ClientOptions
  c := MQTT.NewClient(opts)
  if token := c.Connect(); token.Wait() && token.Error() != nil {
    panic(token.Error())
  }
defer c.Disconnect(250)


  for i := 0; i < 5; i++ {
    text := fmt.Sprintf("this is msg #%d!", i)
    token := c.Publish("go-mqtt/sample", 0, false, text)
    token.Wait()
  }

  time.Sleep(3 * time.Second)





 //c.Disconnect(250)
}

