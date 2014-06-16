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
    "encoding/json"
    "io/ioutil"
	"time"
)

type Invoice struct {
    Number           string
    Date             time.Time

	ClientName       string
	ClientContact    string
	ClientStreet     string
	ClientCity       string
	ClientProvince   string
	ClientPostal     string

    Note             string

    LineItems        []*Item
    Payments         []*Payment
}

type Item struct {
    Description  string
    Rate    int // In pennies - Fixed point is so much better for this.
    Quantity int
	TaxRate int // ie 5 for 5%
}

type Payment struct {
	Amount int
	Date time.Time
}

// Return the total amount (not including tax) for the line item (ie rate * quantity)
func (item *Item) Amount() int {
	return item.Rate * item.Quantity
}

func (invoice *Invoice) TotalDue() int {
	return invoice.SubTotalDue() + invoice.TaxDue()
}

func (invoice *Invoice) SubTotalDue() int {
	var sum = 0

    for _, item := range invoice.LineItems {
        sum += item.Amount()
    }

	return sum
}

func (invoice *Invoice) TaxDue() int {
	var sum = 0

    for _, item := range invoice.LineItems {
		if item.TaxRate > 0 {
			sum += item.Amount() * item.TaxRate
		}
    }

	// Convert to percentage the final amount at the end, 
	// less rounding errors this way.
	return sum / 100 
}

func (invoice *Invoice) HasPayments() bool {
	return len(invoice.Payments) > 0
}

func (invoice *Invoice) TotalPayments() int {
	var sum = 0

    for _,item := range invoice.Payments {
        sum += item.Amount
    }

	return sum
}

func (invoice *Invoice) NetAmountDue() int {
	return invoice.TotalDue() - invoice.TotalPayments()
}

func LoadInvoice(filename string) *Invoice  {
	file, e := ioutil.ReadFile(filename)
    if e != nil {
        fmt.Printf("File error: %v\n", e)
        os.Exit(1)
    }

    var invoice Invoice
    json.Unmarshal(file, &invoice)

	return &invoice
}
