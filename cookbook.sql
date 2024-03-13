--
-- Struktura tabulky `amount`
--

CREATE TABLE IF NOT EXISTS `amount` (
  `id_ingredient` INTEGER NOT NULL DEFAULT 0,
  `id_recipe` INTEGER NOT NULL DEFAULT 0,
  `amount` TEXT DEFAULT NULL
);

-- --------------------------------------------------------

--
-- Struktura tabulky `ingredient`
--

CREATE TABLE IF NOT EXISTS `ingredient` (
  `id` INTEGER NOT NULL,
  `name` TEXT DEFAULT NULL,
  `id_category` INTEGER NOT NULL DEFAULT 0,
  `description` TEXT,
  PRIMARY KEY  (`id`)
) ;

-- --------------------------------------------------------

--
-- Struktura tabulky `ingredient_category`
--

CREATE TABLE IF NOT EXISTS `ingredient_category` (
  `id` INTEGER NOT NULL,
  `name` TEXT DEFAULT NULL,
  `order` INTEGER NOT NULL DEFAULT 0,
  PRIMARY KEY  (`id`)
);

-- --------------------------------------------------------

--
-- Struktura tabulky `recipe`
--

CREATE TABLE IF NOT EXISTS `recipe` (
  `id` INTEGER NOT NULL,
  `name` TEXT DEFAULT NULL,
  `id_type` INTEGER NOT NULL DEFAULT 0,
  `time` INTEGER DEFAULT 0,
  `amount` TEXT DEFAULT NULL,
  `text` TEXT DEFAULT NULL,
  `remark` TEXT,
  `hot_tip` INTEGER NOT NULL DEFAULT 0,
  `id_user` INTEGER NOT NULL,
  `ts` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY  (`id`)
);

-- --------------------------------------------------------

--
-- Struktura tabulky `type`
--

CREATE TABLE IF NOT EXISTS `type` (
  `id` INTEGER NOT NULL,
  `name` TEXT DEFAULT NULL,
  `order` INTEGER NOT NULL DEFAULT '0',
  PRIMARY KEY  (`id`)
) ;

-- --------------------------------------------------------

--
-- Struktura tabulky `user`
--

CREATE TABLE IF NOT EXISTS `user` (
  `id` INTEGER NOT NULL,
  `pwd` TEXT DEFAULT NULL,
  `name` TEXT DEFAULT NULL,
  `mail` TEXT DEFAULT NULL,
  `super` INTEGER NOT NULL DEFAULT 0,
  PRIMARY KEY  (`id`)
);

INSERT INTO `user` (`pwd`, `name`, `mail`, `super`) VALUES
('5baa61e4c9b93f3f0682250b6cf8331b7ee68fd8', 'adrian', 'novosad.adr@gmail.com', 1);