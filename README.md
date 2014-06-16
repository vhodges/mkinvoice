## mkinvoice

A simple tool that reads invoice data from a json formatted file and generates a html invoice that can then be hosted, converted to PDF and sent to clients so you can get paid.  Why you might ask when there are *so* many SaaS options? I'm on a bit of an anti-SaaS kick right now and was tired for paying ~$300/year to Freshbooks (and I like Freshbooks).

It doesn't do much and suites my needs as is, but Pull Requests are welcome.

## Building mkinvoice

Install http://www.golang.org/, grab the source code and 'go build' it.  There are no external dependencies.

## Running mkinvoice

    ./mkinvoice template.tmpl invoice.json

It will generate an output file using the invoice number as a basename. I've included a sample invoice template that uses Bootstrap3 to mimic the appearance of Freshbooks' invoices.  There is also a sample json file.

## License

MIT See LICENSE for details.



