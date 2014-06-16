<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Invoice</title>

    <!-- Bootstrap -->
    <!-- Latest compiled and minified CSS -->
    <link rel="stylesheet" href="https://netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap.min.css">
    
    <!-- Optional theme -->
    <link rel="stylesheet" href="https://netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap-theme.min.css">

    <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
      <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
      <script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->

    <style>
     .no-border.table>thead>tr>th,  .no-border.table>tbody>tr>th,  .no-border.table>tfoot>tr>th,  .no-border.table>thead>tr>td,  .no-border.table>tbody>tr>td,  .no-border.table>tfoot>tr>td {
       padding: 4px;
       line-height: 1.24857143;
       vertical-align: top;
       border-top: none;/*1px solid #ddd;*/
     }
    </style>

  </head>
  <body>
    <div class="container">

      <div class="row"  style="margin-top:1cm;">
        <div class="col-xs-5 col-xs-offset-1">
          <address>
            <strong>Sourdough Labs<br>Research and Development Corp.</strong><br>
            32634 Carter Ave<br>
            Mission, BC V4S 0B7<br>
            Phone: (604) 603-1741
          </address>
        </div>
        <div class="col-xs-6 text-right">
          <img src="logo.png" width="230px;">
        </div>
      </div>

      <div class="row" style="margin-top:.25cm;">
        <div class="col-xs-5 col-xs-offset-1">
          <address>
            {{.ClientName}}<br>
            {{.ClientContact}}<br>
            {{.ClientStreet}}<br>
            {{.ClientCity}}, {{.ClientProvince}} {{.ClientPostal}}<br>            
          </address>
        </div>
        <div class="col-xs-6 text-right" style="padding-left:1cm;">
          <table class="no-border table" style="width:100%">
            <tr>
              <td class="text-left">Invoice #</td>
              <td class="text-right">{{.Number}}</td>
            </tr>
            <tr>
              <td class="text-left">Invoice Date</td>
              <td class="text-right">{{.Date | formatdate}}</td>
            </tr>
            <tr class="active">
              <td class="text-left"><strong>Amount Due</strong></td>
              <td class="text-right"><strong>${{.NetAmountDue | currency}} CAD</strong></td>
            </tr>
          </table>
        </div>
      </div>

      <table class="table" style="width:100%;margin-top:1cm;margin-bottom:2px;">
        <thead>
          <tr class="active">
            <td style="width:55%;">Description</td>
            <td style="width:15%;" class="text-right">Unit Cost</td>
            <td style="width:15%;" class="text-right">Quantity</td>
            <td style="width:15%;" class="text-right">Line Total</td>
          </tr>
        </thead>

        {{ range .LineItems }}
          <tr>
            <td>{{.Description}}</td>
            <td class="text-right">${{.Rate | currency}}</td>
            <td class="text-right">{{.Quantity}}</td>
            <td class="text-right">${{.Amount | currency}}</td>
          </tr>
        {{else}} 
          <tr><td colspan="4">Empty Invoice</td></tr>
        {{end}}

        <tr style="border-bottom:3px solid #ddd;">
          <td  colspan="4">&nbsp;</td>
        </tr>
      </table>

      <div class="row" style="">
        <div class="col-xs-6 text-left" style="">
          {{if .HasPayments}}          
            <p><strong>Payments:</strong></p>
            <div style="padding:.5cm;padding-right:1.5cm;">
              <table style="width:100%;">
                {{ range .Payments }}
                  <tr>
                    <td style="width:50%;">{{.Date | formatdate}}</td>
                    <td class="text-right">${{.Amount | currency}}</td>
                  </tr>
                {{end}}              
              </table>
              <br>
              <p><em>Thank you.</em></p>
            </div>
          {{else}}
            &nbsp;
          {{end}}
        </div>

        <div class="col-xs-6  text-right" style="padding-left:1cm;">
          <table class="no-border table" style="width:100%">
            <tr>
              <td class="text-left"><strong>Subtotal</strong></td>
              <td class="text-right"><strong>${{.SubTotalDue | currency}}</strong></td>
            </tr>
            <tr>
              <td class="text-left" style="border-bottom:1px solid #ddd;">5% GST (877152801RT0001)</td>
              <td class="text-right" style="border-bottom:1px solid #ddd;">${{.TaxDue | currency}}</td>
            </tr>
            <tr>
              <td class="text-left"><strong>Total</strong></td>
              <td class="text-right"><strong>${{.TotalDue | currency}}</strong></td>
            </tr>
            <tr>
              <td class="text-left">Amount Paid</td>
              <td class="text-right">$-{{.TotalPayments | currency}}</td>
            </tr>
            <tr class="active">
              <td class="text-left"><strong>Amount Due</strong></td>
              <td class="text-right"><strong>${{.NetAmountDue | currency}} CAD</strong></td>
            </tr>
          </table>

          <div class="text-left">
            <br>
            <em>
            Payment is due within 15 days and may be made by cheque. Thank you for your business.
            </em>
          </div>
        </div>
      </div>

    </div>   
    
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"></script>
    <script src="https://netdna.bootstrapcdn.com/bootstrap/3.1.1/js/bootstrap.min.js"></script>
  </body>
</html>

