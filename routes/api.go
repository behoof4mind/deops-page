package routes

import (
	"devops-page/api/v1/topics"
	"github.com/kataras/iris/v12"
	"strconv"
)

// GetIndexHandler handles the GET: /
func APIGetTopics(ctx iris.Context) {
	result := topics.GetListOfTopics()
	ctx.WriteString(strconv.Itoa(result.TotalNumber))
}
