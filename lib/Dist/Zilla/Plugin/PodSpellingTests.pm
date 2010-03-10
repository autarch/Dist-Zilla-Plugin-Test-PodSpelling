use 5.008;
use strict;
use warnings;

package Dist::Zilla::Plugin::PodSpellingTests;
# ABSTRACT: release tests for POD spelling
use Moose;
use Pod::Wordlist::hanekomu;
use Test::Spelling;
extends 'Dist::Zilla::Plugin::InlineFiles';

__PACKAGE__->meta->make_immutable;
no Moose;
1;

=pod

=for test_synopsis
1;
__END__

=head1 SYNOPSIS

In C<dist.ini>:

    [PodSpellingTests]

=head1 DESCRIPTION

This is an extension of L<Dist::Zilla::Plugin::InlineFiles>, providing the
following files

  xt/release/pod-spell.t - a standard Test::Spelling test

=cut

__DATA__
___[ xt/release/pod-spell.t ]___
#!perl

use Test::More;

eval "use Pod::Wordlist::hanekomu";
plan skip_all => "Pod::Wordlist:hanekomu required for testing POD spelling"
  if $@;

eval "use Test::Spelling";
plan skip_all => "Test::Spelling required for testing POD spelling"
  if $@;

all_pod_files_spelling_ok('lib');

