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



===============
Wedge
===============

Split a file into pieces determined by a function.

Usage::

  $ wedge -h
  Usage: wedge [options] FILE [FILE...]
  
  Options:
      -b=FUNCTION                      A function of line. Returns true at each breakpoint (default = false)
      -m=MARKER                        Break point marker (default = --WEDGE--)
      -o=PREFIX                        Output goes to files instead of STDOUT.

Examples
-----------

Split a file when the line contains a key word
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

::

  $ seq 10 > 1-10.txt
  $ wedge -o incl1 -b 'line.include?("1")' 1-10.txt
  $ cat incl1_0
  1
  2
  3
  4
  5
  6
  7
  8
  9
  $ cat incl1_1
  10
  $


On Windows quotations needs to be escaped::

  > wedge -o incl1 -b 'line.include?(\"1\")' 1-10.txt

Otherwise you will get::

  > wedge -b 'line.start_with?("1")'  .\10.txt
  (eval):2:in `start_with?': no implicit conversion of Fixnum into String (TypeError)
          from (eval):2:in `block in breakpoint_function'



Insert wedges at fresh starts
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

::

  $ echo -e "1\n2\n3\n1\n2\n1\n2\n3\n2\n3" | wedge -b 'c = line.to_i; b = (!@prev.nil? && c < @prev); @prev = c; return b'
  1
  2
  3
  --WEDGE--
  1
  2
  --WEDGE--
  1
  2
  3
  --WEDGE--
  2
  3
  $
  


.. EOF

