<?php
	include("config.php");

	class CookbookDB extends DB {
		const RECIPE		= "recipe";
		const TYPE			= "type";
		const INGREDIENT	= "ingredient";
		const CATEGORY		= "ingredient_category";
		const USER			= "user";
		const AMOUNT		= "amount";
		
		private $image_path = "";

		public function __construct($image_path) {
			global $user, $pass, $db;
			$this->image_path = $image_path;
			parent::__construct("mysql:host=localhost;dbname=".$db, $user, $pass, array(PDO::MYSQL_ATTR_INIT_COMMAND => "SET NAMES utf8"));
		}
		
		public function getFields($table) {
			switch ($table) {
				case self::RECIPE: return array("name", "id_type", "time", "amount", "text", "remark", "hot_tip"); break;
				case self::TYPE: return array("name"); break;
				case self::INGREDIENT: return array("name", "id_category", "description"); break;
				case self::CATEGORY: return array("name"); break;
				case self::USER: return array("login", "name", "mail"); break;
				default: return array();
			}
			
		}
		
		public function getImagePath($table) {
			switch ($table) {
				case self::RECIPE: return "recipes"; break;
				case self::INGREDIENT: return "ingredients"; break;
				case self::USER: return "users"; break;
				
				case self::TYPE: 
				case self::CATEGORY:
				default: null;
			}
			
		}

		public function validateLogin($login, $password) {
			$hash = sha1($password);
			$data = $this->query("SELECT id, name FROM ".self::USER." WHERE login = ? AND pwd = ?", $login, $hash);
			return (count($data) ? $data[0] : null);
		}

		public function getRecipeCount() {
			$data = $this->query("SELECT COUNT(id) AS c FROM ".self::RECIPE);
			return $data[0]["c"];
		}

		public function getRecipes() {
			$data = $this->query("SELECT id, name, id_type FROM ".self::RECIPE." ORDER by name ASC");
			return $this->addImageInfo($data, self::RECIPE);
		}

		public function getTypes($withRecipes) {
			$types = $this->query("SELECT id, name FROM ".self::TYPE." ORDER by `order` ASC");
			if (!$withRecipes) { return $types; }

			$recipes = $this->getRecipes();
			
			$tmp = array(); /* temporary id-indexed types */
			for ($i=0;$i<count($types);$i++) {
				$id = $types[$i]["id"];
				$tmp[$id] = $types[$i];
				$tmp[$id]["recipe"] = array();
			}
			
			for ($i=0;$i<count($recipes);$i++) {
				$id = $recipes[$i]["id_type"];
				$tmp[$id]["recipe"][] = $recipes[$i];
			}
			
			$result = array();
			foreach ($tmp as $item) { $result[] = $item; }
			
			return $result;
		}

		public function getIngredients() {
			$ingredients = $this->query("SELECT * FROM ".self::INGREDIENT." ORDER by name ASC");
			$ingredients = $this->addImageInfo($ingredients, self::INGREDIENT);

			$categories = $this->getCategories();
			
			$tmp = array(); /* temporary id-indexed categories */
			for ($i=0;$i<count($categories);$i++) {
				$id = $categories[$i]["id"];
				$tmp[$id] = $categories[$i];
				$tmp[$id]["ingredient"] = array();
			}
			
			for ($i=0;$i<count($ingredients);$i++) {
				$id = $ingredients[$i]["id_category"];
				$tmp[$id]["ingredient"][] = $ingredients[$i];
			}
			
			$result = array();
			foreach ($tmp as $item) { $result[] = $item; }
			
			return $result;
		}
		
		public function getUsers() {
			$data = $this->query("SELECT id, name FROM ".self::USER." ORDER by id ASC");
			return $this->addImageInfo($data, self::USER);
		}
		
		public function getCategories() {
			return $this->query("SELECT id, name FROM ".self::CATEGORY." ORDER by `order` ASC");
		}

		/***/

		public function getRecipe($id) {
			$data = $this->query("SELECT * FROM ".self::RECIPE." WHERE id = ?", $id);
			if (!count($data)) { return null; }
			$data = $this->addImageInfo($data, self::RECIPE);
			
			$data = $data[0];
			$data["text"] = array(""=>$data["text"]);
			$data["remark"] = array(""=>$data["remark"]);
			
			$data["ingredient"] = $this->getAmounts($id);

			return $data; 
		}

		public function getType($id) {
			$data = $this->query("SELECT * FROM ".self::TYPE." WHERE id = ?", $id);
			if (!count($data)) { return null; }
			return $data[0];
		}

		public function getIngredient($id) {
			$data = $this->query("SELECT * FROM ".self::INGREDIENT." WHERE id = ?", $id);
			if (!count($data)) { return null; }
			$data = $this->addImageInfo($data, self::INGREDIENT);
			return $data[0];
		}

		public function getCategory($id) {
			$data = $this->query("SELECT * FROM ".self::CATEGORY." WHERE id = ?", $id);
			if (!count($data)) { return null; }
			return $data[0];
		}

		public function getUser($id) {
			$data = $this->query("SELECT id, login, super, name, mail FROM ".self::USER." WHERE id = ?", $id);
			if (!count($data)) { return null; }
			$data = $this->addImageInfo($data, self::USER);
			return $data[0];
		}
		
		public function getAmounts($id_recipe) {
			return $this->query("SELECT ".self::INGREDIENT.".name, ".self::AMOUNT.".amount
									FROM ".self::AMOUNT."
									LEFT JOIN ".self::INGREDIENT." ON ".self::AMOUNT.".id_ingredient = ".self::INGREDIENT.".id
									LEFT JOIN ".self::CATEGORY." ON ".self::INGREDIENT.".id_category = ".self::CATEGORY.".id
									WHERE ".self::AMOUNT.".id_recipe = ?
									ORDER BY ".self::CATEGORY.".`order` ASC, ".self::INGREDIENT.".name ASC", $id_recipe);
		}

		/***/
		
		public function getLatestRecipes($amount = 10) {
			$data = $this->query("SELECT id, name FROM ".self::RECIPE." ORDER BY ts DESC LIMIT ". (int) $amount);
			return $this->addImageInfo($data, self::RECIPE);
		}
		
		public function getRandomRecipes($id_types, $count = 10) {
			$data = $this->query("SELECT id, name 
									FROM ".self::RECIPE."
									WHERE id_type IN (".implode(",",$id_types).")
									ORDER BY RAND() ASC
									LIMIT ".(int)$count);
			return $this->addImageInfo($data, self::RECIPE);
		}
		
		public function searchRecipes($query) {
			$data = $this->query("SELECT id, name FROM ".self::RECIPE." WHERE name COLLATE utf8_general_ci LIKE ?", "%".$query."%");
			return $this->addImageInfo($data, self::RECIPE);
		}
		
		public function getRecipesForType($id_type) {
			$data = $this->query("SELECT id, name FROM ".self::RECIPE." WHERE id_type = ? ORDER BY name ASC", $id_type);
			return $this->addImageInfo($data, self::RECIPE);
		}
		
		public function getRecipesForUser($id_user) {
			$data = $this->query("SELECT id, name FROM ".self::RECIPE." WHERE id_user = ? ORDER BY name ASC", $id_user);
			return $this->addImageInfo($data, self::RECIPE);
		}

		public function getRecipesForIngredient($id_ingredient) {
			$data = $this->query("SELECT 
									DISTINCT id_recipe AS id,
									".self::RECIPE.".name AS name
									FROM ".self::AMOUNT." 
									LEFT JOIN ".self::RECIPE." ON ".self::AMOUNT.".id_recipe = ".self::RECIPE.".id
									WHERE id_ingredient = ? 
									ORDER BY id_recipe ASC", $id_ingredient);
			return $this->addImageInfo($data, self::RECIPE);
		}

		public function getIngredientsForCategory($id_category) {
			return $this->query("SELECT id, name FROM ".self::INGREDIENT." WHERE id_category = ? ORDER BY name ASC", $id_category);
		}

		public function getUserForLogin($login) {
			$data = $this->query("SELECT * FROM ".self::USER." WHERE login = ?", $login);
			if (!count($data)) { return null; }
			$data = $this->addImageInfo($data, self::USER);
			return $data[0];
		}

		private function addImageInfo($recipes, $table) {
			$path = $this->getImagePath($table);
			
			for ($i=0;$i<count($recipes);$i++) {
				$exists = file_exists($this->image_path . "/" . $path . "/" . $recipes[$i]["id"] . ".jpg");
				$recipes[$i]["image"] = ($exists ? 1 : 0);
			}
			return $recipes;
		}
		
		/***/
		
		public function deleteRecipe($id) {
			$this->delete(self::RECIPE, $id);
			$this->delete(self::AMOUNT, array("id_recipe" => $id));
			return true;
		}

		public function deleteType($id) {
			if (count($this->getRecipesForType($id))) { return false; }
			$this->delete(self::TYPE, $id);
			return true;
		}

		public function deleteIngredient($id) {
			if (count($this->getRecipesForIngredient($id))) { return false; }
			$this->delete(self::INGREDIENT, $id);
			return true;
		}

		public function deleteCategory($id) {
			if (count($this->getIngredientsForCategory($id))) { return false; }
			$this->delete(self::CATEGORY, $id);
			return true;
		}

		public function deleteUser($id) {
			if (count($this->getRecipesForUser($id))) { return false; }
			$this->delete(self::USER, $id);
			return true;
		}
		
		/***/
		
		public function insertType() {
			$data = $this->query("SELECT MAX(`order`) AS m FROM ".self::TYPE);
			$order = $data[0]["m"] + 1;
			return $this->insert(self::TYPE, array("`order`"=>$order));
		}

		public function insertCategory() {
			$data = $this->query("SELECT MAX(`order`) AS m FROM ".self::CATEGORY);
			$order = $data[0]["m"] + 1;
			return $this->insert(self::CATEGORY, array("`order`"=>$order));
		}

		public function insertRecipe($id_user) {
			return $this->insert(self::RECIPE, array("id_user"=>$id_user));
		}

		public function updateUser($id, $values, $password = null) {
			if ($password) { $values["pwd"] = sha1($password); }
			return $this->update(self::USER, $id, $values);
		}

		public function updateRecipe($id, $values, $ingredients) {
			/* FIXME */
		}
		
		/**
		 * Move record up/down using its "order" column
		 * @param {string} table
		 * @param {int} id
		 * @param {int} direction +1 down, -1 up
		 */
		public function move($table, $id, $direction) {
			$order = $this->query("SELECT `order` AS o FROM ".$table." WHERE id = ?", $id);
			if (!count($order)) { return false; }
			$order = $order[0]["o"];
			
			$operator = ($direction == 1 ? ">" : "<");
			$sibling = $this->query("SELECT id, `order` AS o FROM ".$table." WHERE `order` ".$operator. " ? LIMIT 1", $order);
			if (!count($sibling)) { return false; }
			$sibling_id = $sibling[0]["id"];
			$sibling_order = $sibling[0]["order"];
			
			$this->update($table, $sibling_id, array("`order`"=>$order));
			$this->update($table, $id, array("`order`"=>$sibling_order));
			return true;
		}
	}
?>
