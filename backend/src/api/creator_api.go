package api

import (
	"encoding/json"
	"log"
	"net/http"

	db "github.com/DavidK97/mediaserver/database"
	m "github.com/DavidK97/mediaserver/models"
)

func (api *API) AllCreators(w http.ResponseWriter, r *http.Request) {
	log.Println("Fetching Creators...")
	creators, err := db.AllOf(db.CREATOR, api.DB)
	if err != nil {
		respondWithError(w, http.StatusInternalServerError, err.Error())
		return
	}
	log.Println("Fetched Creators!")
	respondWithJSON(w, http.StatusOK, creators)
}

func (api *API) CreateCreator(w http.ResponseWriter, r *http.Request) {
	var request m.Request
	decoder := json.NewDecoder(r.Body)
	if err := decoder.Decode(&request); err != nil {
		respondWithError(w, http.StatusBadRequest, "Invalid request payload")
		return
	}
	defer r.Body.Close()

	if err := db.Create(db.CREATOR, request.Name, api.DB); err != nil {
		respondWithError(w, http.StatusInternalServerError, err.Error())
		return
	}

	respondWithJSON(w, http.StatusOK, map[string]string{"message": "success"})
}

func (api *API) UpdateCreator(w http.ResponseWriter, r *http.Request) {
	var request m.Request
	decoder := json.NewDecoder(r.Body)
	if err := decoder.Decode(&request); err != nil {
		log.Println(err.Error())
		respondWithError(w, http.StatusBadRequest, "Invalid request payload")
		return
	}
	defer r.Body.Close()

	if err := db.Update(db.CREATOR, request.Name, request.OldName, api.DB); err != nil {
		respondWithError(w, http.StatusInternalServerError, err.Error())
		return
	}

	respondWithJSON(w, http.StatusOK, map[string]string{"message": "success"})
}

func (api *API) DeleteCreator(w http.ResponseWriter, r *http.Request) {
	var request m.Request
	decoder := json.NewDecoder(r.Body)
	if err := decoder.Decode(&request); err != nil {
		respondWithError(w, http.StatusBadRequest, "Invalid request payload")
		return
	}
	defer r.Body.Close()

	if err := db.Delete(db.CREATOR, request.Name, api.DB); err != nil {
		respondWithError(w, http.StatusInternalServerError, err.Error())
		return
	}

	respondWithJSON(w, http.StatusOK, map[string]string{"message": "success"})
}
