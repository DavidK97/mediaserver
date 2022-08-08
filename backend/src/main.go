package main

import (
	"log"

	"github.com/DavidK97/mediaserver/routes"
)

func main() {
	log.Println("Starting REST-API Server...")
	routes := routes.Routes{}
	routes.Initialize()
	log.Println("Server started!")
	routes.Run(":8010")
}
