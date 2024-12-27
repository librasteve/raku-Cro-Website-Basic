unit module Cro-Website-Basic::SiteLib;

use HTML::Functional;    # :CRO exclusions not needed here
use Component::BaseLib :NONE;


my @components = <Results ActiveTable>;
#warn self.thead.raku; $*ERR.flush;

class ActiveTable does Component::BaseLib::THead {
	method render {
		table :class<striped>, [
			self.thead;
			tbody :id<search-results>;
		]
	}
}

class Results {
	has @.results;

	method render {
		tbody :id<search-results>,
			do for @!results {
				tr
					td .<firstName>,
					td .<lastName>,
					td .<email>,
			}
		;
	}
}


##### HTML Functional Export #####

# put in all the tags programmatically
# viz. https://docs.raku.org/language/modules#Exporting_and_selective_importing

my package EXPORT::DEFAULT {

	for @components -> $name {

		OUR::{'&' ~ $name.lc} :=
			sub (*@a, *%h) {
				::($name).new( |@a, |%h ).render;
			}
	}
}
