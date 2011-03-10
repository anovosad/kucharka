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
			
			<xsl:for-each select="ingredient">
			
			<h1><xsl:value-of select="@name" /></h1>
			
			<form method="post" action="{concat($BASE, '/surovina/', @id)}">
				<table>
					<tbody>
						<tr>
							<td>Název</td>
							<td><input type="text" value="{@name}" /></td>
						</tr>
						<tr>
							<td>Kategorie</td>
							<td>
								<xsl:for-each select="//categories">
									<xsl:call-template name="category-select">
										<xsl:with-param name="id_category" select="@id_category" />
									</xsl:call-template>
								</xsl:for-each>
							</td>
						</tr>
						<tr>
							<td>Popis</td>
							<td><textarea name="description"><xsl:value-of select="@description" /></textarea></td>
						</tr>
					</tbody>
				</table>
			</form>
			
			</xsl:for-each>
			
			<xsl:call-template name="footer" />
		</body>
	</html>

	</xsl:template>
</xsl:stylesheet>
