This is a list of non-automated hacks you'll need to preform to keep the software running.

Understanding this file:

* Each hack is a bullet point.
  * The first subbullet explains what you need to do.
  * The second subbullet explains since when it's needed to do it.
  * The third subbullet explains when it got fixed.
  * The fourth subbullet explains who it affects/who should apply it.

## Active hacks

* Adding a numeric duration table.
   * You will need to run `ALTER TABLE posts ADD COLUMN duration NUMERIC;` to be able to upload files. Do this by running `docker-compose exec sql psql danbooru2` and then pasting the previous command.
   * Introduced in https://github.com/noirscape/e621-docker/commit/06c1be510fd6b1d39d90b80d4cf3c6a88e3b48a8 .
   * Not fixed as of yet.
   * Affects everyone, new installs and migrations included.

## Deprecated hacks

_None yet._
