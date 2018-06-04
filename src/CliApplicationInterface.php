<?php

namespace CliApplication;

/**
 * CliApplicationInterface.
 */
interface CliApplicationInterface
{
    /**
     * Lock application to prevent multiple running.
     *
     * @return boolean TRUE if locked, otherwise FALSE.
     */
    public function lock();

    /**
     * Checks if application is locked.
     *
     * @return boolean TRUE if application is locked, otherwise FALSE.
     */
    public function isLocked();

    /**
     * Unlocks application.
     *
     * @return boolean TRUE if unlocked, otherwise FALSE.
     */
    public function unlock();
}
