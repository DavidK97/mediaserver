package api

import (
	"database/sql"
	"encoding/json"
	"log"
	"net/http"
	"os"
	"strconv"

	db "github.com/DavidK97/mediaserver/database"
	m "github.com/DavidK97/mediaserver/models"

	"github.com/gorilla/mux"
)

func (api *API) FindMedia(w http.ResponseWriter, r *http.Request) {
	var request m.Request

	decoder := json.NewDecoder(r.Body)
	if err := decoder.Decode(&request); err != nil {
		respondWithError(w, http.StatusBadRequest, "Invalid request payload")
	}
	defer r.Body.Close()

	media, err := db.FindMedia(request.ID, api.DB)
	if err != nil {
		switch err {
		case sql.ErrNoRows:
			respondWithError(w, http.StatusNotFound, "Product not found")
		default:
			respondWithError(w, http.StatusInternalServerError, err.Error())
		}
		return
	}

	respondWithJSON(w, http.StatusOK, media)
}

func (api *API) ServeMediaFile(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)

	id, err := strconv.Atoi(vars["id"])
	if err != nil {
		respondWithError(w, http.StatusBadRequest, err.Error())
	}

	media, err := db.FindMedia(id, api.DB)
	if err != nil {
		switch err {
		case sql.ErrNoRows:
			respondWithError(w, http.StatusNotFound, "Product not found")
		default:
			respondWithError(w, http.StatusInternalServerError, err.Error())
		}
		return
	}

	http.ServeFile(w, r, PathToFile(media))
}

func (api *API) ServeMediaThumbnail(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)

	id, err := strconv.Atoi(vars["id"])
	if err != nil {
		respondWithError(w, http.StatusBadRequest, err.Error())
	}

	media, err := db.FindMedia(id, api.DB)
	if err != nil {
		switch err {
		case sql.ErrNoRows:
			respondWithError(w, http.StatusNotFound, "Product not found")
		default:
			respondWithError(w, http.StatusInternalServerError, err.Error())
		}
		return
	}

	http.ServeFile(w, r, PathToThumbnail(media))
}

func (api *API) AllMedia(w http.ResponseWriter, r *http.Request) {
	media, err := db.AllMedia(api.DB)
	if err != nil {
		respondWithError(w, http.StatusInternalServerError, err.Error())
		return
	}

	respondWithJSON(w, http.StatusOK, media)
}

func (api *API) CreateMedia(w http.ResponseWriter, r *http.Request) {
	var media m.MediaForInsert
	decoder := json.NewDecoder(r.Body)
	if err := decoder.Decode(&media); err != nil {
		respondWithError(w, http.StatusBadRequest, "Invalid request payload")
		return
	}
	defer r.Body.Close()

	if err := db.CreateMedia(media, api.DB); err != nil {
		respondWithError(w, http.StatusInternalServerError, err.Error())
		return
	}

	respondWithJSON(w, http.StatusOK, media)
}

func (api *API) UpdateMedia(w http.ResponseWriter, r *http.Request) {
	var media m.Media
	decoder := json.NewDecoder(r.Body)
	if err := decoder.Decode(&media); err != nil {
		log.Println(err.Error())
		respondWithError(w, http.StatusBadRequest, "Invalid request payload")
		return
	}
	defer r.Body.Close()

	if err := db.UpdateMedia(media, api.DB); err != nil {
		respondWithError(w, http.StatusInternalServerError, err.Error())
		return
	}

	respondWithJSON(w, http.StatusOK, media)
}

func (api *API) DeleteMedia(w http.ResponseWriter, r *http.Request) {
	var media m.Media
	decoder := json.NewDecoder(r.Body)
	if err := decoder.Decode(&media); err != nil {
		respondWithError(w, http.StatusBadRequest, "Invalid request payload")
		return
	}
	defer r.Body.Close()

	e := os.Remove(PathToFile(media))
	if e != nil {
		respondWithError(w, http.StatusInternalServerError, e.Error())
		return
	}

	if media.Type != m.ANIMATION {
		e = os.Remove(PathToThumbnail(media))
		if e != nil {
			respondWithError(w, http.StatusInternalServerError, e.Error())
			return
		}
	}

	if e = db.Delete(db.MEDIA, strconv.Itoa(media.ID), api.DB); e != nil {
		respondWithError(w, http.StatusInternalServerError, e.Error())
		return
	}

	respondWithJSON(w, http.StatusOK, map[string]string{"message": "success"})
}

func (api *API) AddTagToMedia(w http.ResponseWriter, r *http.Request) {
	var request m.Request
	decoder := json.NewDecoder(r.Body)
	if err := decoder.Decode(&request); err != nil {
		respondWithError(w, http.StatusBadRequest, "Invalid request payload")
		return
	}
	defer r.Body.Close()

	if err := db.AddTagToMedia(request, api.DB); err != nil {
		respondWithError(w, http.StatusInternalServerError, err.Error())
		return
	}

	respondWithJSON(w, http.StatusOK, map[string]string{"message": "success"})
}

func (api *API) RemoveTagFromMedia(w http.ResponseWriter, r *http.Request) {
	var request m.Request
	decoder := json.NewDecoder(r.Body)
	if err := decoder.Decode(&request); err != nil {
		respondWithError(w, http.StatusBadRequest, "Invalid request payload")
		return
	}
	defer r.Body.Close()

	if err := db.RemoveTagFromMedia(request, api.DB); err != nil {
		respondWithError(w, http.StatusInternalServerError, err.Error())
		return
	}

	respondWithJSON(w, http.StatusOK, map[string]string{"message": "success"})
}

func (api *API) AddMediaToAlbum(w http.ResponseWriter, r *http.Request) {
	var request m.Request
	decoder := json.NewDecoder(r.Body)
	if err := decoder.Decode(&request); err != nil {
		respondWithError(w, http.StatusBadRequest, "Invalid request payload")
		return
	}
	defer r.Body.Close()

	if err := db.AddMediaToAlbum(request, api.DB); err != nil {
		respondWithError(w, http.StatusInternalServerError, err.Error())
		return
	}

	respondWithJSON(w, http.StatusOK, map[string]string{"message": "success"})
}

func (api *API) RemoveMediaFromAlbum(w http.ResponseWriter, r *http.Request) {
	var request m.Request
	decoder := json.NewDecoder(r.Body)
	if err := decoder.Decode(&request); err != nil {
		respondWithError(w, http.StatusBadRequest, "Invalid request payload")
		return
	}
	defer r.Body.Close()

	if err := db.RemoveMediaFromAlbum(request, api.DB); err != nil {
		respondWithError(w, http.StatusInternalServerError, err.Error())
		return
	}

	respondWithJSON(w, http.StatusOK, map[string]string{"message": "success"})
}

func (api *API) FilterMedia(w http.ResponseWriter, r *http.Request) {
	var filter db.Filters
	decoder := json.NewDecoder(r.Body)
	if err := decoder.Decode(&filter); err != nil {
		respondWithError(w, http.StatusBadRequest, "Invalid request payload")
		return
	}
	defer r.Body.Close()

	media, err := db.FilterMedia(filter, api.DB)
	if err != nil {
		respondWithError(w, http.StatusBadRequest, err.Error())
	}

	respondWithJSON(w, http.StatusOK, media)
}
