<?php
	class Ingredient extends CookbookModule {
		/**
		 * Tree of categories + ingredients
		 */
		public function all($matches) {
			$data = $this->db->getIngredients();
			if (count($data)) { $this->view->addData("category", $data); }
			
			$this->view->setTemplate("templates/ingredients.xsl");
			echo $this->view->toString();
		}

		/**
		 * Ingredient detail + used in recipes
		 */
		public function get($matches) {
			$id = $matches[1];
			$data = $this->db->getIngredient($id);
			if ($data) { 
				$this->view->addData("ingredient", $data); 
				$recipes = $this->db->getRecipesForIngredient($id);
				if (count($recipes)) { $this->view->addData("recipe", $recipes); }
			} else {
				$this->view->addData("ingredient", array("id"=>0));
			}
			
			$edit = HTTP::value("edit", "get", 0);
			if ($edit) {
				$categories = $this->db->getCategories();
				$this->view->addData("categories", array("category"=>$categories));
				$this->view->setTemplate("templates/ingredient-form.xsl");
			} else {
				$this->view->setTemplate("templates/ingredient.xsl");
			}
			echo $this->view->toString();
		}

		public function delete($matches) {
			if (!$this->app->loggedId()) { return $this->app->error403(); }

			$id = $matches[1];
			$ok = $this->db->deleteIngredient($id);
			if ($ok) {
				HTTP::redirect("/suroviny");
			} else {
				$this->app->error("Tuto surovinu nelze smazat, neboť je využívána v nějakých receptech");
			}
		}

		public function edit($matches) {
			if (!$this->app->loggedId()) { return $this->app->error403(); }

			$id = $matches[1];
			if (!$id) { $id = $this->db->insert(CookbookDB::INGREDIENT); }
			
			$fields = $this->db->getFields(CookbookDB::INGREDIENT);
			$data = array();
			foreach ($fields as $field) { $data[$field] = HTTP::value($field, "post", ""); }
			$this->db->update(CookbookDB::INGREDIENT, $id, $data);

			$this->app->saveImage($id, CookbookDB::INGREDIENT);
			HTTP::redirect("/surovina/".$id);
		}
	}
?>
