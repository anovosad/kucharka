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
			$data = $this->query("SELECT id, name FROM ".self::RECIPE." ORDER by name ASC");
			return $this->addImageInfo($data);
		}

		public function getTypes() {
			return $this->query("SELECT id, name FROM ".self::TYPE." ORDER by `order` ASC");
		}

		public function getIngredients() {
			$ingredients = $this->query("SELECT * FROM ".self::INGREDIENT." ORDER by name ASC");
			$categories = $this->getCategories();
			
			$tmp = array(); /* temporary id-indexed categories */
			for ($i=0;$i<count($categories);$i++) {
				$id = $categories[$i]["id"];
				$tmp[$id] = $categories[$i];
				$tmp[$id]["ingredients"] = array();
			}
			
			for ($i=0;$i<count($ingredients);$i++) {
				$id = $ingredients[$i]["id_category"];
				$tmp[$id]["ingredients"][] = $ingredients[$i];
			}
			
			$result = array();
			foreach ($tmp as $item) { $result[] = $item; }
			
			return $result;
		}
		
		public function getUsers() {
			return $this->query("SELECT id, name FROM ".self::USER." ORDER by id ASC");
		}
		
		private function getCategories() {
			return $this->query("SELECT id, name FROM ".self::CATEGORY." ORDER by `order` ASC");
		}

		/***/

		public function getRecipe($id) {
			$data = $this->query("SELECT * FROM ".self::RECIPE." WHERE id = ?", $id);
			if (!count($data)) { return null; }
			
			$data = $data[0];
			$data["text"] = array(""=>$data["text"]);
			$data["remark"] = array(""=>$data["remark"]);
			
			$data["ingredient"] = $this->getAmounts($id);

			$data = $this->addImageInfo($data);
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

		/***/
		
		public function getLatestRecipes($amount = 10) {
			$data = $this->query("SELECT id, name FROM ".self::RECIPE." ORDER BY ts DESC LIMIT ". (int) $amount);
			return $this->addImageInfo($data);
		}
		
		private function addImageInfo($recipes) {
			return $recipes;
		}
		
	}

?>
