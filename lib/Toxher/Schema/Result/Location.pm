use utf8;
package Toxher::Schema::Result::Location;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Toxher::Schema::Result::Location

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 COMPONENTS LOADED

=over 4

=item * L<DBIx::Class::InflateColumn::DateTime>

=back

=cut

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 TABLE: C<location>

=cut

__PACKAGE__->table("location");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 address

  data_type: 'text'
  is_nullable: 1

=head2 longitude

  data_type: 'float'
  is_nullable: 1

=head2 latitude

  data_type: 'float'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "address",
  { data_type => "text", is_nullable => 1 },
  "longitude",
  { data_type => "float", is_nullable => 1 },
  "latitude",
  { data_type => "float", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 events

Type: has_many

Related object: L<Toxher::Schema::Result::Event>

=cut

__PACKAGE__->has_many(
  "events",
  "Toxher::Schema::Result::Event",
  { "foreign.location_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07052 @ 2024-06-23 00:05:44
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:J/g5LVjB4+L0sD4RGRVxNQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
