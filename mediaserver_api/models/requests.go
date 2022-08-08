package models

type Request struct {
	ID      int    `json:"id"`
	Name    string `json:"name"`
	OldName string `json:"old_name"`
	Payload string `json:"payload"`
	Count   int    `json:"count"`
	Start   int    `json:"start"`
}

const (
	VIDEO     = "Video"
	IMAGE     = "Image"
	ANIMATION = "Animation"
)
