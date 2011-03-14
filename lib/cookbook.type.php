<?php
	class Type extends CookbookModule {
		public function all($matches) {
			$data = $this->db->getTypes();
			if (count($data)) { $this->view->addData("type", $data); }
			
			$this->view->setTemplate("templates/types.xsl");
			echo $this->view->toString();
		}
		
		public function get($matches) {
			$id = $matches[1];
			$data = $this->db->getType($id);
			if ($data) { 
				$this->view->addData("type", $data); 
			} else {
				$this->view->addData("type", array("id"=>0));
			}
			
			$this->view->setTemplate("templates/type-form.xsl");
			echo $this->view->toString();
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
