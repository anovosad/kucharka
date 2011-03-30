<?php
	class Type extends CookbookModule {
		public function all($matches) {
			$data = $this->db->getTypes(true);
			if (count($data)) { $this->view->addData("type", $data); }
			
			$this->view->setTemplate("templates/types.xsl");
			$this->app->output();
		}
		
		public function get($matches) {
			$id = $matches[1];
			$data = $this->db->getType($id);
			if ($data) { 
				$this->view->addData("type", $data); 
				$recipes = $this->db->getRecipesForType($id);
				if (count($recipes)) { $this->view->addData("recipe", $recipes); }
			} else {
				$this->view->addData("type", array("id"=>0));
			}
			
			$edit = HTTP::value("edit", "get", 0);
			if ($edit) {
				$this->view->setTemplate("templates/type-form.xsl");
			} else {
				if ($this->app->loggedId()) {
					$this->app->addAction("type", array(
						"method"=>"get",
						"icon"=>"edit",
						"action"=>"/druh/".$id."?edit=1",
						"label"=>"Upravit druh"
					));

					$this->app->addAction("type", array(
						"method"=>"delete",
						"icon"=>"delete",
						"action"=>"/druh/".$id,
						"label"=>"Smazat druh"
					));
				}
				$this->view->setTemplate("templates/type.xsl");
			}
			$this->app->output();
		}
		
		public function delete($matches) {
			if (!$this->app->loggedId()) { return $this->app->error403(); }

			$id = $matches[1];
			$ok = $this->db->deleteType($id);
			if ($ok) {
				HTTP::redirect("/druhy");
			} else {
				$this->app->error("Tento druh jídla nelze smazat, neboť mu náleží nějaké recepty");
			}
		}

		public function edit($matches) {
			if (!$this->app->loggedId()) { return $this->app->error403(); }

			$id = $matches[1];
			$move = HTTP::value("move", "post", 0);
			if ($move) { /* change order */
				$this->db->move(CookbookDB::TYPE, $id, $move);
			} else { /* edit contents */
				if (!$id) { $id = $this->db->insertType(); }
				$fields = $this->db->getFields(CookbookDB::TYPE);
				$data = array();
				foreach ($fields as $field) { $data[$field] = HTTP::value($field, "post", ""); }
				$this->db->update(CookbookDB::TYPE, $id, $data);
			}
			HTTP::redirect("/druh/".$id);
		}
	}
?>
