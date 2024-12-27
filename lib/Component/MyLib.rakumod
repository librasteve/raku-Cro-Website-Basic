use HTML::Functional;

my @manifest = <Results ActiveTable MyTable Grid>;
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
class MyTable does THead is export {
	has @.data;

	multi method new(@data, *%h) {
		$.new: :@data, |%h
	}

	method render {
		table :border<1>, [
			self.thead;
			tbody do for @!data -> @row {
				tr do for @row  -> $cell {
					td $cell
				}
			}
		];
	}
}

class ActiveTable does THead is export {
	method render {
		table :class<striped>, [
			self.thead;
			tbody :id<search-results>;
		]
	}
}

class Results is export {
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
class Grid is export {
	has @.items;

	multi method new(@items) {
		$.new: :@items
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

	for @manifest -> $name {

		OUR::{'&' ~ $name.lc} :=
			sub (*@a, *%h) {
				::($name).new( |@a, |%h ).render;
			}
	}
}
