<?php
	class Category extends MODULE {
		private $db = null;
		private $view = null;
		
		public function __construct($app) {
			parent::__construct($app);
			$this->db = $app->getDB();
			$this->view = $app->getView();
		}
		
		public function get($matches) {
			$id = $matches[1];
			$data = $this->db->getCategory($id);
			if ($data) { $this->view->addData("category", $data); }
			
			$this->view->setTemplate("templates/category.xsl");
			echo $this->view->toString();
		}
	}
?>
