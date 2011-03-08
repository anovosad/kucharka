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
			if ($data) { $this->view->addData("type", $data); }
			
			$this->view->setTemplate("templates/type.xsl");
			echo $this->view->toString();
		}
		
		public function delete($matches) {
			$id = $matches[1];
			$ok = $this->db->deleteType($id);
			if ($ok) {
				HTTP::redirect("/druhy");
			} else {
				$this->app->error("Tento druh jídla nelze smazat, neboť mu náleží nějaké recepty");
			}
		}
	}
?>
