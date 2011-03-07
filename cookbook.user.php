<?php
	class User extends MODULE {
		private $db = null;
		private $view = null;
		
		public function __construct($app) {
			parent::__construct($app);
			$this->db = $app->getDB();
			$this->view = $app->getView();
		}
		
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

	}
?>
