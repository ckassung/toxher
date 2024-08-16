package Toxher::View::HTML;
use parent 'Catalyst::View::TT';

use strict;
use warnings;

__PACKAGE__->config(
    TEMPLATE_EXTENSION => '.tt',
    render_die         => 0,
    PRE_PROCESS        => 'macros.tt',
    WRAPPER            => 'wrapper.tt',
);

1;
__END__

=head1 NAME

Toxher::View::HTML - TT View for Toxher

=head1 DESCRIPTION

TT View for Toxher.

=head1 SEE ALSO

L<Toxher>

=head1 AUTHOR

Christian Kassung

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
