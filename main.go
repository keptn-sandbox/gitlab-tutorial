package main

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"
)

type Search struct {
	Text string
}

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

func search(w http.ResponseWriter, r *http.Request) {
	var s Search

	err := json.NewDecoder(r.Body).Decode(&s)
	if err != nil {
		w.WriteHeader(http.StatusBadRequest)
		w.Write([]byte("500 - Something bad happened!"))
		return
	}
	o := "Search string: " + s.Text
	w.Write([]byte(o))
}

func handleRequests() {
	http.HandleFunc("/service/ping", ping)
	http.HandleFunc("/error", error)
	http.HandleFunc("/search", error)
	http.HandleFunc("/", home)
	log.Fatal(http.ListenAndServe(":5000", nil))
}

func main() {
	handleRequests()
}
