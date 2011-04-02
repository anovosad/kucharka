--
-- Struktura tabulky `amount`
--

CREATE TABLE IF NOT EXISTS `amount` (
  `id_ingredient` int(11) NOT NULL default '0',
  `id_recipe` int(11) NOT NULL default '0',
  `amount` varchar(100) collate utf8_czech_ci default NULL,
  KEY `id_surovina` (`id_ingredient`),
  KEY `id_recept` (`id_recipe`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci;

-- --------------------------------------------------------

--
-- Struktura tabulky `ingredient`
--

CREATE TABLE IF NOT EXISTS `ingredient` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(100) collate utf8_czech_ci default NULL,
  `id_category` int(11) NOT NULL default '0',
  `description` text collate utf8_czech_ci,
  PRIMARY KEY  (`id`),
  KEY `id_typ` (`id_category`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci PACK_KEYS=0 AUTO_INCREMENT=281 ;

-- --------------------------------------------------------

--
-- Struktura tabulky `ingredient_category`
--

CREATE TABLE IF NOT EXISTS `ingredient_category` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(50) collate utf8_czech_ci default NULL,
  `order` int(11) NOT NULL default '0',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci AUTO_INCREMENT=18 ;

-- --------------------------------------------------------

--
-- Struktura tabulky `recipe`
--

CREATE TABLE IF NOT EXISTS `recipe` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(100) collate utf8_czech_ci default NULL,
  `id_type` int(11) NOT NULL default '0',
  `time` int(11) default '0',
  `amount` varchar(64) collate utf8_czech_ci default NULL,
  `text` text character set utf8,
  `remark` text collate utf8_czech_ci,
  `hot_tip` tinyint(4) NOT NULL default '0',
  `id_user` int(11) NOT NULL,
  `ts` timestamp NOT NULL default CURRENT_TIMESTAMP,
  PRIMARY KEY  (`id`),
  KEY `id_druh` (`id_type`),
  KEY `id_user` (`id_user`),
  KEY `ts` (`ts`),
  KEY `hot_tip` (`hot_tip`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci AUTO_INCREMENT=282 ;

-- --------------------------------------------------------

--
-- Struktura tabulky `type`
--

CREATE TABLE IF NOT EXISTS `type` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(64) collate utf8_czech_ci default NULL,
  `order` int(11) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  KEY `poradi` (`order`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci PACK_KEYS=0 AUTO_INCREMENT=30 ;

-- --------------------------------------------------------

--
-- Struktura tabulky `user`
--

CREATE TABLE IF NOT EXISTS `user` (
  `id` int(11) NOT NULL auto_increment,
  `pwd` char(40) collate utf8_czech_ci default NULL,
  `name` varchar(128) collate utf8_czech_ci default NULL,
  `mail` varchar(128) collate utf8_czech_ci default NULL,
  `super` tinyint(4) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  KEY `mail` (`mail`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci AUTO_INCREMENT=18 ;
