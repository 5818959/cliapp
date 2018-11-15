<?php

require_once 'vendor/autoload.php';

define('LOCK_FILE', __DIR__ . '/app.lock');

use CliApplication\FileLockApplication;

class MyCliApp extends FileLockApplication
{
    public function doSomething()
    {
        $i = 15;
        while (--$i > 0) {
            echo $i, PHP_EOL;
            sleep(1);
        }

        return true;
    }
}

$app = new MyCliApp(LOCK_FILE);

if ($app->isLocked()) {
    echo 'Already running.', PHP_EOL;
}

if ($app->lock()) {
    $app->doSomething();

    if (!$app->unlock()) {
        echo 'Can\'t unlock application.', PHP_EOL;
        exit(1);
    }
} else {
    echo 'Can\'t lock application.', PHP_EOL;
}

exit(0);
