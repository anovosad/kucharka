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
			/* FIXME postprocess */
			return $this->query("SELECT ".self::INGREDIENT.".*, 
								".self::CATEGORY.".name AS category_name
								FROM ".self::INGREDIENT." 
								LEFT JOIN ".self::CATEGORY." ON ".self::INGREDIENT.".id_category = ".self::CATEGORY.".id 
								ORDER by ".self::CATEGORY.".`order` ASC");
		}
		
		public function getUsers() {
			return $this->query("SELECT id, name FROM ".self::USER." ORDER by id ASC");
		}
		
		/***/

		public function getRecipe($id) {
			$data = $this->query("SELECT * FROM ".self::RECIPE." WHERE id = ?", $id);
			if (!count($data)) { return null; }
			
			$data = $data[0];
			$data["text"] = array(""=>$data["text"]);
			$data["remark"] = array(""=>$data["remark"]);
			
			$data["ingredients"] = array("ingredient"=>$this->getAmounts($id));
			return $data; 
		}

		public function getType($id) {
			return $this->query("SELECT * FROM ".self::TYPE." WHERE id = ?", $id);
		}

		public function getIngredient($id) {
			return $this->query("SELECT * FROM ".self::INGREDIENT." WHERE id = ?", $id);
		}

		public function getCategory($id) {
			return $this->query("SELECT * FROM ".self::CATEGORY." WHERE id = ?", $id);
		}

		public function getUser($id) {
			return $this->query("SELECT * FROM ".self::USER." WHERE id = ?", $id);
		}
		
		public function getAmounts($id_recipe) {
			return $this->query("SELECT ".self::INGREDIENT.".name, ".self::AMOUNT.".amount
									FROM ".self::AMOUNT."
									LEFT JOIN ".self::INGREDIENT." ON ".self::AMOUNT.".id_ingredient = ".self::INGREDIENT.".id
									LEFT JOIN ".self::CATEGORY." ON ".self::INGREDIENT.".id_category = ".self::CATEGORY.".id
									WHERE ".self::AMOUNT.".id_recipe = ?
									ORDER BY ".self::CATEGORY.".`order`", $id_recipe);
		}

	}

?>
