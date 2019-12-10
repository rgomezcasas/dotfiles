<?php
$autoloadPath = getcwd() . '/vendor/autoload.php';

return is_file($autoloadPath) ? ['defaultIncludes' => [$autoloadPath]] : [];
