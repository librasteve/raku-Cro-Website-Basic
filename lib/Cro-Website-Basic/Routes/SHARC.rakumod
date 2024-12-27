use Component;
use Component::BaseLib;

use HTML::Functional :CRO;

my $template =
    h3 'Table',
    div [
        table $[[1, 2], [3, 4]]  #, :thead<Left Right>;
    ],
    hr,
    h3 'Grid',
    div [
        grid $(1..6)
    ],
;

use Cro::HTTP::Router;
use Cro::WebApp::Template;

sub sharc-routes() is export {

    route {
        get -> {
            content 'text/html', $template;
        }
    }
}
