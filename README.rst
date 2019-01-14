******************
Text Tools
******************

Miscellaneous commands for processing text files.


===============
Hook
===============

Join lines with a pattern.

Usage::

  $ hook -h
  Usage: hook [options] FILE [FILE...]

  Options:
      -d=DELIMITER                     Delimiter(--HOOKED--)
      -e=REGEX                         Pattern
      -v                               Invert match

Examples
-----------

Each line should contain 1 or 3 or 4 or 8
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
::

  $ seq 10 | hook -e '[1348]'
  1--HOOKED--2
  3
  4--HOOKED--5--HOOKED--6--HOOKED--7
  8--HOOKED--9
  10



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
  



===============
Scale
===============

Visualize the magunitude of number.

Usage::

  $ scale -h
  Usage: scale [options] FILE [FILE...]

  Options:
      -d=DELIMITER                     Delimiter(" ")
      -f=NUMBER                        Field(0)
      -s=NUMBER                        Step(10)
          --min=NUMBER                 Minimum value(0.0)
          --max=NUMBER                 Maximum value(10.0)


Examples
------------

Simple 1 to 10
~~~~~~~~~~~~~~~~~

::

  $ seq 10 | scale
  * 1
  ** 2
  *** 3
  **** 4
  ***** 5
  ****** 6
  ******* 7
  ******** 8
  ********* 9
  ********** 10


Random number < 100
~~~~~~~~~~~~~~~~~~~~~~

::

  $ for i in {1..10}; do echo $(( $RANDOM % 100 )); done | ./scale -s 20 --max 100
  ***************** 83
  ************** 69
  ************ 58
  *** 15
  ************ 58
  ******* 37
  ****** 29
  ******************** 99
   0
  *************** 77
  $


.. EOF

