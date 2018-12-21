package main

import (
	"bytes"
	"context"
	"fmt"
	"io/ioutil"

	"github.com/pquerna/otp"

	"image/png"

	"docker.io/go-docker"
	"docker.io/go-docker/api/types"
	"github.com/gin-contrib/sessions"
	"github.com/gin-contrib/sessions/cookie"
	"github.com/gin-gonic/gin"
	"github.com/pquerna/otp/totp"
)

func main() {

	r := gin.Default()
	store := cookie.NewStore([]byte("secret"))
	r.Use(sessions.Sessions("mysession", store))

	r.GET("/qr", func(c *gin.Context) {
		key, _ := totp.Generate(totp.GenerateOpts{
			AccountName: "bar",
			Issuer:      "foo.dueckminor.de",
			SecretSize:  64,
			Algorithm:   otp.AlgorithmSHA512,
		})
		fmt.Println(key.Secret())
		image, _ := key.Image(256, 256)
		buf := new(bytes.Buffer)
		png.Encode(buf, image)
		c.Data(200, "image/png", buf.Bytes())
	})
	r.Run() // listen and serve on 0.0.0.0:8080

	dat, err := ioutil.ReadFile("config/mypi.json")
	fmt.Print(string(dat))

	cli, err := docker.NewEnvClient()
	if err != nil {
		panic(err)
	}

	containers, err := cli.ContainerList(context.Background(), types.ContainerListOptions{})
	if err != nil {
		panic(err)
	}

	for _, container := range containers {
		fmt.Printf("%s %s\n", container.ID[:10], container.Image)
	}
}
