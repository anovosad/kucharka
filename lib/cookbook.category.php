<?php
	class Category extends CookbookModule {
		public function get($matches) {
			$id = $matches[1];
			$data = $this->db->getCategory($id);
			if ($data) { $this->view->addData("category", $data); }
			
			$this->view->setTemplate("templates/category.xsl");
			echo $this->view->toString();
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
				$this->db->updateCategory($id);
			}
		}
	}
?>
