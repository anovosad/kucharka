<?php
	include("oz.php");
	include("db.php");

	class Cookbook extends APP {
		private $db;

		protected $dispatch_table = array(
			'GET 	^/recept/(\d+)$				getRecipe'		/* one recipe */
		);
		
		public function __construct() {
			$this->db = new CookbookDB();
			$this->view = new XML();
			$this->view->setParameter("BASE", HTTP::$BASE);
			
			try {
				$this->dispatch();
			} catch (Exception $e) {
				error_log(print_r($e, true));
				$this->error500();
			}
		}

		protected function getItem($matches) {
			$id = $matches[1];
			$data = $this->db->getRecipe($id);
			if ($data) { $this->view->addData("prihlaska", $data); }
			
			$this->view->setTemplate("templates/recipe.xsl");
			echo $this->view->toString();
		}
		
	}
?>
