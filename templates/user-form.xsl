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
			<div id="wrap">
				<xsl:for-each select="user">
				
				<header>
					<xsl:call-template name="menu" /> 
					<h1>
						<xsl:value-of select="@name" />
						<xsl:if test="not(@name)">Nový autor receptů</xsl:if>
					</h1>
				</header>

				
				<form method="post" action="{concat($BASE, '/autor/', @id)}" enctype="multipart/form-data">
					<table>
						<tbody>
							<tr>
								<td>Celé jméno</td>
								<td><input type="text" name="name" value="{@name}" /></td>
							</tr>
							<tr>
								<td>E-mail</td>
								<td><input type="text" name="mail" value="{@mail}" /></td>
							</tr>
							<tr>
								<td>Heslo</td>
								<td>
									<input type="password" name="pwd1" /><br/>
									<input type="password" name="pwd2" />
								</td>
							</tr>
							<tr>
								<td>Obrázek</td>
								<td>
									<xsl:call-template name="image-form">
										<xsl:with-param name="path" select="'users'" />
										<xsl:with-param name="width" select="150" />
									</xsl:call-template>
								</td>
							</tr>
							<tr>
								<td></td>
								<td><input type="submit" value="Uložit" /></td>
							</tr>
						</tbody>
					</table>
				</form>
				
				</xsl:for-each>
				
				<xsl:call-template name="footer" />
			</div>
		</body>
	</html>

	</xsl:template>
</xsl:stylesheet>
