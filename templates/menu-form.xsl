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
			<h1>Jídelníček</h1>
			
			<form method="post" action="{concat($BASE, '/jidelnicek')}">
				<table>
					<tbody>
						<tr>
							<td>Jaké druhy jídel zahrnout?</td>
							<td><xsl:for-each select="type">
								<label><input type="checkbox" name="id_type[]" value="{@id}" /><xsl:value-of select="@name" /></label><br/>
							</xsl:for-each></td>
						</tr>
						<tr>
							<td>Kolik jídel vybrat?</td>
							<td><input name="count" type="text" size="5" value="10" /></td>
						</tr>
						<tr>
							<td></td>
							<td><input type="submit" value="Připravit" /></td>
						</tr>
					</tbody>
				</table>
			</form>
			
			<xsl:call-template name="footer" />
		</body>
	</html>

	</xsl:template>
</xsl:stylesheet>
