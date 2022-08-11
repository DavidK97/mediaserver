package api

import (
	"database/sql"
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"os"
	"path/filepath"

	m "github.com/DavidK97/mediaserver/models"
)

type API struct {
	DB *sql.DB
}

func PathToThumbnail(media m.Media) string {
	if media.Type == m.ANIMATION {
		return filepath.Join(os.Getenv("APP_OUTPUT_FOLDER"), media.Type, media.Name)
	}

	return filepath.Join(os.Getenv("APP_OUTPUT_FOLDER"), media.Type, ".thumbnails", media.Thumbnail)
}

func PathToFile(media m.Media) string {
	return filepath.Join(os.Getenv("APP_OUTPUT_FOLDER"), media.Type, media.Name)
}

func respondWithError(w http.ResponseWriter, code int, message string) {
	respondWithJSON(w, code, map[string]string{"message": message})
}

func respondWithJSON(w http.ResponseWriter, code int, payload interface{}) {
	response, _ := json.Marshal(payload)

	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(code)
	w.Write(response)
}

func Init(host, port, user, password, database string) *API {
	connectionString := fmt.Sprintf("host=%s port=%s user=%s password=%s dbname=%s sslmode=disable", host, port, user, password, database)

	log.Println("Connecting to Database...")

	db, err := sql.Open("postgres", connectionString)
	if err != nil {
		log.Fatal(err)
	}

	log.Println("Connected to Database!")
	return &API{DB: db}
}
