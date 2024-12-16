use Cromponent;
use Cromponent::MyLib;

my $template;
my $topic;

{  #use a block to avoid namespace collision
    use HTML::Functional;

    $template =
        h3 'Table',
        div [
            mytable $[[1, 2], [3, 4]], :$topic
        ],
        hr,   #iamerejh
#        h3 'Grid',
#        div [
#            grid $(1..6), :$topic
#        ],
    ;

}

use Cro::HTTP::Router;
use Cro::WebApp::Template;

sub sharc-routes() is export {

    route {
        clear-components;
        add-components MyTable, Row, Cell;

        get -> {
            template-with-components $template, $topic;
        }
    }
}

