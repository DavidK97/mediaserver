package models

type Media struct {
	ID        int      `json:"id"`
	Name      string   `json:"name"`
	Thumbnail string   `json:"thumbnail"`
	Type      string   `json:"type"`
	Favorite  bool     `json:"favorite"`
	Creators  []string `json:"creators"`
	Tags      []string `json:"tags"`
	Albums    []string `json:"albums"`
}

type MediaForInsert struct {
	Name      string `json:"name"`
	Thumbnail string `json:"thumbnail"`
	Type      string `json:"type"`
	Favorite  bool   `json:"favorite"`
}

type MediaIdAndType struct {
	ID   int    `json:"id"`
	Type string `json:"type"`
}
