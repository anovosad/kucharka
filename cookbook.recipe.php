<?php
	class Recipe extends MODULE {
		private $db = null;
		private $view = null;
		
		public function __construct($app) {
			parent::__construct($app);
			$this->db = $app->getDB();
			$this->view = $app->getView();
		}
		
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
			$this->db->deleteRecipe($id);
			HTTP::redirect("/");
		}
	}
?>
