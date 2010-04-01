#!perl

use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/../lib";

our $iters;

BEGIN { $iters = $ENV{CAT_BENCH_ITERS} || 1; }

use Test::More tests => 24*$iters;
use Catalyst::Test 'TestApp';

if ( $ENV{CAT_BENCHMARK} ) {
    require Benchmark;
    Benchmark::timethis( $iters, \&run_tests );
}
else {
    for ( 1 .. $iters ) {
        run_tests();
    }
}

sub run_tests {
    {
        ok(
            my $response =
              request('http://localhost/action/chainedmatchargs/1/end/22/3'),
            'Request'
        );
        ok( $response->is_success, 'Response Successful 2xx' );
        is( $response->content_type, 'text/plain', 'Response Content-Type' );
        is(
            $response->header('X-Catalyst-Action-Private'),
            'action/chainedmatchargs/endpoint4',
            'Test Action'
        );
    }
    {
        ok(
            my $response =
              request('http://localhost/action/chainedmatchargs/1/end/2'),
            'Request'
        );
        ok( $response->is_success, 'Response Successful 2xx' );
        is( $response->content_type, 'text/plain', 'Response Content-Type' );
        is(
            $response->header('X-Catalyst-Action-Private'),
            'action/chainedmatchargs/endpoint1',
            'Test Action'
        );
    }
    {
        ok(
            my $response =
              request('http://localhost/action/chainedmatchargs/1/end/22'),
            'Request'
        );
        ok( $response->is_success, 'Response Successful 2xx' );
        is( $response->content_type, 'text/plain', 'Response Content-Type' );
        is(
            $response->header('X-Catalyst-Action-Private'),
            'action/chainedmatchargs/endpoint2',
            'Test Action'
        );
    }
    {
        ok(
            my $response =
              request('http://localhost/action/chainedmatchargs/1/end/2/33'),
            'Request'
        );
        ok( $response->is_success, 'Response Successful 2xx' );
        is( $response->content_type, 'text/plain', 'Response Content-Type' );
        is(
            $response->header('X-Catalyst-Action-Private'),
            'action/chainedmatchargs/endpoint3',
            'Test Action'
        );
    }
    {
        ## Repeat test to fail order sensitive action bugs
        ok(
            my $response =
              request('http://localhost/action/chainedmatchargs/2/partway/5x5/end/9'),
            'Request'
        );
        ok( $response->is_success, 'Response Successful 2xx' );
        is( $response->content_type, 'text/plain', 'Response Content-Type' );
        is(
            $response->header('X-Catalyst-Action-Private'),
            'action/chainedmatchargs/endpointx',
            'Test Action'
        );
    }
    {
        ## Repeat test to fail order sensitive action bugs
        ok(
            my $response =
              request('http://localhost/action/chainedmatchargs/1/end/22/3'),
            'Request'
        );
        ok( $response->is_success, 'Response Successful 2xx' );
        is( $response->content_type, 'text/plain', 'Response Content-Type' );
        is(
            $response->header('X-Catalyst-Action-Private'),
            'action/chainedmatchargs/endpoint4',
            'Test Action'
        );
    }
}
