package main

import (
	"fmt"
	"log"
	"net/http"
)

func ping(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "{\"ping\": \"OK\"}")
	// fmt.Println("Endpoint Hit: ping")
}

func home(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "<html><body><h1>Hello!</h1></body></html>")
	fmt.Println("Endpoint Hit: Home")
}

func error(w http.ResponseWriter, r *http.Request) {
	w.WriteHeader(http.StatusInternalServerError)
	w.Write([]byte("500 - Something bad happened!"))
}

func handleRequests() {
	http.HandleFunc("/service/ping", ping)
	http.HandleFunc("/error", error)
	http.HandleFunc("/", home)
	log.Fatal(http.ListenAndServe(":5000", nil))
}

func main() {
	handleRequests()
}
