******************
Text Tools
******************

Miscellaneous commands for processing text files.


===============
hook
===============

Join lines with a pattern.

Usage::

  $ hook -h
  Usage: hook [options] FILE [FILE...]

  Options:
      -d=DELIMITER                     Delimiter(--HOOKED--)
      -e=REGEX                         Pattern
      -v                               Invert match

Tips
-------

Unhook
~~~~~~~~
::

  $ sed 's/\-\-HOOKED\-\-/\n/g' hooked.txt > unhooked.txt


.. EOF

