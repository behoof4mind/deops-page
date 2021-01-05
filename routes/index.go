package routes

import (
	"github.com/kataras/iris/v12"
)

// GetIndexHandler handles the GET: /
func GetIndexHandler(ctx iris.Context) {
	ctx.ViewData("Title", "Engineer")
	ctx.View("index.html")
}
