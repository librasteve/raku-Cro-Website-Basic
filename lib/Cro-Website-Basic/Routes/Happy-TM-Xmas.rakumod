use Cromponent;
use Cromponent::MyLib;

my $template;
my $topic;

{  #use a block to avoid namespace collision
    use HTML::Functional;

    $template =
        div [
            mytable $[[1, 2], [3, 4]], :$topic;
            row $[5,6], :$topic;
            cell 42, :$topic;
        ],
        hr,
        div [
            grid $(1..6), :$topic
        ];

    warn $template; $*ERR.flush;
}

use Cro::HTTP::Router;
use Cro::WebApp::Template;

sub happy_tm_xmas-routes() is export {

    route {
        add-components MyTable, Row, Cell, Grid, Item;

        get -> {
            template-with-components $template, $topic;
        }
    }
}

