package main

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"os"
	"time"
)

// SecretResponse defines the JSON structure for the response
type SecretResponse struct {
	SecretValue string `json:"secret_value"`
	Message     string `json:"message"`
}

func getSecretHandler(w http.ResponseWriter, r *http.Request) {
	start := time.Now()
	// Log entry
	fmt.Printf("Received %s request for %s from %s\n", r.Method, r.URL.Path, r.RemoteAddr)

	defer func() {
		// Log exit
		fmt.Printf("Completed %s %s from %s in %v\n", r.Method, r.URL.Path, r.RemoteAddr, time.Since(start))
	}()

	secret := os.Getenv("MY_SECRET")
	if secret == "" {
		secret = "Secret not found"
	}

	response := SecretResponse{
		SecretValue: secret,
		Message:     "Hello from TechFlow Challenge! Secret retrieved successfully (Go).",
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(response)
}

func main() {
	// Ensure logs go to stdout which is standard for container logging
	log.SetOutput(os.Stdout)
	
	http.HandleFunc("/", getSecretHandler)

	port := "8000"
	fmt.Printf("Server starting on port %s...\n", port)
	if err := http.ListenAndServe(":"+port, nil); err != nil {
		log.Fatal(err)
	}
}
