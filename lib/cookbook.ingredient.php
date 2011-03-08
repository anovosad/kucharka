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
			}
			
			$this->view->setTemplate("templates/ingredient.xsl");
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
	}
?>
