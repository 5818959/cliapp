<?php

namespace CliApplication;

/**
 * FileLockApplication.
 */
class FileLockApplication implements CliApplicationInterface
{
    /**
     * Lock file full name, i.e. /path/to/file.lock.
     *
     * @var string
     **/
    private $lockFile;

    /**
     * Constructor.
     *
     * @param string $lockFile Lock file full name, i.e. /path/to/file.lock.
     */
    public function __construct($lockFile)
    {
        $this->lockFile = $lockFile;
    }

    /**
     * Creates .lock file to prevent multiple running.
     *
     * @return boolean TRUE if file was created, otherwise FALSE.
     */
    public function lock()
    {
        if ($this->isLocked()) {
            return false;
        }

        return
            false === file_put_contents($this->lockFile, time())
            ? false
            : true
        ;
    }

    /**
     * Checks if .lock file exists.
     *
     * @return boolean TRUE if .lock file already exists, otherwise FALSE.
     */
    public function isLocked()
    {
        return file_exists($this->lockFile);
    }

    /**
     * Removes .lock file.
     *
     * @return boolean TRUE if file was removed, otherwise FALSE.
     */
    public function unlock()
    {
        return unlink($this->lockFile);
    }
}
