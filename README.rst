******************
Text Tools
******************

Miscellaneous commands for processing text files written in Ruby.

===============
Band
===============

Aggregate values for each key.

Usage::

  $ band -h
  Usage: band [options] FILE [FILE...]
  
  Options:
      -d=DELIMITER                     Delimiter(spaces)
      -c=COMMAND                       Command for values (values.size)

Setup
-------------

::

  $ gem install keybreak


Examples
-----------

Count files for each base name
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
::

  $ \ls
  README.rst  band  band.bat  hook  hook.bat  scale  scale.bat  wedge  wedge.bat
  $ \ls | band -d.
  README.1
  band.2
  hook.2
  scale.2
  wedge.2
  $


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

  $ hook -u hooked.txt > unhooked.txt

Another way

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
      -f=NUMBER                        Field base 1 (0 = the last field)
      -m=NUMBER                        Multiplier(1.0)


Examples
------------

Simple 1 to 10
~~~~~~~~~~~~~~~~~

::

  $ seq -f'a b c %.0f' 10 | scale
  a b c + 1
  a b c ++ 2
  a b c +++ 3
  a b c ++++ 4
  a b c +++++ 5
  a b c ++++++ 6
  a b c +++++++ 7
  a b c ++++++++ 8
  a b c +++++++++ 9
  a b c ++++++++++ 10


Random number -50...49
~~~~~~~~~~~~~~~~~~~~~~~~~~

::

  $ for i in {1..10}; do echo $(( $RANDOM % 100 -50 )); done | scale -m 0.5
  +++++++++++++++++ 33
  -------------- -28
  ------ -12
  ----------------- -34
  +++++++++++++++++++++++++ 49
  ------ -12
  +++++++++ 18
  ---- -8
  -------- -16
  +++++++++++++++ 30
  $

Field number
~~~~~~~~~~~~~~~~
::

  $ seq 10 | tac | cat -n | scale -f 1
  + 1 10
  ++ 2 9
  +++ 3 8
  ++++ 4 7
  +++++ 5 6
  ++++++ 6 5
  +++++++ 7 4
  ++++++++ 8 3
  +++++++++ 9 2
  ++++++++++ 10 1



===============
Requirements
===============

Ruby 2.x


===============
Development
===============

::

  $ cd test
  $ ruby test_<command>.rb


===============
License
===============

Public Domain

.. EOF

