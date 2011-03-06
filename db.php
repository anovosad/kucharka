<?php
	include("config.php");

	class CookbookDB extends DB {
		const RECIPE		= "recipe";
		const TYPE			= "type";
		const INGREDIENT	= "ingredient";
		const CATEGORY		= "ingredient_category";
		const USER			= "user";
		const AMOUNT		= "amount";
		
		public function __construct() {
			global $user, $pass, $db;
			parent::__construct("mysql:host=localhost;dbname=".$db, $user, $pass, array(PDO::MYSQL_ATTR_INIT_COMMAND => "SET NAMES utf8"));
		}

		public function getRecipes() {
			return $this->query("SELECT id, name FROM ".self::RECIPE." ORDER by name ASC");
		}

		public function getTypes() {
			return $this->query("SELECT id, name FROM ".self::TYPE." ORDER by `order` ASC");
		}

		public function getIngredients() {
			return $this->query("SELECT ".self::INGREDIENT.".*, 
								".self::CATEGORY.".name 
								FROM ".self::INGREDIENT." 
								LEFT JOIN ".self::CATEGORY." ON ".self::INGREDIENT.".id_category = ".self::CATEGORY.".id 
								ORDER by ".self::CATEGORY.".`order` ASC");
		}
		
		public function getUsers() {
			return $this->query("SELECT id, name FROM ".self::USER." ORDER by id ASC");
		}

		public function getRecipes() {
			return $this->query("SELECT id, name FROM ".self::RECIPE." ORDER by name ASC");
		}
		
		public function getRecipes() {
			return $this->query("SELECT id, name FROM ".self::RECIPE." ORDER by name ASC");
		}
		public function getRecipe($id) {
			$data = $this->query("SELECT * FROM ".self::RECIPE." WHERE id = ?", $id);
			if (count($data)) { 
				$data[0]["text"] = array(""=>$data[0]["text"]);
				return $data[0]; 
			}
			return null; 
		}


		public function getType($id) {
			return $this->query("SELECT * FROM ".self::TYPE." WHERE id = ?", $id);
		}

	}

?>
