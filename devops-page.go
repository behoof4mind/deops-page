package main

import (
	"devops-page/bootstrap"
	"devops-page/middleware/identity"
	"devops-page/routes"
)

func newApp() *bootstrap.Bootstrapper {
	app := bootstrap.New("Devops-page", "Denis Lavrushko")
	app.Bootstrap()
	app.Configure(identity.Configure, routes.Configure)
	return app
}

func main() {
	app := newApp()

	app.Listen("dlavrushko.de")
	// LetsEncrypt setup
	//mux := http.NewServeMux()
	//mux.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
	//	fmt.Fprint(w, "Hello HTTP/2")
	//})
	//
	//server := http.Server{
	//	Addr:    ":443",
	//	Handler: mux,
	//	TLSConfig: &tls.Config{
	//		NextProtos: []string{"h2", "http/1.1"},
	//	},
	//}
	//
	//fmt.Printf("Server listening on %s", server.Addr)
	//if err := server.ListenAndServeTLS("certs/fullchain.pem", "certs/privkey.pem"); err != nil {
	//	fmt.Println(err)
	//}
}
