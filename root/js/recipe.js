var Recipe = {
	_lastRow: null,
	_container: null,
	_url: "",

	_addEvent: function(row) {
		var inputs = row.getElementsByTagName("input");
		var button = inputs[inputs.length-1];
		OZ.Event.add(button, "click", this._removeRow.bind(this));
	},
	
	_addRow: function(e) {
		var row = this._lastRow.cloneNode(true);
		var inputs = row.getElementsByTagName("input");
		inputs[inputs.length-1].value = "Odebrat";
		row.getElementsByTagName("select")[0].value = this._lastRow.getElementsByTagName("select")[0].value;
		this._addEvent(row);
		
		this._lastRow.parentNode.insertBefore(row, this._lastRow);
		this._lastRow.getElementsByTagName("input")[0].value = "";
		this._lastRow.getElementsByTagName("select")[0].focus();
	},
	
	_removeRow: function(e) {
		var t = OZ.Event.target(e);
		while (t && t.nodeName.toLowerCase() != "tr") { t = t.parentNode; }
		if (!t) { return; }
		t.parentNode.removeChild(t);
	},
	
	_keyPress: function(e) {
		if (e.keyCode != 13) { return; }
		OZ.Event.prevent(e);
		this._addRow(e);
	},
	
	_refreshClick: function(e) {
		OZ.Event.prevent(e);
		this._refresh();
	},
	
	_refresh: function() {
		OZ.Request(this._url, this._response.bind(this), {xml:true});
	},
	
	_response: function(xmlDoc) {
		var select = OZ.DOM.elm("select", {name:"id_ingredient[]"});
		var categories = xmlDoc.getElementsByTagName("category");
		for (var i=0;i<categories.length;i++) {
			var category = categories[i];
			var optgroup = OZ.DOM.elm("optgroup", {label:category.getAttribute("name")});
			select.appendChild(optgroup);
			
			var ingredients = category.getElementsByTagName("ingredient");
			for (var j=0;j<ingredients.length;j++) {
				var ingredient = ingredients[j];
				var option = OZ.DOM.elm("option", {innerHTML:ingredient.getAttribute("name"), value:ingredient.getAttribute("id")});
				optgroup.appendChild(option);
			}
		}
		
		var rows = this._container.getElementsByTagName("tr");
		for (var i=0;i<rows.length;i++) {
			var row = rows[i];
			var s = select.cloneNode(true);
			var td = row.getElementsByTagName("td")[0];
			
			if (td.getElementsByTagName("select").length) {
				s.value = td.getElementsByTagName("select")[0].value;
			} else if (td.getElementsByTagName("input").length) {
				s.value = td.getElementsByTagName("input")[0].value;
			}
			
			OZ.DOM.clear(td);
			td.appendChild(s);
			
			if (row == this._lastRow) { break; }
		}
	},

	init: function(container, refresh, url) {
		this._container = container;
		this._url = url;

		var rows = container.getElementsByTagName("tr");
		this._lastRow = rows[rows.length-3];
		var inputs = this._lastRow.getElementsByTagName("input");
		OZ.Event.add(inputs[inputs.length-2], "keypress", this._keyPress.bind(this));
		OZ.Event.add(inputs[inputs.length-1], "click", this._addRow.bind(this));
		
		for (var i=0;i<rows.length;i++) {
			var row = rows[i];
			if (row == this._lastRow) { break; }
			this._addEvent(row);
		}
		
		OZ.Event.add(refresh, "click", this._refreshClick.bind(this));
		this._refresh();
	}
};
