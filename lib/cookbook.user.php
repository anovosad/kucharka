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
			
			$edit = HTTP::value("edit", "get", 0);
			if ($edit) {
				$this->view->setTemplate("templates/user-form.xsl");
			} else {
				$this->view->setTemplate("templates/user.xsl");
			}
			echo $this->view->toString();
		}

		public function delete($matches) {
			$id = $matches[1];
			if (!$this->app->canDeleteUser($id)) { return $this->app->error403(); }
			
			$ok = $this->db->deleteUser($id);
			if ($ok) {
				HTTP::redirect("/autori");
			} else {
				$this->app->error("Tohoto uživatele nelze smazat, neboť mu náleží nějaké recepty");
			}
		}

		public function edit($matches) {
			$id = $matches[1];
			if (!$this->app->canModifyUser($id)) { return $this->app->error403(); }
			
			$fields = $this->db->getFields(CookbookDB::USER);
			$values = array();
			foreach ($fields as $field) { $values[$field] = HTTP::value($field, "post", ""); }
	
			$password = null;
			$pwd1 = HTTP::value("pwd1", "post", "");
			$pwd2 = HTTP::value("pwd2", "post", "");
			if ($pwd1 != $pwd2) { return $this->app->error("Hesla se neshodují"); }
			if ($pwd1) { $password = $pwd1; }

			if (!$values["login"]) { return $this->app->error("Uživatelské jméno nesmí být prázdné"); }

			$data = $this->db->getUserForLogin($values["login"]);
			if ($data && $data["id"] != $id) { return $this->app->error("Toto uživatelské jméno je již použité"); }
		
			if (!$id) { $id = $this->db->insert(CookbookDB::USER); }
			$ok = $this->db->updateUser($id, $values, $password);
			$this->app->saveImage($id, CookbookDB::USER, 150);
			
			if ($id == $this->app->loggedId()) { $_SESSION["name"] = $values["name"]; }
			HTTP::redirect("/autor/".$id);
		}

	}
?>
