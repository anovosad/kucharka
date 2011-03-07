<?php
	session_start();
	include("oz.php");
	include("db.php");

	class Cookbook extends APP {
		private $db;
		private $debug = true;
		private $image_path = "root/img/recipe";

		protected $dispatch_table = array(
			'GET	^/$					index',						/* homepage */
			'GET	^/rss$				rss',						/* feed */
			'GET	^/login$			login',						/* login form */
			'POST	^/login$			loginProcess',				/* login action */
			'POST	^/logout$			logoutProcess',				/* logout action */

			'GET	^/recepty$			listRecipes',				/* alphabetical */
			'GET	^/recept/(\d+)$		getRecipe',					/* one recipe */
			'POST	^/recept/(\d+)$		recipeProcess',				/* edit recipe */
			'DELETE	^/recept/(\d+)$		recipeDelete',				/* delete recipe */

			'GET	^/jidelnicek$		menu',						/* menu form/query */
			
			'GET	^/druhy$			listTypes',					/* list recipe types */
			'GET	^/druh/(\d+)$		getType',					/* one recipe type */
			'POST	^/druh/(\d+)$		typeProcess',				/* edit type */
			'DELETE	^/druh/(\d+)$		typeDelete',				/* delete type */
			
			'GET	^/suroviny$			listIngredients',			/* list ingredients */
			'GET	^/surovina/(\d+)$	getIngredient',				/* one ingredient */
			'POST	^/surovina/(\d+)$	ingredientProcess',			/* edit ingredient */
			'DELETE	^/surovina/(\d+)$	ingredientDelete',			/* delete ingredient */

			'GET	^/kategorie/(\d+)$	getIngredientCategory',		/* one ingredient category */
			'POST	^/kategorie/(\d+)$	ingredientCategoryProcess',	/* edit ingredient */
			'DELETE	^/kategorie/(\d+)$	ingredientCategoryDelete',	/* delete ingredient */
			
			'GET	^/autori$			listUsers',					/* list all users */
			'GET	^/autor/(\d+)$		getUser',					/* get one user */
			'POST	^/autor/(\d+)$		userProcess',				/* edit user */
			'DELETE	^/autor/(\d+)$		userDelete',				/* delete user */

			'GET	^/hledani/?$		search',					/* search form/query */ 
			'GET	^/(.*)$				fallback'					/* search fallback */
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
		
		protected function login($matches) {
			$this->view->addData("referer", array("url"=>HTTP::$REFERER));
			$this->view->setTemplate("templates/login.xsl");
			echo $this->view->toString();
		}
		
		protected function loginProcess($matches) {
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

		protected function index($matches) {
			$recipes = $this->db->getLatestRecipes();
			if (count($recipes)) { $this->view->addData("recipe", $recipes); }
			
			$this->view->setTemplate("templates/index.xsl");
			echo $this->view->toString();
		}
		
		protected function rss($matches) {
			$recipes = $this->db->getLatestRecipes();
			if (count($recipes)) { $this->view->addData("recipe", $recipes); }
			
			$this->view->setTemplate("templates/rss.xsl");
			echo $this->view->toString();
		}

		protected function listRecipes($matches) {
			$data = $this->db->getRecipes();
			if (count($data)) { $this->view->addData("recipe", $data); }

			$this->view->setTemplate("templates/recipes.xsl");
			echo $this->view->toString();
		}

		protected function getRecipe($matches) {
			$id = $matches[1];
			$data = $this->db->getRecipe($id);
			if ($data) { $this->view->addData("recipe", $data); }
			
			$this->view->setTemplate("templates/recipe.xsl");
			echo $this->view->toString();
		}
		
		protected function fallback($matches) {
			HTTP::redirect("/hledani?q=" . $matches[1]);
		}
		
		protected function listIngredients($matches) {
			$data = $this->db->getIngredients();
			if ($data) { $this->view->addData("category", $data); }
			
			$this->view->setTemplate("templates/ingredients.xsl");
			echo $this->view->toString();
			
		}
		
		protected function search($matches) {
			$query = HTTP::value("q", "get", "");
			$recipes = $this->db->searchRecipes($query);
			
			if (count($recipes) == 1) {
				HTTP::redirect("/recept/".$recipes[0]["id"]);
				return;
			}
			
			if (count($recipes)) { $this->view->addData("recipe", $recipes); }
			$this->view->setTemplate("templates/search-results.xsl");
			echo $this->view->toString();
			
		}
		
		private function loggedId() {
			return (isset($_SESSION["id"]) ? $_SESSION["id"] : null);
		}

		private function loggedName() {
			return (isset($_SESSION["name"]) ? $_SESSION["name"] : null);
		}
	}
?>
