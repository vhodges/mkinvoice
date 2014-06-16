/*
Copyright (c) 2014 Vince Hodges <vhodges@gmail.com>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/

package main

import (
	"fmt"
	"os"
	"time"
	"html/template"
	"bufio"
)

var usagePrefix = `Usage:
    mkinvoice template.tpl invoice.json 
`

func usage() {
	fmt.Print(usagePrefix)
}

func currency(amount int) string {
	dollars := amount / 100
	cents := amount % 100

	return fmt.Sprintf("%d.%02d", dollars, cents)
}

func formatdate(date time.Time) string {
	return date.Format("January 2, 2006")
}

func main() {

	args := os.Args
	if len(args) < 3 || args[1] == "-h" {
		usage()
		return
	}
	
	tmpl := args[1]
	json  := args[2]

	var invoice = LoadInvoice(json)
	var t = template.Must(template.New(tmpl).Funcs(template.FuncMap{"currency": currency, "formatdate": formatdate}).ParseFiles(tmpl))

	f, err := os.Create(invoice.Number + ".html")
	if err != nil {
		fmt.Printf("Error creating html file: %v", err)
		return
	}
	defer f.Close()

	w := bufio.NewWriter(f)
	t.Execute(w, invoice)
	w.Flush()
}
