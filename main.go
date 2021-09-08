package main

import (
	"log"
	"net/smtp"
	"time"
	"os"
)

func main() {

	send("Sucessfully")

}

func send(body string) {
	from :=  os.Getenv("SENDER_EMAIL")
	pass :=  os.Getenv("PASSWORD")
	to :=  os.Getenv("RECEIVER_EMAIL")

	currentTime := time.Now()

	msg := "From: " + from + "\n" +
		"To: " + to + "\n" +
		"Subject: DAILY BACKUP \n\n" +
		"Backup process completed at " +
		currentTime.Format("2006.01.02 15:04:05") + ". And the Backup is successfully synced with S3"

	err := smtp.SendMail("smtp.gmail.com:587",
		smtp.PlainAuth("", from, pass, "smtp.gmail.com"),
		from, []string{to}, []byte(msg))

	if err != nil {
		log.Printf("smtp error: %s", err)
		return
	}

	log.Print("sent.")
}
