<?php
	class Category extends CookbookModule {
		public function get($matches) {
			$id = $matches[1];
			$data = $this->db->getCategory($id);
			if ($data) { 
				$this->view->addData("category", $data); 
				$ingredients = $this->db->getIngredientsForCategory($id);
				if (count($ingredients)) { $this->view->addData("ingredient", $ingredients); }
			} else {
				$this->view->addData("category", array("id"=>0));
			}
			
			$edit = HTTP::value("edit", "get", 0);
			if ($edit) {
				$this->view->setTemplate("templates/category-form.xsl");
			} else {
				if ($this->app->loggedId()) {
					$this->app->addAction("category", array(
						"method"=>"get",
						"icon"=>"edit",
						"action"=>"/kategorie/".$id."?edit=1",
						"label"=>"Upravit kategorii"
					));

					$this->app->addAction("category", array(
						"method"=>"delete",
						"icon"=>"delete",
						"action"=>"/kategorie/".$id,
						"label"=>"Smazat kategorii"
					));
				}
				$this->view->setTemplate("templates/category.xsl");
			}
			$this->app->output();
		}

		public function delete($matches) {
			if (!$this->app->loggedId()) { return $this->app->error403(); }

			$id = $matches[1];
			$ok = $this->db->deleteCategory($id);
			if ($ok) {
				HTTP::redirect("/suroviny");
			} else {
				$this->app->error("Tuto kategorii nelze smazat, neboť do ní patří nějaké suroviny");
			}
		}
		
		public function edit($matches) {
			if (!$this->app->loggedId()) { return $this->app->error403(); }

			$id = $matches[1];
			$move = HTTP::value("move", "post", 0);
			if ($move) { /* change order */
				$this->db->move(CookbookDB::CATEGORY, $id, $move);
			} else { /* edit contents */
				if (!$id) { $id = $this->db->insertCategory(); }
				$fields = $this->db->getFields(CookbookDB::CATEGORY);
				$data = array();
				foreach ($fields as $field) { $data[$field] = HTTP::value($field, "post", ""); }
				$this->db->update(CookbookDB::CATEGORY, $id, $data);
			}
			HTTP::redirect("/kategorie/".$id);
		}
	}
?>
