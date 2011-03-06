<?php
	include("config.php");

	class CookbookDB extends DB {
		const RECIPE = "recipe";
		
		public function __construct() {
			global $user, $pass, $db;
			parent::__construct("mysql:host=localhost;dbname=".$db, $user, $pass, array(PDO::MYSQL_ATTR_INIT_COMMAND => "SET NAMES utf8"));
		}

		public function getRecipe($id) {
			$data = $this->query("SELECT * FROM ".self::RECIPE." WHERE id = ?", $id);
			if (count($data)) { 
				$data[0]["text"] = array(""=>$data[0]["text"]);
				return $data[0]; 
			}
			return null; 
		}

		public function getAllRecipes() {
			return $this->query("SELECT * FROM ".self::RECIPE." ORDER by nazev ASC");
		}

	}

?>
