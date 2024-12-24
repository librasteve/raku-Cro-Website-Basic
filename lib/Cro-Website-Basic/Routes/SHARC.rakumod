use Component;
use Component::MyLib;

my $component = Component.new;
my $template;

{  #use a block to avoid namespace collision
    use HTML::Functional;

    $template =
        h3 'Table',
        div [
            x-mytable $[[1, 2], [3, 4]]
        ],
        hr,
        h3 'Grid',
        div [
            x-grid $(1..6)
        ],
    ;
}

use Cro::HTTP::Router;
use Cro::WebApp::Template;

sub sharc-routes() is export {

    route {
        $component.add: MyTable, Row, Cell, Grid, Item;  # FIXME

        get -> {
            content 'text/html', $template;
        }
    }
}
