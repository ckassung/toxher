package Toxher::Controller::Events;
use base 'Catalyst::Controller';

use strict;
use warnings;

use Data::FormValidator::Constraints qw(:closures);
use Date::Manip;

=head1 NAME

Toxher::Controller::Events - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=head2 default : Private

=cut

sub default : Private {
    my ( $self, $c ) = @_;
    $c->forward( 'list' );
}

=head2 list : Local

Fetch all event objects and pass to events/list.tt in stash to be displayed.

=cut

sub list : Local {
    my ( $self, $c ) = @_;
    $c->stash(
        content_class => 'wide',
        list          => [ $c->model('ToxherDB::Event')->search({}, {order_by => 'pubdate DESC'}) ],
        template      => 'events/list.tt',
        title         => 'All Events',
    );
}

=head2 view : Local

Shows all details to the wanted event.

=cut

sub view : Local {
    my ( $self, $c, $id ) = @_;
    my $item = $c->model( 'ToxherDB::Event' )->find( $id );
    if ( !$item ) {
        $c->detach( '/object_not_found' );
    }
    my $location_obj = $item->location;

    $c->stash(
        item     => $item,
        location => $location_obj,
        template => 'events/view.tt',
        title    => 'Details Event',
    );
}

=head2 edit : Local

Shows form for editing an event.

=cut

sub edit : Local {
    my ( $self, $c, $id ) = @_;
    my $item = $c->model( 'ToxherDB::Event' )->find( $id );
    if ( !$item ) {
        $c->detach( '/object_not_found' );
    }

    $c->stash(
        action   => 'edit',
        form     => {
            title    => $item->title,
            source   => $item->source,
            body     => $item->body,
            location => $item->location->id,
        },
        item     => $item,
        locations => [ $c->model( 'ToxherDB::Location' )->search( undef, {order_by => 'address'} ) ],
        template => 'events/form.tt',
        title    => 'Edit Event',
    );
    $c->stash->{form}->{pubdate} = UnixDate( $c->stash->{item}->pubdate, "%d.%m.%Y" );
}

=head2 do_edit : Local

=cut

sub do_edit : Local {
    my ( $self, $c, $id ) = @_;
    my $item = $c->model( 'ToxherDB::Event' )->find( $id );
    if ( !$item ) {
        $c->detach( '/object_not_found' );
    }

    my $pubdate = $c->req->param( 'pubdate' );
    $pubdate = ($pubdate =~ /^\d{4}$/) ? "$pubdate-00-00" : UnixDate( $pubdate, '%Y-%m-%d' );

    my $location = $c->req->param( 'location' );
    if ( !$c->model( 'ToxherDB::Location' )->find( $location ) ) {
        return $c->res->body( 'This location does not exist.' );
    }

    $item->title( $c->req->param( 'title' ) );
    $item->pubdate( $pubdate );
    $item->source( $c->req->param( 'source' ) );
    $item->body( $c->req->param( 'body' ) );
    $item->location_id( $location );
    
    $item->update;

    $c->forward( 'list' );
}

1;
__END__

=head1 AUTHOR

Christian Kassung

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
