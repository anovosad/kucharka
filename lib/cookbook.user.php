<?php
	class User extends CookbookModule {
		public function all($matches) {
			$data = $this->db->getUsers();
			if (count($data)) { $this->view->addData("user", $data); }
			
			$this->view->setTemplate("templates/users.xsl");
			echo $this->view->toString();
		}
		
		/**
		 * User detail + his recipes
		 */
		public function get($matches) {
			$id = $matches[1];
			$data = $this->db->getUser($id);
			if ($data) { 
				$this->view->addData("user", $data); 
				$recipes = $this->db->getRecipesForUser($id);
				if (count($recipes)) { $this->view->addData("recipe", $recipes); }
			}
			
			$this->view->setTemplate("templates/user.xsl");
			echo $this->view->toString();
		}

		public function delete($matches) {
			$id = $matches[1];
			$ok = $this->db->deleteUser($id);
			if ($ok) {
				HTTP::redirect("/autori");
			} else {
				$this->app->error("Tohoto uživatele nelze smazat, neboť mu náleží nějaké recepty");
			}
		}

	}
?>
