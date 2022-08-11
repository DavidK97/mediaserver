package database

import (
	"database/sql"

	m "github.com/DavidK97/mediaserver/models"
)

func AllAlbumInfos(db *sql.DB) ([]m.AlbumInfos, error) {
	var albumInfo []m.AlbumInfos
	rows, err := db.Query("SELECT a.name, (SELECT m.media_id FROM media_of_album m WHERE m.album = a.name LIMIT 1), COUNT(ma.album) FROM public.album a, public.media_of_album ma WHERE a.name = ma.album GROUP BY a.name")

	if err != nil {
		return albumInfo, err
	}

	defer rows.Close()

	for rows.Next() {
		var info m.AlbumInfos
		if err := rows.Scan(&info.Name, &info.Preview, &info.Count); err != nil {
			return albumInfo, err
		}

		albumInfo = append(albumInfo, info)
	}

	return albumInfo, nil
}
