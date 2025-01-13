use Cromponent;

#use Component;
#use Component::BaseLib;

use Cro::HTTP::Router;
use Cro::Website::Basic::SiteLib;

use HTML::Functional :CRO;

my $base = 'searchtable';

sub index {
    div [
        searchtable :thead<First Last Email>, :title("Search People"), :$base;
    ]
}

sub searchtable-routes() is export {
    route {
        get -> {
            content 'text/html', index;
        }
    }
}
