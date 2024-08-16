use strict;
use warnings;

use ToHeDB;

my $app = ToHeDB->apply_default_middlewares(ToHeDB->psgi_app);
$app;

