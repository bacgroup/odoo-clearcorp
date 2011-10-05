<html>
<head>
	<style type="text/css">
		${css}
	</style>
</head>
<body class = "data">
	%for inv in objects :
	<% setLang(inv.partner_id.lang) %>
	<div id="wrapper">
		<table class = "document_data">
			<tr><td>
			%if inv.type == 'out_invoice' and (inv.state == 'open' or inv.state == 'paid') :
			<span class="title">${_("Electronic Invoice")} ${inv.number or ''|entity}</span>
			%elif inv.type == 'out_invoice' and inv.state == 'proforma2' :
			<span class="title">${_("PROFORMA")} ${inv.number or ''|entity}</span>
			%elif inv.type == 'out_invoice' and inv.state == 'draft' :
			<span class="title">${_("Draft Inovice")} ${inv.number or ''|entity}</span>
			%elif inv.type == 'out_invoice' and inv.state == 'cancel':
			<span class="title">${_("Canceled Invoice")} ${inv.number or ''|entity}</span>
			%elif inv.type == 'in_invoice' :
			<span class="title">${_("Supplier Invoice")} ${inv.number or ''|entity}</span>   
			%elif inv.type == 'out_refund' :
			<span class="title">${_("Refund")} ${inv.number or ''|entity}</span> 
			%elif inv.type == 'in_refund' :
			<span class="title">${_("Supplier Refund")} ${inv.number or ''|entity}</span> 
			%endif</td>
			
			<td class ="other_data">
				${_("Salesman")}: ${inv.partner_id.user_id.name or  ' '|entity}<br/>
			</td>
			
			</tr>
			<tr><td>
			${_("Date:")} ${formatLang(inv.date_invoice, date=True)|entity}
			</td>
			<td class ="other_data">	${_("Due date")}: ${formatLang(inv.date_invoice, date=True)|entity}</td>
			</tr>
			<tr>
				<td>${inv.name or '' |entity}</td>
				<td class ="other_data">${_("Payment tems")}: ${inv.payment_term.name or '-' |entity}</td>
			</tr>
		</div>
		<!-- Header partner data -->
		<table class="partner-table">
			<tbody>
				<tr class = "title"><td>${inv.partner_id.name}</td><td>${_("Address")}</td></tr>
				<tr><td>${_("ID Num.")}: ${inv.partner_id.ref or '-'|entity}</td><td>${inv.address_invoice_id.street or ''}</td></tr>
				<tr><td>${_("Phone")}:${inv.address_invoice_id.phone or '-'|entity}</td><td>${inv.address_invoice_id.street2 or ''}</td></tr>
				<tr><td>${_("Fax")}: ${inv.address_invoice_id.fax or '-' | entity}</td><td>${(inv.address_invoice_id.zip and format(inv.address_invoice_id.zip) + ((inv.address_invoice_id.city or inv.address_invoice_id.state_id or inv.address_invoice_id.country_id) and ' ' or '') or '') + (inv.address_invoice_id.city and format(inv.address_invoice_id.city) + ((inv.address_invoice_id.state_id or inv.address_invoice_id.country_id) and ', ' or '') or '') + (inv.address_invoice_id.state_id and format(inv.address_invoice_id.state_id.name) + (inv.address_invoice_id.country_id and ', ' or '') or '') + (inv.address_invoice_id.country_id and format(inv.address_invoice_id.country_id.name) or '')}</td></tr>
				<tr><td colspan = "2">${_("Email")}: ${inv.address_invoice_id.email or '-'|entity}</td><td> </td></tr>
			</tbody>
		</table>
		<table class="data-table" cellspacing = "3">
		%if inv.amount_discounted != 0:
				<thead><th>${_("Qty")}</th><th>${_("[Code] Description / (Taxes)")}</th><th>${_("Disc.(%)")}</th><th>${_("Unit Price")}</th><th>${_("Total Price")}</th></thead>
		%else:
				<thead><th>${_("Qty")}</th><th>${_("[Code] Description / (Taxes)")}</th><th>${_("Unit Price")}</th><th>${_("Total Price")}</th></thead>
		%endif
		<tbody>
		%for line in inv.invoice_line :
			<tr style ="border-bottom:1px solid black;">
				<td>${formatLang(line.quantity)} ${format(line.uos_id.name)}</td>
				<td>${line.name} 
					%if line.invoice_line_tax_id != []:
						${ ', '.join([ tax.name or '' for tax in line.invoice_line_tax_id ])|entity}
					%endif
				</td>
				%if inv.amount_discounted != 0:
					<td style="text-align:right;">${line.discount and formatLang(line.discount) + '%' or '-'}</td>
				%endif
				<td style="text-align:right;">${inv.currency_id.symbol_prefix or ''|entity } ${formatLang(line.price_unit)} ${inv.currency_id.symbol_suffix or ''|entity }</td>
				<td style="text-align:right;">${inv.currency_id.symbol_prefix or ''|entity } ${formatLang(line.price_subtotal_not_discounted)} ${inv.currency_id.symbol_suffix or ''|entity }</td>
			</tr>
			%if line.note :
			<tr><td>${line.product_id and line.product_id.code and '[' + format(line.product_id.code) + '] '}<b>${_("Note")}:</b> ${format(line.note)}</td></tr>
			%endif
		%endfor
		%if inv.amount_discounted != 0:
		<tr><td style="border-style:none"/><td style="border-style:none"/><td style="border-style:none"/><td style="border-top:2px solid"><b>${_("Sub Total")}:</b></td><td style="border-top:2px solid;text-align:right">${inv.currency_id.symbol_prefix or ''|entity} ${formatLang(inv.amount_untaxed_not_discounted)} ${inv.currency_id.symbol_suffix or ''|entity}</td></tr>
		<tr><td style="border-style:none"/><td style="border-style:none"/><td style="border-style:none"/><td style="border-style:none"><b>${_("Discount")}:</b></td><td style="text-align:right">${inv.currency_id.symbol_prefix or ''|entity} ${formatLang(inv.amount_discounted)} ${inv.currency_id.symbol_suffix or ''|entity}</td></tr>
		<tr><td style="border-style:none"/><td style="border-style:none"/><td style="border-style:none"/><td style="border-style:none"><b>${_("Taxes")}:</b></td><td style="text-align:right">${inv.currency_id.symbol_prefix or ''|entity} ${formatLang(inv.amount_tax)} ${inv.currency_id.symbol_suffix or ''|entity}</td></tr>
		<tr><td style="border-style:none"/><td style="border-style:none"/><td style="border-style:none"/><td style="border-top:2px solid"><b>${_("Total")}:</b></td><td style="border-top:2px solid;text-align:right">${inv.currency_id.symbol_prefix or ''|entity} ${formatLang(inv.amount_total)} ${inv.currency_id.symbol_suffix or ''|entity}</td></tr>
		%else:
		<tr><td style="border-style:none"/><td style="border-style:none"/><td style="border-top:2px solid"><b>${_("Sub Total")}:</b></td><td style="border-top:2px solid;text-align:right">${inv.currency_id.symbol_prefix or ''|entity} ${formatLang(inv.amount_untaxed_not_discounted)} ${inv.currency_id.symbol_suffix or ''|entity}</td></tr>
		<tr><td style="border-style:none"/><td style="border-style:none"/><td style="border-style:none"><b>${_("Taxes")}:</b></td><td style="text-align:right">${inv.currency_id.symbol_prefix or ''|entity} ${formatLang(inv.amount_tax)} ${inv.currency_id.symbol_suffix or ''|entity}</td></tr>
		<tr><td style="border-style:none"/><td style="border-style:none"/><td style="border-top:2px solid"><b>${_("Total")}:</b></td><td style="border-top:2px solid;text-align:right">${inv.currency_id.symbol_prefix or ''|entity} ${formatLang(inv.amount_total)} ${inv.currency_id.symbol_suffix or ''|entity}</td></tr>
		%endif
		
		</tbody>
		</table>
		<table class="notes_table">
			%if inv.comment:
				<tr style = "border-style:2px solid black;backgroung-color : #D8D8D8;margin-bottom : 20px;"><td>${_("Invoice Note")}: ${format(inv.comment)}</td></tr>
			%endif
			%if inv.payment_term and inv.payment_term.note:
				<tr style = "border-style:2px solid black;backgroung-color : #D8D8D8;"><td>${_("Payment Note")}: ${format(inv.payment_term and inv.payment_term.note)}</td></tr>
			%endif
		</table>
	</div>
	<p style="page-break-after:always"></p>
	%endfor
</body>
</html>
