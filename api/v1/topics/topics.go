package topics

type GetListOfTopicsResp struct {
	TotalNumber int `json:"total_number"`
}

func GetListOfTopics() (l GetListOfTopicsResp) {
	var resp GetListOfTopicsResp
	resp.TotalNumber = 3
	return resp
}
