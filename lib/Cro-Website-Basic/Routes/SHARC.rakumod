use Component;
use Component::MyLib;

my $component = Component.new;
my $template;
my $topic;

{  #use a block to avoid namespace collision
    use HTML::Functional;

    $template =
        h3 'Table',
        div [
            x-mytable $[[1, 2], [3, 4]], :$topic
        ],
        hr,
        h3 'Grid',
        div [
            x-grid $(1..6), :$topic
        ],
    ;
}

use Cro::HTTP::Router;
use Cro::WebApp::Template;

sub sharc-routes() is export {

    route {
        $component.add: MyTable, Row, Cell, Grid, Item;

#        get -> {
#            template-with-components $component, $template, $topic;
#        }

        get -> {
            content 'text/html', $template;
        }
    }
}
