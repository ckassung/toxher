package Toxher::Model::ToxherDB;

use strict;
use base 'Catalyst::Model::DBIC::Schema';

__PACKAGE__->config(
    schema_class => 'Toxher::Schema',
    
    connect_info => {
        dsn => 'dbi:SQLite:toxher.db',
        user => '',
        password => '',
        sqlite_unicode => 1,
        on_connect_do => q{PRAGMA foreign_keys = ON},
    }
);

=head1 NAME

Toxher::Model::ToxherDB - Catalyst DBIC Schema Model

=head1 SYNOPSIS

See L<Toxher>

=head1 DESCRIPTION

L<Catalyst::Model::DBIC::Schema> Model using schema L<Toxher::Schema>

=head1 GENERATED BY

Catalyst::Helper::Model::DBIC::Schema - 0.66

=head1 AUTHOR

Christian Kassung

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
