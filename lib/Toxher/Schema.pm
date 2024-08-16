use utf8;
package Toxher::Schema;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use Moose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Schema';

__PACKAGE__->load_namespaces;


# Created by DBIx::Class::Schema::Loader v0.07052 @ 2024-05-14 15:44:50
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:u+hsBDejls0lHLnPgxaZsQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable(inline_constructor => 0);
1;
