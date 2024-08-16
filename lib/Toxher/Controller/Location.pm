package Toxher::Controller::Location;
use base 'Catalyst::Controller';

use Moose;
use namespace::autoclean;

BEGIN {extends 'Catalyst::Controller'; }

use Data::FormValidator::Constraints qw(:closures);
use Date::Manip;

use Geo::Coder::OpenCage;
use Data::Dumper;

=head1 NAME

Toxher::Controller::Location - Catalyst Controller

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
 
Fetch all location objects and pass to location/list.tt in stash to be displayed.
 
=cut
 
sub list : Local {
    my ( $self, $c ) = @_;
    $c->stash(
        content_class => 'narrow',
        list          => [ $c->model( 'ToxherDB::Location' )->search(undef, {
                            select => [
                                'id',
                                'address',
                                'longitude',
                                'latitude',
                            ],
                            as => [qw/
                                id
                                address
                                lng
                                lat
                            /],
                            order_by => { -asc => 'address' },
                         }) ],
        template      => 'location/list.tt',
        title         => 'All Locations',
    );
}

=head2 view : Local

Shows all details to the wanted location.

=cut

sub view : Local {
    my ( $self, $c, $id ) = @_;
    my $item = $c->model( 'ToxherDB::Location' )->find({ id => $id }, {
                             select => [
                                'id',
                                'address',
                                'longitude',
                                'latitude',
                            ],
                            as => [qw/
                                id
                                address
                                lng
                                lat
                            /],
                            order_by => { -asc => 'address' },
        });

    if ( !$item ) {
        $c->detach( '/object_not_found' );
    }
    $c->stash(
        content_class => 'medium',
        item     => $item,
        lng      => $item->get_column('lng'),
        lat      => $item->get_column('lat'),
        template => 'location/view.tt',
        title    => 'Details Location',
    );
}

=head2 add : Local

Shows form for adding a location.

=cut

sub add : Local {
    my ( $self, $c ) = @_;
    $c->stash(
        action   => 'add',
        template => 'location/form.tt',
        title    => 'Add Location',
    );
}

=head2 do_add : Local

=cut

sub do_add : Local {
    my ( $self, $c ) = @_;

    my $ocg = Geo::Coder::OpenCage->new(
        api_key => '7b6bf33a9a7a44a9a159b47d912a921f',
        countrycode => 'de',
    );

    my $resp = $ocg->geocode( location => 'St. Maternusstraße 26, 56070 Koblenz' );
    my $lat = $resp->{'results'}->[0]->{'geometry'}{'lat'};
    my $lng = $resp->{'results'}->[0]->{'geometry'}{'lng'};
    my $wkt = 'POINT('.$lat.' '.$lng.')';

    ## quote names !?

    $c->stash->{action} = 'add';
    $c->forward( 'validate' );

    unless ($c->form->has_missing || $c->form->has_invalid) {
        my $item = $c->model('ToxherDB::Location')->create({
                # address    => scalar $c->form->valid('address'),
                address => $wkt,
                # coordinates => { ST_GeomFromText => $wkt },
            });
        $c->forward( 'list' );
    } 
    else {
        $c->stash(
            title    => 'Check input',
            template => 'location/form.tt',
        );
    };

    #$c->model( 'ToxherDB::Location' )->create({
    #    address => scalar $c->req->param( 'address' ),
    #});
    #$c->forward( 'list' );
    ### $c->res->redirect( $c->uri_for('/location/list') );
}

=head2 edit : Local

Shows form for editing a location.

=cut

sub edit : Local {
    my ( $self, $c, $id ) = @_;
    my $item = $c->model( 'ToxherDB::Location' )->find( $id );
    if ( !$item ) {
        $c->detach( '/object_not_found' );
    }

    $c->stash(
        action   => 'edit',
        form     => {
            address     => $item->address,
            coordinates => $item->coordinates,
        },
        item     => $item,
        template => 'location/form.tt',
        title    => 'Edit Location',
    );
}

=head2 do_edit : Local

=cut

sub do_edit : Local {
    my ( $self, $c, $id ) = @_;
    my $item= $c->model( 'ToxherDB::Location' )->find( $id );
    $item->address( $c->req->param( 'address' ) );
    $item->update;
    # $c->res->redirect( $c->uri_for('/location/list') );
    $c->forward( 'list' );
}

=head2 delete : Local

=cut

sub delete : Local {
    my ( $self, $c, $id ) = @_;
    my $item = $c->model( 'ToxherDB::Location' )->find( $id );
    eval {
        $item->delete;
    };
    # $c->res->redirect( $c->uri_for('/location/list') );
    $c->forward( 'list' );
}

sub validate : Private {
    my ($self, $c) = @_;

    my $dfv = {
        filters => 'trim',
        required => [qw/address/],
        constraint_methods => {
            address => constraint_address ( $c, {fields => 'address'} ),
        },
        validator_packages => __PACKAGE__,
        msgs => {
            constraints => {
                address_valid => 'The address input is invalid.',
            },
            format => '%s',
        },
    };
    $c->form($dfv);
}

sub constraint_address {
    return sub {
        my $dfv = shift;
        my $data = $dfv->get_input_data;

        return 1;
    }
}

1;
__END__

=head1 AUTHOR

Christian Kassung

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
