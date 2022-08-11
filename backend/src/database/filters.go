package database

import (
	"fmt"
	"strconv"
	"strings"
)

type Filters struct {
	Albums   []string `json:"albums"`
	Creators []string `json:"creators"`
	Favorite bool     `json:"favorite"`
	Tags     []string `json:"tags"`
}

func createFilterQuery(filters Filters) string {
	query := []string{"SELECT", "m.id", ",", "m.type", "FROM", "media", "m"}

	if len(filters.Albums) > 0 {
		query = append(query, ",media_of_album", "ma")
	}
	if len(filters.Tags) > 0 {
		query = append(query, ",media_of_tag", "mt")
	}
	if len(filters.Creators) > 0 {
		query = append(query, ",media_of_creator", "mc")
	}

	query = append(query, "WHERE")

	if len(filters.Albums) > 0 {
		query = append(query, "ma.album", "IN", generateInQueryItem(filters.Albums))
		query = append(query, "AND", "ma.media_id=m.id")
	}
	if len(filters.Tags) > 0 {
		if len(filters.Albums) > 0 {
			query = append(query, "AND")
		}
		query = append(query, "mt.tag", "IN", generateInQueryItem(filters.Tags))
		query = append(query, "AND", "mt.media_id=m.id")
	}
	if len(filters.Creators) > 0 {
		if len(filters.Albums) > 0 || len(filters.Tags) > 0 {
			query = append(query, "AND")
		}
		query = append(query, "mc.creator", "IN", generateInQueryItem(filters.Creators))
		query = append(query, "AND", "mc.media_id=m.id")
	}
	if filters.Favorite {
		if len(filters.Albums) > 0 || len(filters.Tags) > 0 || len(filters.Creators) > 0 {
			query = append(query, "AND")
		}
		query = append(query, "m.favorite=TRUE")
	}
	query = append(query, "GROUP", "BY", "m.id")

	count := 0
	if len(filters.Tags) > 0 {
		count = len(filters.Tags)
	}
	if len(filters.Albums) > 0 {
		if count > 0 {
			count *= len(filters.Albums)
		} else {
			count = len(filters.Albums)
		}
	}
	if len(filters.Creators) > 0 {
		if count > 0 {
			count *= len(filters.Creators)
		} else {
			count = len(filters.Creators)
		}
	}

	if count > 0 {
		query = append(query, "HAVING", "COUNT(m.id)=", strconv.Itoa(count))
	}

	return strings.Join(query, " ")
}

func setInQuotation(s string) string {
	return fmt.Sprintf("'%s'", s)
}

func generateInQueryItem(s []string) string {
	in := []string{"("}
	for i, t := range s {
		if i > 0 {
			in = append(in, ",")
		}
		in = append(in, "'", t, "'")
	}
	in = append(in, ")")
	return strings.Join(in, "")
}
