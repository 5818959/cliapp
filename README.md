# CliApplication

Easy way to create lockable cli applications.

## Install

	composer install


## Usage

Your app class example (`./src/MyApp.php`):

```
<?php

namespace MyApp;

use CliApplication\FileLockApplication;

class MyCliApp extends FileLockApplication
{
	...

	public function doSomething()
	{
		...
	}

	...
}
```

Your index file example (`index.php`):

```
<?php

require_once 'vendor/autoload.php';

use MyApp\MyCliApp;

define('LOCK_FILE', __DIR__ . '/app.lock');

$app = new MyCliApp(LOCK_FILE);

if ($app->isLocked()) {
    echo 'Already running.' . PHP_EOL;
    exit(1);
}

if ($app->lock()) {
    $app->doSomething();

    if (!$app->unlock()) {
        echo 'Can\'t unlock application.' . PHP_EOL;
        exit(1);
    }
}

exit(0);
```
