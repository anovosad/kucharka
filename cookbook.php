<?php
	session_start();
	include("lib/oz.php");
	include("lib/db.php");
	include("lib/cookbook.module.php");
	include("lib/cookbook.user.php");
	include("lib/cookbook.type.php");
	include("lib/cookbook.recipe.php");
	include("lib/cookbook.ingredient.php");
	include("lib/cookbook.category.php");

	class Cookbook extends APP {
		private $db = null;
		private $debug = true;
		private $image_path = "root/img";

		protected $dispatch_table = array(
			'GET	^/$					index',				/* homepage */
			'GET	^/login$			login',				/* login form */
			'POST	^/login$			loginProcess',		/* login action */
			'POST	^/logout$			logoutProcess',		/* logout action */

			'GET	^/jidelnicek$		Recipe.menuForm',	/* menu form */
			'POST	^/jidelnicek$		Recipe.menu',		/* menu results */
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

			'GET	^/([^/]*)$			fallback'			/* search fallback */
		);
		
		public function __construct() {
			$this->db = new CookbookDB($this->image_path);
			$this->view = new XML();
			$this->view->setParameter("BASE", HTTP::$BASE);
			$this->view->setParameter("DEBUG", $this->debug);
			$this->view->setParameter("IMAGE_PATH", HTTP::$BASE."/img");
			$this->view->addFilter(new FILTER_FRACTIONS());
			
			$id = $this->loggedId();
			if ($id) {
				$this->view->addData("login", array(
					"id"=>$id,
					"name"=>$this->loggedName()
				));
			}
			
			$this->view->addData("year", array(""=>date("Y")));

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
		
		public function canDeleteUser($id) {
			if (!$this->canModifyUser($id)) { return false; }
			if ($this->loggedId() == $id) { return false; }
			return true;
		}

		public function canModifyUser($id) {
			if (!$this->loggedId()) { return false; }
			$user = $this->db->getUser($this->loggedId());
			if ($this->loggedId() == $id) { return true; }
			if ($user && $user["super"] != 1) { return false; }
			return true;
		}
		
		public function canModifyRecipe($id) {
			if (!$this->loggedId()) { return false; }

			$recipe = $this->db->getRecipe($id);
			if ($recipe && $recipe["id_user"] == $this->loggedId()) { return true; }

			$user = $this->db->getUser($this->loggedId());
			return ($user && $user["super"] == 1);
		}
		
		public function saveImage($id, $table, $width = null) {
			$path = $this->db->getImagePath($table);
			$name = $this->image_path . "/" . $path . "/" . $id . ".jpg";

			$delete = HTTP::value("image-delete", "post", false);
			if ($delete && file_exists($name)) { unlink($name); }
			
			$f = HTTP::value("image", "files", null);
			if ($f && $f["type"] == "image/jpeg" && $f["error"] == 0) {
				$image = imagecreatefromjpeg($f["tmp_name"]);
				
				$w = imagesx($image);
				$h = imagesy($image);
				
				if ($width && $width < $w) {
					$ratio = $width/$w;
					$target_w = round($w * $ratio);
					$target_h = round($h * $ratio);
					$target = imagecreatetruecolor($target_w, $target_h);
					imagecopyresampled($target, $image, 0, 0, 0, 0, $target_w, $target_h, $w, $h);
					$image = $target;
				}
				
				imagejpeg($image, $name);
			}
		}

		public function error($error) {
			$this->view->addData("error", array(""=>$error));
			$this->view->setTemplate("templates/error.xsl");
			echo $this->view->toString();
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
			
			$count = $this->db->getRecipeCount();
			$this->view->addData("count", array("total"=>$count));
			
			$this->view->setTemplate("templates/index.xsl");
			echo $this->view->toString();
		}
		
		public function fallback($matches) {
			HTTP::redirect("/hledani?q=" . $matches[1]);
		}
	}
?>
