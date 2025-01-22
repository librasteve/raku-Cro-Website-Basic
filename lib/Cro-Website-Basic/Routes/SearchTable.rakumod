use Component;
use Cro::HTTP::Router;

use Cro::Website::Basic::SiteLib;

use HTML::Functional :CRO;

sub searchtable-routes() is export {
    route {
        SearchTable.^add-routes;

        get -> {
            content 'text/html',
                div [
                    searchtable :id(0), :base<searchtable>,
                        :title("Search People"),
                        :thead<First Last Email>;
                ]
            ;
        }
    }
}
