use Component;
use BaseLib;

use HTML::Functional :CRO;

my $html =
    div [
        h3 'Table';
        table $[[1, 2], [3, 4]], :thead<Left Right>;
    ],
    hr,
    div [
        h3 'Grid';
        grid $(1..6);
    ],
;

use Cro::HTTP::Router;
use Cro::WebApp::Template;

sub baseexamples-routes() is export {

    route {
        get -> {
            content 'text/html', $html;
        }
    }
}
