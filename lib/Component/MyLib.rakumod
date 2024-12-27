use HTML::Functional;    # :CRO exclusions not needed here

my @components = <Results ActiveTable Table Grid>;
#warn self.thead.raku; $*ERR.flush;

role THead {
	has @.thead;

	method thead( --> Str() ) {
		thead do for @!thead -> $cell {
			th $cell
		}
	}
}

#| https://picocss.com/docs/table TODO
class Table does THead {
	has @.data;

	multi method new(@data, *%h) {
		$.new: :@data, |%h
	}

	method render {
		table :border<1>, [
			self.thead;
			tbody do for @!data -> @row {
				tr do for @row -> $cell {
					td $cell
				}
			}
		];
	}
}

class ActiveTable does THead {
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

#| https://picocss.com/docs/grid
class Grid {
	has @.items;

	multi method new(@items, *%h) {
		$.new: :@items, |%h
	}

	#| example of optional grid style from
	#| https://cssgrid-generator.netlify.app/
	# FIXME maybe functional?
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

	method render {
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
				::($name).new( |@a, |%h ).render;
			}
	}
}
