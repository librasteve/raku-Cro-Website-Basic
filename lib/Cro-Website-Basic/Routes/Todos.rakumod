use Component;
use Component::MyLib;

my $component = Component.new: :location<todos>;

my UInt $next = 1;

class Todo {
    has UInt $.id = $next++;
    has Bool $.done is rw = False;
    has Str  $.data is required;

    method toggle {
        $!done = !$!done
    }

    method RENDER {
        qq:to/END/;
			<tr>
				<td>
					<input
						type=checkbox
						<?.done> checked </?>
						hx-get="/todos/todo/<.id>/toggle"
						hx-target="closest tr"
						hx-swap="outerHTML"
					>
				</td>
				<td>
					<?.done>
						<del><.data></del>
					</?>
					<!>
						<.data>
					</!>
				</td>
				<td>
					<button
						hx-delete="/todos/todo/<.id>"
						hx-confirm="Are you sure?"
						hx-target="closest tr"
						hx-swap="delete"
					>
						-
					</button>
				</td>
			</tr>
		END

    }

    method render {
        qq:to/END/;
			<tr>
				<td>
					<input
						type=checkbox
						 { $!done ?? 'checked' !! ' ' }
						hx-get="/todos/todo/{ $!id }/toggle"
						hx-target="closest tr"
						hx-swap="outerHTML"
					>
				</td>
				<td>
					 { $!done ?? "<del>{ $!data }</del>" !! $!data }
				</td>
				<td>
					<button
						hx-delete="/todos/todo/{ $!id }"
						hx-confirm="Are you sure?"
						hx-target="closest tr"
						hx-swap="delete"
					>
						-
					</button>
				</td>
			</tr>
		END

    }
}

class Frame {
    has Todo() @.todos;

    method render {
        qq:to/END/;
            <div>
                <table>
                     {@!todos.map: *.render}
                </table>
                <form
                    hx-post="/todos/todo"
                    hx-target="table"
                    hx-swap="beforeend"
                    hx-on::after-request="this.reset()"
                >
                    <input name=data><button type=submit>+</button>
                </form>
            </div>
        END

    }
}

use Cro::HTTP::Router;
use Cro::WebApp::Template;

sub todos-routes() is export {
        route {
        my @todos = do for <blablabla blebleble> -> $data { Todo.new: :$data }

        get -> {
            splooge Frame.new: :@todos;
        }

        $component.add:
            Todo,
            :load( -> UInt() $id { @todos.first: { .id == $id } }),
            :create(-> *%data { @todos.push: my $n = Todo.new: |%data; $n }),
            :delete( -> UInt() $id { @todos .= grep: { .id != $id } }),
        ;
    }
}
