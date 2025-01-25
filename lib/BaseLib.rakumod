unit module BaseLib;

use HTML::Functional;
use Component;

my @components = <Table Grid>;

role THead {
	has $.thead = [];

	method thead( --> Str() ) {
		thead do for |$!thead -> $cell {
			th $cell
		}
	}
}

role TFoot {
	has $.tfoot = [];

	method tfoot( --> Str() ) {
		tfoot do for |$!tfoot -> $cell {
			th $cell
		}
	}
}

#| viz. https://picocss.com/docs/table
class Table does Component {
	also does THead;
	also does TFoot;

	has $.tbody;

	multi method new(@tbody, *%h) {
		self.new: :@tbody, |%h;
	}

	method HTML {
		table :border<1>, [
			self.thead;
			tbody do for |$!tbody -> @row {
				tr do for @row -> $cell {
					td $cell
				}
			}
			self.tfoot;
		];
	}
}

#| https://picocss.com/docs/grid
class Grid does Component {
	has @.items;

	multi method new(@items, *%h) {
		self.new: :@items, |%h;
	}

	#| example of optional grid style from
	#| https://cssgrid-generator.netlify.app/
	method style {
		q:to/END/
		<style>
			.grid {
				display: grid;
				grid-template-columns: repeat(5, 1fr);
				grid-template-rows: repeat(5, 1fr);
				grid-column-gap: 0px;
				grid-row-gap: 0px;
			}
		</style>
		END
	}

	method HTML {
#		$.style ~
		div :class<grid>,
			do for @!items -> $item {
				div $item
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
				::($name).new( |@a, |%h ).HTML;
			}
	}
}

my package EXPORT::NONE { }
