package Text::NestedMatch;

use strict;
use vars qw($VERSION @ISA @EXPORT $case_sensitive);

require 5.000;
require Exporter;
require AutoLoader;

@ISA = qw(Exporter AutoLoader);
@EXPORT = qw(
  nested_match
  skip_nested_match
);
$VERSION = '1.03';

$case_sensitive = 0;

# Nested match finds strings delimited by regexp "$start" and "$end".  
# In the case where $start and $end may be nested, nested_match always
# returns the balanced match.  So, for example, a nested_match of
# "((this is a test))(of something)" with $start="\(" and $end="\)",
# returns "((this is a test))".

# In an array context, nested_match returns the matched string and the
# rest of the data as a two element list.  In a scalar context, it
# returns just the matched data.

sub nested_match {
    my($search, $start, $end) = @_;
    my($count) = 0;
    my($matched) = "";
    local($_);

    # Make a copy of the search string so that we can handle case
    # sensitivity.  Is there a better way to do this?  Ideally,
    # m//$mopts; would work, but it doesn't.

    if ($case_sensitive) {
	$_     = $search;
    } else {
	$_     = lc($search);
	$start = lc($start);
	$end   = lc($end);
    }

    if ($start eq $end) {
	($matched, $_) = /^(.*?$start.*?$end)(.*)$/s;
    } else {
	while (/($start)|($end)/s) {
	    my($pre, $match, $post) = ($`, $&, $');
	    $matched .= $pre . $match;

	    if ($match =~ /^$end$/s) {
		$count--;
	    } else {
		$count++;
	    }

	    $_ = $post;
	    last if $count == 0;
	}
    }

    if (!$case_sensitive) {
	# make sure we get back the un-lc()'d string
	$matched = substr($search, 0, length($matched));
	$_ = substr($search, length($matched));
    }

    return wantarray ? ($matched, $_) : $matched;
}

# In an array context, skip_nested_match returns the matched string and the
# rest of the data as a two element list.  In a scalar context, it
# returns just the rest of the data.

sub skip_nested_match {
    my($matched, $rest) = nested_match(@_);
    return wantarray ? ($matched, $rest) : $rest;
}

1;
__END__
# Below is the stub of documentation for your module. You better edit it!

=head1 NAME

Text::NestedMatch - Perl extension to find regexp delimited strings with proper nesting

=head1 SYNOPSIS

  use Text::NestedMatch;

  ($match,$remainder) = nested_match($string, $startdelim, $enddelim);
  $match              = nested_match($string, $startdelim, $enddelim);
  $remainder          = skip_nested_match($string, $startdelim, $enddelim);

  # Make the start and end delimiters case sensitive.  Off by default.
  $Text::NestedMatch::case_sensitive = 1;

=head1 DESCRIPTION

These routines allow you to extract properly nested strings out of
a larger string.  The start and end delimiters are regular expressions.
If the string does not begin with $startdelim, everything up to the
first $startdelim will be included on the matched string.

=over 4

=item nested_match

The nested_match() routine searches for a properly nested substring.
It returns the match in a scalar context or both the match and the
remainder in a list context.

=item skip_nested_match

The skip_nested_match() routine searches for a properly nested substring.
It returns the remainder in a scalar context or both the match and the
remainder in a list context.

=back

=head1 EXAMPLES

    ($lispexpr, $rest) = nested_match ("(defun () (let ...)) (defun ...)",
                                       "(", ")");

would yield

    $lispexpr eq '(defun () (let ...))'
    $rest     eq ' (defun ...)';

and

    $rest = skip_nested_match($dtd_fragment, '<UL>', '<\/UL>');

will skip over a <UL> element in an SGML document.  Note that
the backslash is quoted, the start and end delimiters are
regular expressions.

=head1 AUTHOR

Norman Walsh, norm@berkshire.net

=head1 COPYRIGHT

Copyright (c) 1996, 1997 Norman Walsh.  All rights reserved.
This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=head1 SEE ALSO

perl(1).

=cut
