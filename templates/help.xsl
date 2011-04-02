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
					<h1>Nápověda</h1>
				</header>
				
				<h2>Přidávání / úprava receptu</h2>
				<p>Při přidávání suroviny je možné v seznamu surovin rychle hledat – stačí mít aktivní výběr surovin a napsat pár prvních písmen ze suroviny.</p>
				<p>Ve vedlejším textovém políčku (množství suroviny) stisk klávesy Enter recept neuloží, ale přidá právě upravovanou surovinu do seznamu.</p>
				<p>Pokud se při psaní receptu ukáže, že nějaká potřebná surovina neexistuje, nic se neděje: stačí si do nové záložky (okna) otevřít přidání nové suroviny a dle potřeby vyplnit; jakmile je surovina v systému, odkaz "aktualizovat" (ve formuláři na úpravu receptu) sesynchronizuje nabídku surovin s databází.</p>
				
				<h2>Vyhledávání</h2>
				<p>Pokud hledáme jen v názvu, stačí zadaný text napsat přímo za poslední lomítko ve webové adrese, tj. třeba <a href="http://kucharka.zarovi.cz/gulas">http://kucharka.zarovi.cz/gulas</a>. Pokud podmínkám hledání vyhovuje právě jeden recept, je tento zobrazen namísto stránky výsledků.</p>
				
				<h2>Další otázky...?</h2>
				<p>Ondra je rád zodpoví, <a href="mailto:ondras@zarovi.cz">ondras@zarovi.cz</a>.</p>
				
				<xsl:call-template name="footer" />
			</div>
		</body>
	</html>

	</xsl:template>
</xsl:stylesheet>
