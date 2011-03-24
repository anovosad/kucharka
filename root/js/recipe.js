var Recipe = {
	_lastRow: null,

	_addEvent: function(row) {
		var button = row.getElementsByTagName("input")[1];
		OZ.Event.add(button, "click", this._removeRow.bind(this));
	},
	
	_addRow: function(e) {
		var row = this._lastRow.cloneNode(true);
		row.getElementsByTagName("input")[1].value = "Odebrat";
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

	init: function(container, lastRow) {
		var rows = container.getElementsByTagName("tr");
		this._lastRow = rows[rows.length-3];
		var inputs = this._lastRow.getElementsByTagName("input");
		OZ.Event.add(inputs[0], "keypress", this._keyPress.bind(this));
		OZ.Event.add(inputs[1], "click", this._addRow.bind(this));
		
		for (var i=0;i<rows.length;i++) {
			var row = rows[i];
			if (row == this._lastRow) { break; }
			this._addEvent(row);
		}
	}
};
