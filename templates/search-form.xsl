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
				<header>
					<xsl:call-template name="menu" /> 
					<h1>Vyhledávání</h1>
				</header>
				
				<fieldset>
					<legend>Hledání v názvu</legend>
					<p>Hledaný text je také možno napsat za lomítko v URL.</p>
					<form method="get" action="{concat($BASE, '/hledani')}">
						<table>
							<tbody>
								<tr>
									<td>Název</td>
									<td><input type="text" name="q" value="{@name}" autofocus="autofocus" /></td>
								</tr>
								<tr>
									<td></td>
									<td><input type="submit" value="Hledat" /></td>
								</tr>
							</tbody>
						</table>
					</form>
				</fieldset>
				
				<fieldset>
					<legend>Pokročilé hledání</legend>
					<p>Vyplňte všechny možnosti, podle nichž chcete vyhledávat.</p>
					<form method="post" action="{concat($BASE, '/hledani')}">
						<table>
							<tbody>
								<tr>
									<td>Druh jídla</td>
									<td>
										<select name="id_type">
											<option value="0">(libovolný)</option>
											<xsl:for-each select="//type">
												<option value="{@id}"><xsl:value-of select="@name" /></option>
											</xsl:for-each>
										</select>
									</td>
								</tr>
								<tr>
									<td>Čas přípravy</td>
									<td>
										<select name="time_type">
											<option value="0">(libovolný)</option>
											<option value="1">nejvýše</option>
											<option value="2">alespoň</option>
										</select>
										<input type="text" name="time" value="" />
										minut
									</td>
								</tr>
								<tr>
									<td>Množství</td>
									<td>
										<input type="text" name="amount" value="" />
										(podřetězec včetně diakritiky)
									</td>
								</tr>
								<tr>
									<td>Obsažená surovina</td>
									<td>
										<select name="id_ingredient">
											<option value="0">(libovolná)</option>
											<xsl:for-each select="//category">
												<optgroup label="{@name}">
													<xsl:for-each select="ingredient">
														<option value="{@id}"><xsl:value-of select="@name" /></option>
													</xsl:for-each>
												</optgroup>
											</xsl:for-each>
										</select>
									</td>
								</tr>
								<tr>
									<td>Autor</td>
									<td>
										<select name="id_user">
											<option value="0">(libovolný)</option>
											<xsl:for-each select="//user">
												<option value="{@id}"><xsl:value-of select="@name" /></option>
											</xsl:for-each>
										</select>
									</td>
								</tr>
								<tr>
									<td></td>
									<td><input type="submit" value="Hledat" /></td>
								</tr>
							</tbody>
						</table>
					</form>
				</fieldset>

				<xsl:call-template name="footer" />
			</div>
		</body>
	</html>

	</xsl:template>
</xsl:stylesheet>
