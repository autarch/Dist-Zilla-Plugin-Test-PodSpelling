#!/usr/bin/perl
use strict;
use warnings;
use utf8;
use Test::More 0.88;
use Test::DZil;
use Path::Tiny;

# test the file content generated when various attributes are set

my $fname  = 'Richard';
my $lname  = 'Simões';
my $author = join ' ', $fname, $lname;
sub get_content {
  my ($args) = @_;

  my $name = 'Test::PodSpelling';
  my $zilla = Builder->from_config(
    { dist_root => 'corpus/foo' },
    {
      add_files => {
        'source/lib/Spell/Checked.pm' => "package Spell::Checked;\n1;\n",
        'source/dist.ini' => dist_ini(
          {
            name             => 'Spell-Checked',
            version          => 1,
            abstract         => 'spelled wrong',
            license          => 'Perl_5',
            author           => $author,
            copyright_holder => $author,
          },
          [GatherDir =>],
          [$name => $args],
        )
      }
    }
  );

  $zilla->build;
  my $build_dir = $zilla->tempdir->subdir('build');
  my $file = path($build_dir, 'xt', 'author', 'pod-spell.t');
  return $file->slurp_utf8;
}

my $content = get_content({});
  like $content, qr/Pod::Wordlist/,            q[use default wordlist];
unlike $content, qr/set_spell_cmd/,            q[by default don't set spell command];
  like $content, qr/add_stopwords/,            q[by default we add stopwords];
  like $content, qr/__DATA__\s$fname\n$lname/, q[DATA handle includes author];

$content = get_content({wordlist => 'Foo::Bar'});
unlike $content, qr/Pod::Wordlist/, q[custom word list];
  like $content, qr/Foo::Bar/,      q[custom word list];

$content = get_content({spell_cmd => 'all_wrong'});
  like $content, qr/set_spell_cmd.+all_wrong/,    q[custom spell checker];

$content = get_content({stopwords => 'foohoo'});
  like $content, qr/__DATA__\s(.*\s)*foohoo\b/,   q[add stopwords];

done_testing;
