package database

import (
	"database/sql"
	"fmt"
)

type Default struct {
	Name string `json:"name"`
}

func AllOf(table string, db *sql.DB) ([]string, error) {
	rows, err := db.Query("SELECT * FROM " + table)
	if err != nil {
		return nil, err
	}

	defer rows.Close()

	data := []string{}

	for rows.Next() {
		var name Default
		if err := rows.Scan(&name.Name); err != nil {
			return nil, err
		}
		data = append(data, name.Name)
	}
	return data, nil
}

func Delete(table, id string, db *sql.DB) error {
	switch table {
	case MEDIA:
		if _, err := db.Exec("DELETE FROM media_to_tags WHERE media_id=$1", id); err != nil {
			return err
		}
		if _, err := db.Exec("DELETE FROM media_to_albums WHERE media_id=$1", id); err != nil {
			return err
		}
		break
	case TAG:
		if _, err := db.Exec("DELETE FROM media_to_tags WHERE tag=$1", id); err != nil {
			return err
		}
		break
	case ALBUM:
		if _, err := db.Exec("DELETE FROM media_to_albums WHERE album=$1", id); err != nil {
			return err
		}
		break
	case CREATOR:
		if _, err := db.Exec("UPDATE media SET creator='Unknown' WHERE creator=$1", id); err != nil {
			return err
		}
		break
	}

	query := fmt.Sprintf("DELETE FROM %s WHERE %s='%s'", table, getTablePK(table), id)
	_, err := db.Exec(query)
	return err
}

func Create(table, name string, db *sql.DB) error {
	query := fmt.Sprintf("INSERT INTO %s VALUES ('%s')", table, name)
	_, err := db.Exec(query)

	return err
}

func Update(table, name, oldName string, db *sql.DB) error {
	query := fmt.Sprintf("UPDATE %s SET name = '%s' WHERE name = '%s'", table, name, oldName)
	_, err := db.Exec(query)

	switch table {
	case TAG:
		if _, err := db.Exec("UPDATE media_to_tags SET tag=$1 WHERE tag=$2", name, oldName); err != nil {
			return err
		}
		break
	case ALBUM:
		if _, err := db.Exec("UPDATE media_to_albums SET album=$1 WHERE album=$2", name, oldName); err != nil {
			return err
		}
		break
	case CREATOR:
		if _, err := db.Exec("UPDATE media SET creator=$1 WHERE creator=$2", name, oldName); err != nil {
			return err
		}
		break
	}

	return err
}

func getTablePK(table string) string {
	if table == MEDIA {
		return "id"
	} else {
		return "name"
	}
}
