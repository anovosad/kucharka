<?php
	include("config.php");

	class CookbookDB extends DB {
		const TABLE = "sz_prihlasky";
		public static $FIELDS = array(
			"jmeno", "prijmeni", "beh", "datnar", "rc1", "rc2", "adresa", "psc", 
			"skola", "otec", "matka", "otec_tel", "matka_tel", "mail", "poznamky"
		);

		public function __construct() {
			global $user, $pass, $db;
			parent::__construct("mysql:host=localhost;dbname=".$db, $user, $pass, array(PDO::MYSQL_ATTR_INIT_COMMAND => "SET NAMES utf8"));
		}

	}

?>
