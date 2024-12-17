my @manifest = <Results ActiveTable THead HCell MyTable Row Cell Grid Item>;

class Cell is export {
	has $.data is required;

	multi method new($data) {
		$.new: :$data
	}

	method RENDER {
		q:to/END/
			<td><.data></td>
		END
	}
}

class Row is export {
	has Cell() @.cells is required;

	multi method new(@cells) {
		$.new: :@cells
	}

	method RENDER {
		q:to/END/
			<tr>
				<@.cells: $c>
					<&Cell($c)>
				</@>
			</tr>
		END
	}
}

#| https://picocss.com/docs/table TODO
class MyTable is export {
	has Row() @.rows is required;
	
	multi method new(@rows) {
		$.new: :@rows
	}

	method RENDER {
		q:to/END/
			<table border=1>
				<@.rows: $r>
					<&Row($r)>
				</@>
			</table>
		END
	}
}

class HCell is export {
	has $.data is required;

	multi method new($data) {
		$.new: :$data
	}

	method RENDER {
		q:to/END/
			<th><.data></th>
		END
	}
}

class THead is export {
	has HCell() @.cells is required;

	multi method new(@cells) {
		$.new: :@cells
	}

	method RENDER {
		q:to/END/
			<tr>
				<@.cells: $c>
					<&HCell($c)>
				</@>
			</tr>
		END
	}
}

class ActiveTable is export {
	has THead() $.thead;

	method RENDER {
		q:to/END/
			<table class="striped">
				<?.thead>
					<&THead(.thead)>
				</?>
				<tbody id="search-results">
				</tbody>
			</table>
		END
	}
}

class Results is export {
	has @.results;

	method RENDER {
		q:to/END/
			<@results>
			<tr>
				<td><.firstName></td>
				<td><.lastName></td>
				<td><.email></td>
			</tr>
			</@>
		END
	}
}

class Item is export {
	has $.data is required;

	multi method new($data) {
		$.new: :$data
	}

	method RENDER {
		q:to/END/
			<div><.data></div>
		END
	}
}

#| https://picocss.com/docs/grid
class Grid is export {
	has Item() @.items is required;

	multi method new(@items) {
		$.new: :@items
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

	method RENDER {
#		$.style ~
		q:to/END/
		<div class="grid">
			<@.items: $i>
				<&Item($i)>
			</@>
		</div>
		END
	}
}


##### HTML Functional Export #####

# put in all the tags programmatically
# viz. https://docs.raku.org/language/modules#Exporting_and_selective_importing
# TODO 				$topic.push: %h; (ie add named args to topic)

my package EXPORT::DEFAULT {
	for @manifest -> $name {

		my $label = $name.lc;

		OUR::{'&' ~ $label} :=
			sub (*@a, :$topic! is rw, *%h) {
				$topic{$label} = ::($name).new( |@a, |%h );
				'<&' ~ $name ~ '(.' ~ $label ~ ')>';
			}
	}
}
