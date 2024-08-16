use strict;
use warnings;

use Toxher;

my $app = Toxher->apply_default_middlewares(Toxher->psgi_app);
$app;

