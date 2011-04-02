<?php
	class User extends CookbookModule {
		public function all($matches) {
			$data = $this->db->getUsers();
			if (count($data)) { $this->view->addData("user", $data); }
			
			$this->view->setTemplate("templates/users.xsl");
			$this->app->output();
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
			} else {
				$this->view->addData("user", array("id"=>0));
			}

			$edit = HTTP::value("edit", "get", 0);
			if ($edit) {
				$this->view->setTemplate("templates/user-form.xsl");
			} else {

				if ($this->app->canModifyUser($id)) {
					$this->app->addAction("user", array(
						"method"=>"get",
						"icon"=>"edit",
						"action"=>"/autor/".$id."?edit=1",
						"label"=>"Upravit uživatele"
					));
				}

				if ($this->app->canDeleteUser($id)) {
					$this->app->addAction("user", array(
						"method"=>"delete",
						"icon"=>"delete",
						"action"=>"/autor/".$id,
						"label"=>"Smazat uživatele"
					));
				}
				
				$this->view->setTemplate("templates/user.xsl");
			}
			$this->app->output();
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
			if (!$id && !$pwd1) { return $this->app->error("Nový uživatel musí mít heslo"); }
			if ($pwd1 != $pwd2) { return $this->app->error("Hesla se neshodují"); }
			if ($pwd1) { $password = $pwd1; }

			if (!$values["mail"]) { return $this->app->error("E-mail nesmí být prázdný"); }

			$data = $this->db->getUserForMail($values["mail"]);
			if ($data && $data["id"] != $id) { return $this->app->error("Tento e-mail je již použitý"); }
		
			if (!$id) { $id = $this->db->insert(CookbookDB::USER); }
			$ok = $this->db->updateUser($id, $values, $password);
			$this->app->saveImage($id, CookbookDB::USER, 150);
			
			if ($id == $this->app->loggedId()) { $_SESSION["name"] = $values["name"]; }
			HTTP::redirect("/autor/".$id);
		}

	}
?>
