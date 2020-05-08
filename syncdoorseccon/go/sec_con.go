package seccon

import (
	"html/template"
	"io/ioutil"
	"log"
	"net/http"
	"os"
	"strconv"
	"time"
)

var counts map[string]int = make(map[string]int)
var channelNames []string

func ProcessMessage(channel_name string, msg_content string) {
	// the function just counts the messages so message_content goes unused
	counts[channel_name]++
}

func SetUpSecConPubSub(redis_url string, interval time.Duration, wait time.Duration, channel_names []string) {

	channelNames = channel_names
	SetUpPubSub("security-console", redis_url, interval, wait, channel_names, ProcessMessage)
}

func GetTableInnerHTML() string {
	var innerHTML string = "<tr>"
	for _, name := range channelNames {
		innerHTML += "<th>" + name + "</th>"
	}
	innerHTML += "</tr><tr>"
	for _, name := range channelNames {
		innerHTML += "<th>" + strconv.Itoa(counts[name]) + "</th>"
	}
	innerHTML += "</tr>"
	return innerHTML
}

func Index(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "text/html; charset=utf-8")

	inserts := struct {
		TableInnerHTML template.HTML
	}{
		template.HTML(GetTableInnerHTML()),
	}
	t, _ := template.ParseFiles("console.html")

	t.Execute(w, inserts)
}

func GetSyncDoorCountFromURL(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "text/html; charset=utf-8")

	resp, err := http.Get(os.Args[1])
	if err != nil {
		log.Fatalln(err)
	}

	defer resp.Body.Close()

	body, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		log.Fatalln(err)

	}

	log.Println(string(body))
}
