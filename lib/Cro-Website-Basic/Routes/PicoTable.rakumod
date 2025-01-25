use Component;
use BaseLib;

use HTML::Functional :CRO;

my %data =
    :thead["Planet", "Diameter (km)", "Distance to Sun (AU)", "Orbit (days)"],
    :tbody[
        ["Mercury",  "4,880", "0.39",  "88"],
        ["Venus"  , "12,104", "0.72", "225"],
        ["Earth"  , "12,742", "1.00", "365"],
        ["Mars"   ,  "6,779", "1.52", "687"],
    ],
    :tfoot["Average", "9,126", "0.91", "341"],
;

my $template =
    h3 'Table',
    table |%data,
;

use Cro::HTTP::Router;
use Cro::WebApp::Template;

sub picotable-routes() is export {

    route {
        get -> {
            content 'text/html', $template;
        }
    }
}


#`[

my $routes = route {
    my $table = Table.new:
        :head[["Planet", "Fiameter (km)", "Distance to Sun (AU)", "Orbit (days)"],],
        :body[
            ["Mercury", "4,880" , "0.39", "88" ],
            ["Venus"  , "12,104", "0.72", "225"],
            ["Earth"  , "12,742", "1.00", "365"],
            ["Mars"   , "6,779" , "1.52", "687"],
        ],
        :foot[["Average", "9,126", "0.91", "341"],]
        ;

    my $themed  = $table.clone: :head-theme<light>;
    my $striped = $table.clone: :classes<striped>;

    my $tables = {
        :tables[ $table, $themed, $striped ],
    };

    template-location "resources/";
    get  -> {
        template "table.crotmp", $tables;
    }
}
#]

#`[
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
#]
