package routes

import (
	"devops-page/bootstrap"
)

// Configure registers the necessary routes to the app.
func Configure(b *bootstrap.Bootstrapper) {
	b.Get("/", GetIndexHandler)
	b.Get("/api/v1/topics", APIGetTopics)
	//b.Get("/following/{id:int64}", GetFollowingHandler)
	//b.Get("/like/{id:int64}", GetLikeHandler)
}
