# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

######################### We start with some black magic to print on failure.

# Change 1..1 below to 1..last_test_to_print .
# (It may become useful if the test is moved to ./t subdirectory.)

BEGIN { $| = 1; print "1..5\n"; }
END {print "not ok 1\n" unless $loaded;}
use Text::NestedMatch;
$loaded = 1;
print "ok 1\n";

######################### End of black magic.

# Insert your test code below (better if it prints "ok 13"
# (correspondingly "not ok 13") depending on the success of chunk 13
# of the test code):

$_     = "(defun foo () (let ...))";
$defun = nested_match("$_ (foo)", '\(', '\)');
$foo   = skip_nested_match("$_ (foo)", '\(', '\)');

if ($defun eq "$_") {
    print "ok 2\n";
} else {
    print "not ok 2\n";
}

if ($foo eq " (foo)") {
    print "ok 3\n";
} else {
    print "not ok 3\n";
}

$_     = "asomethingBAelseb";
$some1 = nested_match($_, "a", "b");

$Text::NestedMatch::case_sensitive = 1;

$some2 = nested_match($_, "a", "b");

if ($some1 eq "asomethingB") {
    print "ok 4\n";
} else {
    print "not ok 4\n";
}

if ($some2 eq "asomethingBAelseb") {
    print "ok 5\n";
} else {
    print "not ok 5\n";
}

