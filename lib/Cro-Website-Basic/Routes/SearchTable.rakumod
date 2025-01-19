use Component;
use Cro::HTTP::Router;

use Cro::Website::Basic::SiteLib;

use HTML::Functional :CRO;

sub searchtable-routes() is export {
    route {

        my $base = 'searchtable';
        SearchTable.^add-routes;

        get -> {
            content 'text/html',
                div [
                    searchtable :thead<First Last Email>, :title("Search People"), :$base, :id(0);
                ]
            ;
        }
    }
}
