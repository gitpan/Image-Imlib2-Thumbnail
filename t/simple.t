#!perl
use strict;
use warnings;
use lib 'lib';
use Path::Class;
use Test::More tests => 125;

use_ok('Image::Imlib2::Thumbnail');

dir( 't', 'tmp' )->rmtree;

my $thumbnail = Image::Imlib2::Thumbnail->new;

$thumbnail->add_size(
    {   type   => 'landscape',
        name   => 'header',
        width  => 350,
        height => 200
    }
);

foreach my $source (<t/*.png>) {
    my $basename = file($source)->basename;
    $basename =~ s/.png//;
    my $directory = dir( 't', 'tmp', $basename );
    $directory->mkpath;
    my @thumbnails = $thumbnail->generate( $source, $directory->stringify );
    my ($header) = grep { $_->{name} eq 'header' } @thumbnails;
    is( $header->{name},   'header' );
    is( $header->{width},  '350' );
    is( $header->{height}, '200' );
    is( $header->{type},   'landscape' );
}


