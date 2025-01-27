unit module BaseLib;

use HTML::Functional;
use Component;

my @components = <Table Grid>;

#| viz. https://picocss.com/docs/table
class Table does Component {
	has $.tbody = [];
	has $.thead = [];
	has $.tfoot = [];
	has $.class;

	multi method new(@tbody, *%h) {
		self.new: :@tbody, |%h;
	}

	sub part($part, :$head) {
		do for |$part -> @row {
			tr do for @row.kv -> $col, $cell {
				given    $col, $head {
					when   *, *.so { th $cell, :scope<col> }
					when   0, * { th $cell, :scope<row> }
					default { td $cell }
				}
			}
		}
	}

	method thead { thead part($!thead, :head) }
	method tbody { tbody part($!tbody) }
	method tfoot { tfoot part($!tfoot) }

	method HTML {
		table |%(:$!class if $!class), [$.thead; $.tbody; $.tfoot;];
	}
}

#| viz. https://picocss.com/docs/grid
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
