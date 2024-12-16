use Cromponent;
use Cromponent::MyLib;

my $cromponent = Cromponent.new;
my $template;
my $topic;

{  #use a block to avoid namespace collision
    use HTML::Functional;

    $template =
        h3 'Table',
        div [
            mytable $[[1, 2], [3, 4]], :$topic
        ],
        hr,
        h3 'Grid',
        div [
            grid $(1..6), :$topic
        ],
    ;
}

use Cro::HTTP::Router;
use Cro::WebApp::Template;

sub sharc-routes() is export {

    route {
        $cromponent.add: MyTable, Row, Cell, Grid, Item;

        get -> {
            template-with-components $cromponent, $template, $topic;
        }
    }
}
