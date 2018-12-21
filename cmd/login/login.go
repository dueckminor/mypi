package main

import (
	"github.com/gin-gonic/gin"
)

type Resp struct {
	Cockie string
	Error  string
}

func main() {
	r := gin.Default()
	r.GET("/", func(c *gin.Context) {
		value, err := c.Cookie("mypi")
		errText := ""
		if err != nil {
			errText = err.Error()
		}
		if len(value) == 0 {
			c.SetCookie("mypi", "bar", 3600, "/", "localhost", false, false)
		} else {
			c.SetCookie("mypi", "", 0, "/", "localhost", false, false)
		}
		c.JSON(200, Resp{
			Cockie: value,
			Error:  errText,
		})
	})
	r.Run() // listen and serve on 0.0.0.0:8080
}
