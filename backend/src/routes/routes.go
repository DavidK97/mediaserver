package routes

import (
	"log"
	"net/http"
	"os"

	"github.com/DavidK97/mediaserver/api"

	"github.com/gorilla/mux"
	"github.com/joho/godotenv"
	_ "github.com/lib/pq"
)

type Routes struct {
	Router *mux.Router
	API    *api.API
}

func (routes *Routes) Initialize() {
	routes.Router = mux.NewRouter()
	err := godotenv.Load(".env")

	if err != nil {
		log.Fatalf("Error loading .env file")
	}

	routes.API = api.Init(
		os.Getenv("APP_DB_HOST"),
		os.Getenv("APP_DB_PORT"),
		os.Getenv("APP_DB_USERNAME"),
		os.Getenv("APP_DB_PASSWORD"),
		os.Getenv("APP_DB_NAME"))

	routes.initializeRoutes()
}

func (routes *Routes) Run(addr string) {
	log.Fatal(http.ListenAndServe(addr, routes.Router))
}

func (r *Routes) initializeRoutes() {
	log.Println("Init Routes...")
	r.Router.HandleFunc("/album", r.API.AllAlbums).Methods("GET")
	r.Router.HandleFunc("/album/info", r.API.AllAlbumInfos).Methods("GET")
	r.Router.HandleFunc("/album/add", r.API.CreateAlbum).Methods("POST")
	r.Router.HandleFunc("/album/remove", r.API.DeleteAlbum).Methods("POST")
	r.Router.HandleFunc("/album/update", r.API.UpdateAlbum).Methods("POST")

	r.Router.HandleFunc("/creator", r.API.AllCreators).Methods("GET")
	r.Router.HandleFunc("/creator/add", r.API.CreateCreator).Methods("POST")
	r.Router.HandleFunc("/creator/remove", r.API.DeleteCreator).Methods("POST")
	r.Router.HandleFunc("/creator/update", r.API.UpdateCreator).Methods("POST")

	r.Router.HandleFunc("/media", r.API.AllMedia).Methods("GET")
	r.Router.HandleFunc("/media", r.API.FindMedia).Methods("POST")
	r.Router.HandleFunc("/media/search", r.API.FilterMedia).Methods("POST")
	r.Router.HandleFunc("/media/update", r.API.UpdateMedia).Methods("POST")
	r.Router.HandleFunc("/media/tags/add", r.API.AddTagToMedia).Methods("POST")
	r.Router.HandleFunc("/media/tags/remove", r.API.RemoveTagFromMedia).Methods("POST")
	r.Router.HandleFunc("/media/albums/add", r.API.AddMediaToAlbum).Methods("POST")
	r.Router.HandleFunc("/media/albums/remove", r.API.RemoveMediaFromAlbum).Methods("POST")
	r.Router.HandleFunc("/media/add", r.API.CreateMedia).Methods("POST")
	r.Router.HandleFunc("/media/remove", r.API.DeleteMedia).Methods("POST")

	r.Router.HandleFunc("/tag", r.API.AllTags).Methods("GET")
	r.Router.HandleFunc("/tag/add", r.API.CreateTag).Methods("POST")
	r.Router.HandleFunc("/tag/remove", r.API.DeleteTag).Methods("POST")
	r.Router.HandleFunc("/tag/update", r.API.UpdateTag).Methods("POST")

	r.Router.HandleFunc("/synchronize", r.API.Synchronize).Methods("GET")

	r.Router.HandleFunc("/media/file/{id}", r.API.ServeMediaFile).Methods("GET")
	r.Router.HandleFunc("/media/thumb/{id}", r.API.ServeMediaThumbnail).Methods("GET")

	log.Println("Routes initialized!")
}
