package api

import (
	"encoding/json"
	"log"
	"net/http"

	db "mediaserver/database"
	m "mediaserver/models"
)

func (api *API) AllTags(w http.ResponseWriter, r *http.Request) {
	tags, err := db.AllOf(db.TAG, api.DB)
	if err != nil {
		respondWithError(w, http.StatusInternalServerError, err.Error())
		return
	}

	respondWithJSON(w, http.StatusOK, tags)
}

func (api *API) CreateTag(w http.ResponseWriter, r *http.Request) {
	var request m.Request
	decoder := json.NewDecoder(r.Body)
	if err := decoder.Decode(&request); err != nil {
		respondWithError(w, http.StatusBadRequest, "Invalid request payload")
		return
	}
	defer r.Body.Close()

	if err := db.Create(db.TAG, request.Name, api.DB); err != nil {
		respondWithError(w, http.StatusInternalServerError, err.Error())
		return
	}

	respondWithJSON(w, http.StatusOK, map[string]string{"message": "success"})
}

func (api *API) UpdateTag(w http.ResponseWriter, r *http.Request) {
	var request m.Request
	decoder := json.NewDecoder(r.Body)
	if err := decoder.Decode(&request); err != nil {
		log.Println(err.Error())
		respondWithError(w, http.StatusBadRequest, "Invalid request payload")
		return
	}
	defer r.Body.Close()

	if err := db.Update(db.TAG, request.Name, request.OldName, api.DB); err != nil {
		respondWithError(w, http.StatusInternalServerError, err.Error())
		return
	}

	respondWithJSON(w, http.StatusOK, map[string]string{"message": "success"})
}

func (api *API) DeleteTag(w http.ResponseWriter, r *http.Request) {
	var request m.Request
	decoder := json.NewDecoder(r.Body)
	if err := decoder.Decode(&request); err != nil {
		respondWithError(w, http.StatusBadRequest, "Invalid request payload")
		return
	}
	defer r.Body.Close()

	if err := db.Delete(db.TAG, request.Name, api.DB); err != nil {
		respondWithError(w, http.StatusInternalServerError, err.Error())
		return
	}

	respondWithJSON(w, http.StatusOK, map[string]string{"message": "success"})
}
