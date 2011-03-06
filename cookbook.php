<?php
	include("oz.php");
	include("db.php");

	class Cookbook extends APP {
		private $db;
		private $debug = true;

		protected $dispatch_table = array(
			"GET	^/recept/(\d+)$				listRecipe",		/* one recipe */
			"GET	^/rss/?$				rss",		/* feed */
			"GET	^/search/?$			search",
			"GET	^.*$				fallback",		/* search fallback */
		);
		
		public function __construct() {
			$this->db = new CookbookDB();
			$this->view = new XML();
			$this->view->setParameter("BASE", HTTP::$BASE);
			$this->view->setParameter("DEBUG", $this->debug);
			$this->view->addFilter(new FILTER_FRACTIONS());

			try {
				$this->dispatch();
			} catch (Exception $e) {
				$this->error500();
				if ($this->debug) {
					echo "<pre>";
					print_r($e);
					echo "</pre>";
				} else {
					error_log(print_r($e, true));
				}
			}
		}

		protected function listRecipe($matches) {
			$id = $matches[1];
			$data = $this->db->getRecipe($id);
			if ($data) { $this->view->addData("recipe", $data); }
			
			$this->view->setTemplate("templates/recipe.xsl");
			echo $this->view->toString();
		}
		
		protected function fallback($matches) {
			HTTP::redirect("/search?q=" . $matches[0]);
		}
		
	}
?>
