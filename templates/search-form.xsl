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

		<body>
			<xsl:call-template name="menu" /> 
			<h1>Vyhledávání</h1>

			<form method="get" action="{concat($BASE, '/hledani')}">
				<table>
					<tbody>
						<tr>
							<td>Název</td>
							<td><input type="text" name="q" value="{@name}" /></td>
						</tr>
						<tr>
							<td></td>
							<td><input type="submit" value="Hledat" /></td>
						</tr>
					</tbody>
				</table>
			</form>
			<xsl:call-template name="footer" />
		</body>
	</html>

	</xsl:template>
</xsl:stylesheet>
