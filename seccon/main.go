package main

import (
	"log"
	"net/http"
	"os"
	"strconv"
	"time"

	sc "seccon/go"
)

func main() {

	router := sc.NewRouter()

	intervalMillis, err := strconv.Atoi(os.Args[3])
	if err != nil {
		panic(err)
	}
	waitMillis, err2 := strconv.Atoi(os.Args[4])
	if err2 != nil {
		panic(err2)
	}

	sc.SetUpSecConPubSub(os.Args[2], time.Duration(intervalMillis), time.Duration(waitMillis), os.Args[5:])

	log.Printf("Server started")
	log.Fatal(http.ListenAndServe(":8080", router))
}
