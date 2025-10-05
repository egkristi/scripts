package main

import (
	"embed"
	"io/fs"
	"log"
	"net/http"
	"net/url"
	"path"
	"strings"
	"time"
)

//go:embed site/*
var embeddedFS embed.FS

func main() {
	// Strip the "site" prefix from embedded paths so URLs match "/"
	sub, err := fs.Sub(embeddedFS, "site")
	if err != nil {
		log.Fatal(err)
	}
	static := http.FS(sub)
	fileServer := http.FileServer(static)

	handler := http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		// Basic cache for common asset paths
		if strings.HasPrefix(r.URL.Path, "/assets/") || hasCacheableExt(r.URL.Path) {
			w.Header().Set("Cache-Control", "public, max-age=31536000, immutable")
		}
		// Try to serve the requested file
		f, err := sub.Open(strings.TrimPrefix(path.Clean(r.URL.Path), "/"))
		if err == nil {
			f.Close()
			fileServer.ServeHTTP(w, r)
			return
		}
		// SPA fallback: serve index.html
		r2 := new(http.Request)
		*r2 = *r
		r2.URL = cloneURL(r.URL, "/index.html")
		fileServer.ServeHTTP(w, r2)
	})

	srv := &http.Server{
		Addr:              ":8080",
		Handler:           withSecurityHeaders(handler),
		ReadHeaderTimeout: 5 * time.Second,
	}

	log.Println("Serving on http://localhost:8080")
	log.Fatal(srv.ListenAndServe())
}

func hasCacheableExt(p string) bool {
	p = strings.ToLower(p)
	for _, ext := range []string{".js", ".css", ".png", ".jpg", ".jpeg", ".gif", ".svg", ".webp", ".ico", ".woff", ".woff2"} {
		if strings.HasSuffix(p, ext) {
			return true
		}
	}
	return false
}

func withSecurityHeaders(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("X-Content-Type-Options", "nosniff")
		w.Header().Set("Referrer-Policy", "strict-origin-when-cross-origin")
		w.Header().Set("X-Frame-Options", "SAMEORIGIN")
		// CSP that supports MkDocs Material with Mermaid, code highlighting, and inline scripts
		csp := "default-src 'self'; " +
			"script-src 'self' 'unsafe-inline' 'unsafe-eval'; " +
			"style-src 'self' 'unsafe-inline'; " +
			"img-src 'self' data: https:; " +
			"font-src 'self' data:; " +
			"connect-src 'self'; " +
			"frame-src 'self'; " +
			"worker-src 'self' blob:"
		w.Header().Set("Content-Security-Policy", csp)
		next.ServeHTTP(w, r)
	})
}

func cloneURL(u *url.URL, newPath string) *url.URL {
	u2 := *u
	u2.Path = newPath
	u2.RawPath = ""
	return &u2
}
