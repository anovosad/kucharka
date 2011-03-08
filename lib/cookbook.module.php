<?php
	class CookbookModule extends MODULE {
		protected $db = null;
		protected $view = null;
		
		public function __construct($app) {
			parent::__construct($app);
			$this->db = $app->getDB();
			$this->view = $app->getView();
		}
	}
?>
