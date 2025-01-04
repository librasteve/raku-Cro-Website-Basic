use Component;
use Component::BaseLib;

use Cro::HTTP::Router;
use Cro::Website::Basic::SiteLib;

use HTML::Functional :CRO;

my $location = 'happy_tm_xmas';
my $component = Component.new: :$location;
my $holder = [];

sub index {
    div [
        searchtable :thead<First Last Email>, :title("Search People"), :$holder, :$location;
    ]
}

sub happy_tm_xmas-routes() is export {
    route {
        $component.add:
            SearchTable,
            :load( -> UInt() $id { $holder.first: { .id == $id } }),
        ;

        get -> {
            content 'text/html', index;
        }
    }
}


