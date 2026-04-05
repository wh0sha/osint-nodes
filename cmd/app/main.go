// cmd/app/main.go
package main

import (
	"context"
	"fmt"
	"log"
	"os"

	"osint_project/internal/storage" // ← ЗАМЕНИ на свой модуль! Смотри go.mod

	"github.com/joho/godotenv"
)

func main() {
	// 1. Загружаем переменные из .env
	if err := godotenv.Load(); err != nil {
		log.Println("⚠️ .env не найден, используем системные переменные")
	}

	// 2. Собираем строку подключения
	connString := fmt.Sprintf(
		"postgres://%s:%s@%s:%s/%s?sslmode=disable",
		os.Getenv("DB_USER"),
		os.Getenv("DB_PASSWORD"),
		os.Getenv("DB_HOST"),
		os.Getenv("DB_PORT"),
		os.Getenv("DB_NAME"),
	)

	// 3. Создаём контекст и подключаемся к БД
	ctx := context.Background()
	db, err := storage.New(ctx, connString)
	if err != nil {
		log.Fatal("❌ Не подключился к БД: ", err)
	}
	defer db.Close()

	// 4. Если всё ок — празднуем!
	fmt.Println("✅ Подключено к БД!")

	// 5. (Опционально) Проверим, что пул работает
	// var count int
	// err = db.Pool.QueryRow(ctx, "SELECT COUNT(*) FROM sources").Scan(&count)
	// if err != nil {
	// 	log.Fatal("❌ Ошибка запроса: ", err)
	// }
	// fmt.Printf("📊 В таблице sources: %d записей\n", count)
}
