<?php
	session_start();
	include("oz.php");
	include("db.php");
	include("cookbook.user.php");
	include("cookbook.type.php");
	include("cookbook.recipe.php");
	include("cookbook.ingredient.php");
	include("cookbook.category.php");

	class Cookbook extends APP {
		private $db;
		private $debug = true;
		private $image_path = "root/img/recipe";

		protected $dispatch_table = array(
			'GET	^/$					index',				/* homepage */
			'GET	^/login$			login',				/* login form */
			'POST	^/login$			loginProcess',		/* login action */
			'POST	^/logout$			logoutProcess',		/* logout action */

			'GET	^/jidelnicek$		Recipe.menu',		/* menu form/query */
			'GET	^/rss$				Recipe.rss',		/* feed */
			'GET	^/hledani/?$		Recipe.search',		/* search form/query */ 
			'GET	^/recepty$			Recipe.all',		/* alphabetical */
			'GET	^/recept/(\d+)$		Recipe.get',		/* one recipe */
			'POST	^/recept/(\d+)$		Recipe.edit',		/* edit recipe */
			'DELETE	^/recept/(\d+)$		Recipe.delete',		/* delete recipe */

			'GET	^/druhy$			Type.all',			/* list recipe types */
			'GET	^/druh/(\d+)$		Type.get',			/* one recipe type */
			'POST	^/druh/(\d+)$		Type.edit',			/* edit type */
			'DELETE	^/druh/(\d+)$		Type.delete',		/* delete type */
			
			'GET	^/suroviny$			Ingredient.all',	/* list ingredients */
			'GET	^/surovina/(\d+)$	Ingredient.get',	/* one ingredient */
			'POST	^/surovina/(\d+)$	Ingredient.edit',	/* edit ingredient */
			'DELETE	^/surovina/(\d+)$	Ingredient.delete',	/* delete ingredient */

			'GET	^/kategorie/(\d+)$	Category.get',		/* one ingredient category */
			'POST	^/kategorie/(\d+)$	Category.edit',		/* edit ingredient */
			'DELETE	^/kategorie/(\d+)$	Category.delete',	/* delete ingredient */
			
			'GET	^/autori$			User.all',			/* list all users */
			'GET	^/autor/(\d+)$		User.get',			/* get one user */
			'POST	^/autor/(\d+)$		User.edit',			/* edit user */
			'DELETE	^/autor/(\d+)$		User.delete',		/* delete user */

			'GET	^/(.*)$				fallback'			/* search fallback */
		);
		
		public function __construct() {
			$this->db = new CookbookDB($this->image_path);
			$this->view = new XML();
			$this->view->setParameter("BASE", HTTP::$BASE);
			$this->view->setParameter("DEBUG", $this->debug);
			$this->view->setParameter("IMAGE_PATH", $this->image_path);
			$this->view->addFilter(new FILTER_FRACTIONS());
			
			$id = $this->loggedId();
			if ($id) {
				$this->view->addData("login", array(
					"id"=>$id,
					"name"=>$this->loggedName()
				));
			}

			try {
				$this->dispatch();
			} catch (Exception $e) {
				$this->error500();
				if ($this->debug) {
					echo "<pre>" . print_r($e, true) . "</pre>";
				} else {
					error_log(print_r($e, true));
				}
			}
		}
		
		public function getDB() {
			return $this->db;
		}
		
		public function getView() {
			return $this->view;
		}

		public function loggedId() {
			return (isset($_SESSION["id"]) ? $_SESSION["id"] : null);
		}

		public function loggedName() {
			return (isset($_SESSION["name"]) ? $_SESSION["name"] : null);
		}
		
		public function login($matches) {
			$this->view->addData("referer", array("url"=>HTTP::$REFERER));
			$this->view->setTemplate("templates/login.xsl");
			echo $this->view->toString();
		}
		
		public function loginProcess($matches) {
			$login = HTTP::value("login", "post", "");
			$password = HTTP::value("password", "post", "");
			$result = $this->db->validateLogin($login, $password);
			if ($result) { 
				$_SESSION["id"] = $result["id"];
				$_SESSION["name"] = $result["name"];
				$referer = HTTP::value("referer", "post", "");
				if ($referer) { return HTTP::redirect($referer); }
			}
			HTTP::redirectBack(); 
		}

		protected function logoutProcess($matches) {
			if ($this->loggedId()) {
				unset($_SESSION["id"]);
				unset($_SESSION["name"]);
			}
			HTTP::redirectBack();
		}

		public function index($matches) {
			$recipes = $this->db->getLatestRecipes();
			if (count($recipes)) { $this->view->addData("recipe", $recipes); }
			
			$this->view->setTemplate("templates/index.xsl");
			echo $this->view->toString();
		}
		
		public function fallback($matches) {
			HTTP::redirect("/hledani?q=" . $matches[1]);
		}		
	}
?>
