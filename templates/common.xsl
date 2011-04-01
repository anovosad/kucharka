<?xml version="1.0" ?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">	
	<xsl:param name="BASE" />
	<xsl:param name="DEBUG" />
	<xsl:param name="IMAGE_PATH" />
	
	<xsl:template name="head">
		<xsl:param name="title" select="''" />
		<head>
			<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
			<link rel="stylesheet" href="{concat($BASE, '/css/cookbook.css')}" type="text/css" media="screen,projection,handheld" />
			<link rel="stylesheet" href="{concat($BASE, '/css/print.css')}" type="text/css" media="print" />
			<script type="text/javascript" src="{concat($BASE, '/js/oz.js')}"></script>
			<title>
				<xsl:if test="$title != ''">
					<xsl:value-of select="$title" />
					<xsl:text> – </xsl:text>
				</xsl:if>
				<xsl:text>Kuchařka</xsl:text>
			</title>
		</head>
	</xsl:template>
		
	<xsl:template name="footer">
		<xsl:for-each select="//login"><xsl:call-template name="sidebar" /></xsl:for-each>

		<footer>
			<p>
				© 2007–<xsl:value-of select="//year" />
				<xsl:text> </xsl:text>
				<a href="{concat($BASE, '/autori')}">Autoři receptů</a>
			</p>
		</footer>
		<xsl:if test="$DEBUG">
			<div id="debug">
				<xsl:text disable-output-escaping="yes">&lt;!--</xsl:text>
				<xsl:copy-of select="/" />
				<xsl:text disable-output-escaping="yes">--&gt;</xsl:text>
			</div>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="recipe-link">
		<a href="{concat($BASE, '/recept/', @id)}">
			<xsl:if test="@image = '1'"><xsl:attribute name="class">image</xsl:attribute></xsl:if>
			<xsl:value-of select="@name" />
		</a>
	</xsl:template>
	
	<xsl:template name="recipe-list">
		<xsl:if test="recipe">
			<ul>
				<xsl:for-each select="recipe">
					<li>
						<xsl:call-template name="recipe-link" />
					</li>
				</xsl:for-each>
			</ul>
		</xsl:if>
	</xsl:template>

	<xsl:template name="menu">
		<nav id="menu">
			<table>
				<tbody>
					<tr>
						<td><a href="{concat($BASE, '/')}">Hlavní stránka</a></td>
						<td>|</td>
						<td><a href="{concat($BASE, '/druhy')}">Druhy jídel</a></td>
						<td>|</td>
						<td><a href="{concat($BASE, '/recepty')}">Abecedně</a></td>
						<td>|</td>
						<td><a href="{concat($BASE, '/autori')}">Autoři</a></td>
						<td>|</td>
						<td><a href="{concat($BASE, '/suroviny')}">Suroviny</a></td>
						<td>|</td>
						<td><a href="{concat($BASE, '/jidelnicek')}">Sestavit jídelníček</a></td>
						<td>|</td>
						<td><a href="{concat($BASE, '/hledani')}">Hledat</a></td>
					</tr>
					<xsl:if test="not(//login)">
						<tr>
							<td colspan="13">
								<a href="{concat($BASE, '/login')}">
									<img src="{concat($IMAGE_PATH, '/icons/key.png')}" alt="Přihlásit" title="Přihlásit" />
								</a>
							</td>
						</tr>
					</xsl:if>
				</tbody>
			</table>
		</nav>
	</xsl:template>
	
	<xsl:template name="image-action">
		<xsl:param name="action" />
		<xsl:param name="method" />
		<xsl:param name="src" />
		<xsl:param name="title" />
		<xsl:choose>
			<xsl:when test="$method = 'get'">
				<a href="{concat($BASE, $action)}"><img src="{concat($IMAGE_PATH, '/icons/', $src, '.png')}" title="{$title}" alt="{$title}" /></a>
			</xsl:when>
			
			<xsl:otherwise>
				<form action="{concat($BASE, $action)}" method="post">
					<xsl:if test="$method != 'post'">
						<input type="hidden" name="http-method" value="{$method}" />
					</xsl:if>
					<input type="image" src="{concat($IMAGE_PATH, '/icons/', $src, '.png')}" title="{$title}" alt="{$title}" />
				</form>
			</xsl:otherwise>
		</xsl:choose>
		
		
	</xsl:template>
	
	<xsl:template name="image-form">
		<xsl:param name="width" select="0" />
		<xsl:param name="path" select="''" />
		
		<p>Obrázek musí být ve formátu JPG.
		<xsl:if test="$width">Bude zmenšen na šířku <xsl:value-of select="$width" /> pixelů.</xsl:if>
		</p>
		<xsl:call-template name="image">
			<xsl:with-param name="path" select="$path" />
		</xsl:call-template>
		<xsl:if test="@image = 1">
			<br/>
			<label>
				<input type="checkbox" name="image-delete" value="1" />
				Odstranit
			</label>
			<br/>
		</xsl:if>
		<input type="file" name="image" />
	</xsl:template>
	
	<xsl:template name="image">
		<xsl:param name="path" select="''" />
		<xsl:if test="@image = 1">
			<img src="{concat($IMAGE_PATH, '/', $path, '/', @id, '.jpg')}" alt="{@name}">
				<xsl:if test="$path = 'recipes'"><xsl:attribute name="itemprop">photo</xsl:attribute></xsl:if>
			</img>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="rich-text">
		<xsl:param name="text" />
		<xsl:choose>
			<xsl:when test="contains($text, '&#xa;')">
				<xsl:value-of select="substring-before($text, '&#xa;')" disable-output-escaping="yes" />
				<br/>
				<xsl:call-template name="rich-text">
					<xsl:with-param name="text" select="substring-after($text, '&#xa;')"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$text" disable-output-escaping="yes" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="sidebar">
		<aside id="sidebar">
			<h2><xsl:value-of select="@name" /></h2>
			<nav>
				<ul>
					<xsl:for-each select="action">
						<xsl:call-template name="sidebar-action" />
					</xsl:for-each>
				</ul>
			</nav>
		</aside>
		<script type="text/javascript">
			(function(){
				var sync = function() {
					OZ.$("sidebar").style.right = (-OZ.$("sidebar").offsetWidth)+"px";
					OZ.$("sidebar").style.top = Math.round(OZ.DOM.scroll()[1])+"px";
				}
				OZ.Event.add(window, "resize", sync);
				OZ.Event.add(window, "scroll", sync);
				OZ.Event.add(window, "load", sync);
			})();
		</script>
	</xsl:template>
	
	<xsl:template name="sidebar-action">
		<li>
			<xsl:choose>
				<xsl:when test="@method = 'get'">
					<a href="{concat($BASE, @action)}">
						<xsl:call-template name="sidebar-button" />
					</a>
				</xsl:when>
				<xsl:otherwise>
					<form method="post" action="{concat($BASE, @action)}">
						<xsl:if test="@method != 'post'">
							<xsl:attribute name="onsubmit">return confirm("O'RLY?");</xsl:attribute>
							<input type="hidden" name="http-method" value="{@method}" />
						</xsl:if>
						<xsl:call-template name="sidebar-button" />
					</form>
				</xsl:otherwise>
			</xsl:choose>
		</li>
	</xsl:template>
	
	<xsl:template name="sidebar-button">
		<button type="submit">
			<img src="{concat($IMAGE_PATH, '/icons/', @icon, '.png')}" alt="{@label}" title="{@label}" />
			<xsl:text> </xsl:text>
			<xsl:value-of select="@label" />
		</button>
	</xsl:template>
	
	<xsl:template name="move-icon">
		<xsl:param name="action" />
		<xsl:param name="direction" />

		<form method="post" action="{$action}">
			<input type="hidden" name="move" value="{$direction}" />

			<xsl:variable name="path">
				<xsl:choose>
					<xsl:when test="$direction = 1">down</xsl:when>
					<xsl:otherwise>up</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>

			<xsl:variable name="title">
				<xsl:choose>
					<xsl:when test="$direction = 1">Posunout dolů</xsl:when>
					<xsl:otherwise>Posunout nahoru</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>

			<input type="image" name="image" src="{concat($IMAGE_PATH, '/icons/', $path, '.png')}" title="{$title}" />
		</form>
	</xsl:template>
	
</xsl:stylesheet>
