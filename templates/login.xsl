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
			<h1>Přihlášení</h1>
			
			<form action="{concat($BASE, '/login')}" method="post">
				<input type="hidden" name="referer" value="{referer/@url}" />
				<table>
					<tbody>
						<tr>
							<td>Jméno:</td>
							<td><input type="text" name="login" /></td>
						</tr>
						<tr>
							<td>Heslo:</td>
							<td><input type="password" name="password" /></td>
						</tr>
						<tr>
							<td></td>
							<td><input type="submit" value="Přihlásit" /></td>
						</tr>
					</tbody>
				</table>
			
			</form>
			<xsl:call-template name="footer" />
		</body>
	</html>

	</xsl:template>
</xsl:stylesheet>
