<?xml version="1.0" ?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">	
	<xsl:param name="DEBUG" />
	<xsl:template name="head">
		<head>
			<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
			<link rel="stylesheet" href="{concat($BASE, '/style.css')}" type="text/css" />
			<title>Kuchařka</title>
			<script type="text/javascript" src="http://ondras.zarovi.cz/oz.js/oz.js"></script>
			<script type="text/javascript" src="http://ondras.zarovi.cz/oz.js/more.oz.js"></script>
		</head>
	</xsl:template>
		
	<xsl:template name="foot">
		<footer>footer.</footer>
		<xsl:if test="$DEBUG">
		<div id="debug">
			<xsl:text disable-output-escaping="yes">&lt;!--</xsl:text>
			<xsl:copy-of select="/" />
			<xsl:text disable-output-escaping="yes">--&gt;</xsl:text>
		</div>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="menu">
		<nav id="menu">
			MENU
		</nav>
	</xsl:template>
	
</xsl:stylesheet>
