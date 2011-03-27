<?xml version="1.0" ?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:include href="common.xsl" />

    <xsl:output 
		method="html"
		omit-xml-declaration="yes" 
		doctype-system="about:legacy-compat"
	/>
		
	<xsl:template match="/*">

	<html>
		<xsl:call-template name="head" />

		<body id="homepage">
			<div id="wrap">
				<header>
					<img src="img/korenky3.jpg" alt="logo" id="logo" />
					<xsl:call-template name="menu" /> 
					<h1>Kuchařka</h1>
				</header>
				
				<p>V kuchařce je nyní <a href="{concat($BASE, '/recepty')}"><xsl:value-of select="//count/@total"></xsl:value-of> receptů</a>.</p>
				
				<p>Nejnovější recepty:</p>
				<xsl:call-template name="recipe-list" />
				
				<xsl:call-template name="footer" />
			</div>
		</body>
	</html>

	</xsl:template>
</xsl:stylesheet>
