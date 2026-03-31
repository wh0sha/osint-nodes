package main

import (
	"fmt"
	"io"
	"net/http"
)

func FetchPage(url string) {
	resp, err := http.Get(url)
	if err != nil {
		fmt.Println("ошибка подключения: ", err)
		return
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		fmt.Println("сайт ответил ошибкой: ", resp.Status)
		return
	}
	body, err := io.ReadAll(resp.Body)
	if err != nil {
		fmt.Println("ошибка при чтении", err)
		return
	}
	fmt.Printf("данные: %s\n", string(body))

}

func main() {
	url := "https://example.com"
	FetchPage(url)
}
