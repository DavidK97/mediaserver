package api

import (
	"errors"
	"fmt"
	"image"
	"image/jpeg"
	"image/png"
	"io"
	"io/ioutil"
	"log"
	"net/http"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
	"time"

	"github.com/liujiawm/graphics-go/graphics"

	db "github.com/DavidK97/mediaserver/database"
	m "github.com/DavidK97/mediaserver/models"
)

var img = []string{".jpg", ".jpeg", ".png", ".webp"}
var vid = []string{".mp4", ".webm"}
var gif = ".gif"

func (api *API) Synchronize(w http.ResponseWriter, r *http.Request) {
	log.Println("Synchronization started...")
	files, err := ioutil.ReadDir(os.Getenv("APP_INPUT_FOLDER"))
	if err != nil {
		respondWithError(w, http.StatusBadRequest, "Directory could not been read")
		return
	}

	for index, file := range files {
		log.Println("Processing " + file.Name())
		mime, err := getFileType(strings.ToLower(file.Name()))
		if err != nil {
			respondWithError(w, http.StatusBadRequest, err.Error())
			return
		}

		var suffix = getFileSuffix(strings.ToLower(file.Name()))

		var thumbSuffix string
		if mime == "Video" {
			thumbSuffix = ".jpg"
		} else {
			thumbSuffix = suffix
		}

		var filename = generateUniqueFilename("FILE_", suffix, index)
		var thumbnail = generateUniqueFilename("THUMB_", thumbSuffix, index)

		var path = filepath.Join(os.Getenv("APP_OUTPUT_FOLDER"), mime)

		err = os.MkdirAll(path, os.ModePerm)
		err = os.MkdirAll(filepath.Join(path, ".thumbnails"), os.ModePerm)

		if err != nil {
			log.Fatalf("Error creating dirs")
		}

		var pathToFile = filepath.Join(path, filename)
		var pathToThumb = filepath.Join(path, ".thumbnails", thumbnail)

		var thumb string
		if mime == m.ANIMATION || suffix == img[3] {
			thumb = filename
		} else {
			thumb = thumbnail
		}

		var v m.MediaForInsert = m.MediaForInsert{Name: filename, Thumbnail: thumb, Type: mime, Favorite: false}
		log.Println("Saving file to DB...")
		if err := db.CreateMedia(v, api.DB); err != nil {
			respondWithError(w, http.StatusBadRequest, err.Error())
			return
		}
		log.Println("File saved to DB.")
		log.Println("Moving file to " + pathToFile)
		if err := os.Rename(filepath.Join(os.Getenv("APP_INPUT_FOLDER"), file.Name()), pathToFile); err != nil {
			respondWithError(w, http.StatusBadRequest, err.Error())
			return
		}
		log.Println("File moved.")
		log.Println("Creating thumbnail...")
		if mime == "Video" {
			err := createVideoThumbnail(pathToFile, pathToThumb)
			if err != nil {
				respondWithError(w, http.StatusBadRequest, err.Error())
				return
			}
		} else if mime == "Image" {
			err := createImageThumbnail(pathToFile, pathToThumb)
			if err != nil {
				respondWithError(w, http.StatusBadRequest, err.Error())
				return
			}
		}
		log.Println("Thumbnail created.")
		log.Println(filename + " successfully processed!")
	}

	log.Println("Synchronization finished!")

	respondWithJSON(w, http.StatusOK, map[string]string{"message": "success"})
}

func getFileType(name string) (string, error) {
	var mime string
	if strings.Contains(name, img[0]) ||
		strings.Contains(name, img[1]) ||
		strings.Contains(name, img[2]) ||
		strings.Contains(name, img[3]) {
		mime = m.IMAGE
	} else if strings.Contains(name, vid[0]) ||
		strings.Contains(name, vid[1]) {
		mime = m.VIDEO
	} else if strings.Contains(name, gif) {
		mime = m.ANIMATION
	} else {
		return "", errors.New("Unsupported Filetype")
	}
	return mime, nil
}

func getFileSuffix(name string) string {
	var suffix string
	if strings.Contains(name, img[0]) {
		suffix = img[0]
	} else if strings.Contains(name, img[1]) {
		suffix = img[1]
	} else if strings.Contains(name, img[2]) {
		suffix = img[2]
	} else if strings.Contains(name, img[3]) {
		suffix = img[3]
	} else if strings.Contains(name, vid[0]) {
		suffix = vid[0]
	} else if strings.Contains(name, vid[1]) {
		suffix = vid[1]
	} else if strings.Contains(name, gif) {
		suffix = gif
	}
	return suffix
}

func generateUniqueFilename(prefix, suffix string, count int) string {
	return (prefix + time.Now().Format("20060102150405") + "_N" + fmt.Sprintf("%06d", count) + suffix)
}

func createImageThumbnail(path, pathToThumb string) error {
	file, err := os.Open(path)
	if err != nil {
		return err
	}

	defer file.Close()

	if getFileSuffix(file.Name()) == img[3] {
		newImage, err := os.Create(pathToThumb)
		if err != nil {
			return err
		}
		defer newImage.Close()
		_, err = io.Copy(newImage, file)
		return err
	}

	srcImage, _, err := image.Decode(file)
	if err != nil {
		return err
	}

	height := float64(srcImage.Bounds().Dy()) * (400.0 / float64(srcImage.Bounds().Dx()))
	dstImage := image.NewRGBA(image.Rect(0, 0, 400, int(height)))
	graphics.Thumbnail(dstImage, srcImage)

	newImage, err := os.Create(pathToThumb)
	if err != nil {
		return err
	}
	defer newImage.Close()

	if strings.Contains(path, img[2]) {
		return png.Encode(newImage, dstImage)
	} else {
		return jpeg.Encode(newImage, dstImage, &jpeg.Options{Quality: jpeg.DefaultQuality})
	}
}

func createVideoThumbnail(path, pathToThumb string) error {
	ffCmd := exec.Command("ffmpeg", "-i", path, "-vf", "thumbnail,scale=400:-1", "-frames:v", "1", pathToThumb)

	_, err := ffCmd.CombinedOutput()

	return err
}
