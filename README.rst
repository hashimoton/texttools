******************
Text Tools
******************

Miscellaneous commands for processing text files written in Ruby.

===============
Band
===============

Aggregate values for each key.

Usage::

  $ tt-band -h
  Usage: tt-band [options] FILE [FILE...]

  Options:
      -d=DELIMITER                     Delimiter(spaces)
      -k=KEY_FIELD                     Key Field(1)
      -v=VALUE_FIELD                   Value Field(1)
      -c=COMMAND                       Command for values (values.size)


Setup
-------------

::

  $ gem install keybreak


Examples
-----------

Stem-and-leaf display
~~~~~~~~~~~~~~~~~~~~~~~~~~~~
::

  $ seq 0 0.3 10 | tt-band -d. -v2 -c 'values.join("-")'
  0.0-3-6-9
  1.2-5-8
  2.1-4-7
  3.0-3-6-9
  4.2-5-8
  5.1-4-7
  6.0-3-6-9
  7.2-5-8
  8.1-4-7
  9.0-3-6-9
  $



===============
Hook
===============

Join lines with a pattern.

Usage::

  $ tt-hook -h
  Usage: tt-hook [options] FILE [FILE...]

  Options:
      -d=DELIMITER                     Delimiter(--HOOKED--)
      -e=REGEX                         Pattern
      -v                               Invert match

Examples
-----------

Each line should contain 1 or 3 or 4 or 8
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
::

  $ seq 10 | tt-hook -e '[1348]'
  1--HOOKED--2
  3
  4--HOOKED--5--HOOKED--6--HOOKED--7
  8--HOOKED--9
  10


Unhook
~~~~~~~~
::

  $ tt-hook -u hooked.txt > unhooked.txt

Another way

::

  $ sed 's/\-\-HOOKED\-\-/\n/g' hooked.txt > unhooked.txt



===============
Wedge
===============

Split a file into pieces determined by a function.

Usage::

  $ tt-wedge -h
  Usage: tt-wedge [options] FILE [FILE...]
  
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
  $ tt-wedge -o incl1 -b 'line.include?("1")' 1-10.txt
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

  > tt-wedge -o incl1 -b 'line.include?(\"1\")' 1-10.txt

Otherwise you will get::

  > tt-wedge -b 'line.start_with?("1")'  .\10.txt
  (eval):2:in `start_with?': no implicit conversion of Fixnum into String (TypeError)
          from (eval):2:in `block in breakpoint_function'



Insert tt-wedges at fresh starts
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

::

  $ echo -e "1\n2\n3\n1\n2\n1\n2\n3\n2\n3" | tt-wedge -b 'c = line.to_i; b = (!@prev.nil? && c < @prev); @prev = c; return b'
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

  $ tt-scale -h
  Usage: tt-scale [options] FILE [FILE...]
  
  Options:
      -d=DELIMITER                     Delimiter(" ")
      -f=NUMBER                        Field base 1 (0 = the last field)
      -m=NUMBER                        Multiplier(1.0)


Examples
------------

Simple 1 to 10
~~~~~~~~~~~~~~~~~

::

  $ seq -f'a b c %.0f' 10 | tt-scale
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

  $ for i in {1..10}; do echo $(( $RANDOM % 100 -50 )); done | tt-scale -m 0.5
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

  $ seq 10 | tac | cat -n | tt-scale -f 1
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
Sticker
===============

Overwrite a field with a command result.

Usage::

  $ tt-sticker -h
  Usage: sticker [options] FILE [FILE...]

  Options:
      -d=DELIMITER                     Delimiter(" ")
      -f=NUMBER,NUMBER,...             Field base 1 (whole line)
      -c=COMMAND                       Filter command (cat)


Examples
------------

Square of 1 to 10
~~~~~~~~~~~~~~~~~~~~

::

  $ paste <(seq 10) <(seq 10) | tt-sticker -f2 -c 'ruby -ne "puts($_.to_i**2)"'
  1 1
  2 4
  3 9
  4 16
  5 25
  6 36
  7 49
  8 64
  9 81
  10 100
  $


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

