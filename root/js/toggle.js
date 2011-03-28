var Toggle = {
	_toggle: function(node) {
		var next = node.nextSibling;
		while (next.nodeName.toLowerCase() != "ul") { next = next.nextSibling; }
		next.style.display = (next.style.display == "none" ? "" : "none");
	},
	
	_click: function(e) {
		var span = OZ.Event.target(e);
		this._toggle(span);
	},

	init: function(container) {
		var spans = container.getElementsByTagName("span");
		var click = this._click.bind(this);
		for (var i=0;i<spans.length;i++) { 
			OZ.Event.add(spans[i], "click", click); 
			this._toggle(spans[i]);
		}
	}
};
