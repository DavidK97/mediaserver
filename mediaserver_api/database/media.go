package database

import (
	"database/sql"
	m "mediaserver/models"
)

func FindMedia(id int, db *sql.DB) (m.Media, error) {
	var media m.Media
	err := db.QueryRow("SELECT * FROM media WHERE id=$1",
		id).Scan(&media.ID, &media.Name, &media.Thumbnail, &media.Type, &media.Creator, &media.Favorite)

	if err != nil {
		return media, err
	}

	rows, err := db.Query("SELECT tag FROM media_to_tags WHERE media_id = $1", id)

	if err != nil {
		return media, err
	}

	defer rows.Close()

	media.Tags = []string{}

	for rows.Next() {
		var tag string
		if err := rows.Scan(&tag); err != nil {
			return media, err
		}

		media.Tags = append(media.Tags, tag)
	}

	rows, err = db.Query("SELECT album FROM media_to_album WHERE media_id = $1", id)

	if err != nil {
		return media, err
	}

	defer rows.Close()

	media.Albums = []string{}

	for rows.Next() {
		var album string
		if err := rows.Scan(&album); err != nil {
			return media, err
		}

		media.Albums = append(media.Albums, album)
	}

	return media, nil
}

func AllMedia(db *sql.DB) ([]m.MediaIdAndType, error) {
	rows, err := db.Query("SELECT id, type FROM media ORDER BY id DESC")

	if err != nil {
		return nil, err
	}

	defer rows.Close()

	data := []m.MediaIdAndType{}

	for rows.Next() {
		var v m.MediaIdAndType
		if err := rows.Scan(&v.ID, &v.Type); err != nil {
			return nil, err
		}
		data = append(data, v)
	}

	return data, nil
}

func FilterMedia(filters Filters, db *sql.DB) ([]m.MediaIdAndType, error) {
	query := createFilterQuery(filters)
	rows, err := db.Query(query)

	if err != nil {
		return nil, err
	}

	defer rows.Close()

	data := []m.MediaIdAndType{}

	for rows.Next() {
		var v m.MediaIdAndType
		if err := rows.Scan(&v.ID, &v.Type); err != nil {
			return nil, err
		}
		data = append(data, v)
	}

	return data, nil
}

func CreateMedia(media m.MediaForInsert, db *sql.DB) error {
	_, err := db.Exec(
		"INSERT INTO media (name, thumbnail, type, creator, favorite) VALUES($1, $2, $3, $4, $5)",
		media.Name,
		media.Thumbnail,
		media.Type,
		media.Creator,
		media.Favorite)

	return err
}

func UpdateMedia(media m.Media, db *sql.DB) error {
	_, err := db.Exec("UPDATE media SET name = $2, thumbnail = $3, type = $4, creator = $5, favorite = $6 WHERE id = $1",
		media.ID,
		media.Name,
		media.Thumbnail,
		media.Type,
		media.Creator,
		media.Favorite)

	return err
}

func AddTagToMedia(request m.Request, db *sql.DB) error {
	_, err := db.Exec(
		"INSERT INTO media_to_tags VALUES($1, $2)",
		request.ID,
		request.Name)

	return err
}

func RemoveTagFromMedia(request m.Request, db *sql.DB) error {
	_, err := db.Exec(
		"DELETE FROM media_to_tags WHERE tag=$1",
		request.Name)

	return err
}

func AddMediaToAlbum(request m.Request, db *sql.DB) error {
	_, err := db.Exec(
		"INSERT INTO media_to_album VALUES($1, $2)",
		request.ID,
		request.Name)

	return err
}

func RemoveMediaFromAlbum(request m.Request, db *sql.DB) error {
	_, err := db.Exec(
		"DELETE FROM media_to_album WHERE album=$1",
		request.Name)

	return err
}
