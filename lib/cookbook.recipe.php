<?php
	class Recipe extends CookbookModule {
		public function menu($matches) {
			$recipes = $this->db->getRandomRecipes(/* FIXME */);
			if (count($recipes)) { $this->view->addData("recipe", $recipes); }
			$this->view->setTemplate("templates/menu-results.xsl");
			echo $this->view->toString();
		}

		public function rss($matches) {
			$recipes = $this->db->getLatestRecipes();
			if (count($recipes)) { $this->view->addData("recipe", $recipes); }
			
			$this->view->setTemplate("templates/rss.xsl");
			echo $this->view->toString();
		}

		public function search($matches) {
			$query = HTTP::value("q", "get", "");
			$recipes = $this->db->searchRecipes($query);
			
			if (count($recipes) == 1) {
				HTTP::redirect("/recept/".$recipes[0]["id"]);
				return;
			}
			
			if (count($recipes)) { $this->view->addData("recipe", $recipes); }
			$this->view->setTemplate("templates/search-results.xsl");
			echo $this->view->toString();
		}
		
		public function all($matches) {
			$data = $this->db->getRecipes();
			if (count($data)) { $this->view->addData("recipe", $data); }

			$this->view->setTemplate("templates/recipes.xsl");
			echo $this->view->toString();
		}

		public function get($matches) {
			$id = $matches[1];
			$data = $this->db->getRecipe($id);
			if ($data) { $this->view->addData("recipe", $data); }
			
			$this->view->setTemplate("templates/recipe.xsl");
			echo $this->view->toString();
		}
		
		public function delete($matches) {
			$id = $matches[1];
			if (!$this->app->canModifyRecipe($id)) { return $this->app->error403(); }

			$id = $matches[1];
			$this->db->deleteRecipe($id);
			HTTP::redirect("/");
		}

		public function edit($matches) {
			$id = $matches[1];
			if (!$this->app->canModifyRecipe($id)) { return $this->app->error403(); }

			$fields = $this->db->getFields(CookbookDB::RECIPE);
			$values = array();
			foreach ($fields as $field) { $values[$field] = HTTP::value($field, "post", ""); }
			
			$ingredients = array();
			$id_ingredient = HTTP::value("id_ingredient", "post", array());
			$amount = HTTP::value("amount", "post", array());
			while (count($id_ingredient) && count($amount)) {
				$id_i = (int) array_shift($id_ingredient);
				$a = (string) array_shift($amount);
				if ($a) { $ingredients[] = array("id_ingredient"=>$id_i, "amount"=>$a); }
			}
			
			if (!$id) { $id = $this->db->insertRecipe($this->app->loggedId()); }
			$this->db->updateRecipe($id, $values, $ingredients);

			$this->app->saveImage($id, CookbookDB::RECIPE, 300);
			HTTP::redirect("/recept/".$id);
		}

	}
?>
