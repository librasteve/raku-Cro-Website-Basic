use Component;
use Component::BaseLib;
use Cro::Website::Basic::SiteLib;

use HTML::Functional :CRO;

my $component = Component.new: :location<happy_tm_xmas>;

sub index($at) {
    div [
        h3 [
            'Search Names',
            span :class<htmx-indicator>, [img :src</img/bars.svg>; '  Searching...']
        ];

        input :type<search>, :name<needle>,
              :placeholder<Begin typing to search...>,
              :hx-put</happy_tm_xmas/activetable/1/search>,
              :hx-trigger<keyup changed delay:500ms, search>,
              :hx-target<#search-results>,
              :hx-swap<outerHTML>,
              :hx-indicator<.htmx-indicator>;

        div $at.render;

#        activetable :thead<Given Elven Elfmail>;
    ];
}


use Cro::HTTP::Router;
use Cro::WebApp::Template;

sub happy_tm_xmas-routes() is export {
    route {
        my $at = ActiveTable.new: :thead<First Last Email>;

        $component.add:
            ActiveTable,
            :load( -> UInt() $id {$at} );  # FIXME ignores id (only one)
        ;

        get -> {
            content 'text/html', index($at);
        }
    }
}


