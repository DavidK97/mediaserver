package api

import (
	"encoding/json"
	"log"
	"net/http"

	db "github.com/DavidK97/mediaserver/database"
	m "github.com/DavidK97/mediaserver/models"
)

func (api *API) AllAlbums(w http.ResponseWriter, r *http.Request) {
	albums, err := db.AllOf(db.ALBUM, api.DB)
	if err != nil {
		respondWithError(w, http.StatusInternalServerError, err.Error())
		return
	}

	respondWithJSON(w, http.StatusOK, albums)
}

func (api *API) AllAlbumInfos(w http.ResponseWriter, r *http.Request) {
	albums, err := db.AllAlbumInfos(api.DB)
	if err != nil {
		respondWithError(w, http.StatusInternalServerError, err.Error())
		return
	}

	respondWithJSON(w, http.StatusOK, albums)
}

func (api *API) CreateAlbum(w http.ResponseWriter, r *http.Request) {
	var request m.Request
	decoder := json.NewDecoder(r.Body)
	if err := decoder.Decode(&request); err != nil {
		respondWithError(w, http.StatusBadRequest, "Invalid request payload")
		return
	}
	defer r.Body.Close()

	if err := db.Create(db.ALBUM, request.Name, api.DB); err != nil {
		respondWithError(w, http.StatusInternalServerError, err.Error())
		return
	}

	respondWithJSON(w, http.StatusCreated, map[string]string{"message": "success"})
}

func (api *API) UpdateAlbum(w http.ResponseWriter, r *http.Request) {
	var request m.Request
	decoder := json.NewDecoder(r.Body)
	if err := decoder.Decode(&request); err != nil {
		log.Println(err.Error())
		respondWithError(w, http.StatusBadRequest, "Invalid request payload")
		return
	}
	defer r.Body.Close()

	if err := db.Update(db.ALBUM, request.Name, request.OldName, api.DB); err != nil {
		respondWithError(w, http.StatusInternalServerError, err.Error())
		return
	}

	respondWithJSON(w, http.StatusOK, map[string]string{"message": "success"})
}

func (api *API) DeleteAlbum(w http.ResponseWriter, r *http.Request) {
	var request m.Request
	decoder := json.NewDecoder(r.Body)
	if err := decoder.Decode(&request); err != nil {
		respondWithError(w, http.StatusBadRequest, "Invalid request payload")
		return
	}
	defer r.Body.Close()

	if err := db.Delete(db.ALBUM, request.Name, api.DB); err != nil {
		respondWithError(w, http.StatusInternalServerError, err.Error())
		return
	}

	respondWithJSON(w, http.StatusOK, map[string]string{"message": "success"})
}
