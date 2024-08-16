use strict;
use warnings;
use Test::More;


use Catalyst::Test 'Toxher';
use Toxher::Controller::Locations;

ok( request('/locations')->is_success, 'Request should succeed' );
done_testing();
