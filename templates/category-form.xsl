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
			<xsl:for-each select="category">
			
			<header>
				<xsl:call-template name="menu" /> 
				<h1>
					<xsl:value-of select="@name" />
					<xsl:if test="not(@name)">Nová kategorie surovin</xsl:if>
				</h1>
			</header>

			
			<form method="post" action="{concat($BASE, '/kategorie/', @id)}">
				<table>
					<tbody>
						<tr>
							<td>Název</td>
							<td><input type="text" name="name" value="{@name}" /></td>
						</tr>
						<tr>
							<td></td>
							<td><input type="submit" value="Uložit" /></td>
						</tr>
					</tbody>
				</table>
			</form>
			
			<form method="post" action="{concat($BASE, '/kategorie/', @id)}">
				<input type="hidden" name="http-method" value="delete" />
				<input type="submit" value="Smazat" />
			</form>

			</xsl:for-each>
			
			<xsl:call-template name="footer" />
		</body>
	</html>

	</xsl:template>
</xsl:stylesheet>
