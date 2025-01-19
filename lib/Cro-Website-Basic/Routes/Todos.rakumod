use Component;

class Todo does Component {
    my UInt $next = 1;
    my %holder;

    has UInt $.id = $next++;
    has Bool $.done is rw = False;
    has Str  $.text is required;

    submethod TWEAK  { %holder{$!id} = self }

    method all { %holder.values }

    method LOAD($id)      { %holder{$id} }
    method CREATE(*%data) { Todo.new: |%data }
    method DELETE         { %holder{$!id}:delete }

    method toggle is routable {
        $!done = ! $!done;
        respond self;
    }

    method RESPOND {
        qq:to/END/;
			<tr>
				<td>
					<input
						type=checkbox
                        { $!done ?? 'checked' !! '' }
						hx-get="/todos/todo/{ $!id }/toggle"
						hx-target="closest tr"
						hx-swap="outerHTML"
					>
				</td>
				<td>
					 { $!done ?? "<del>{ $!text }</del>" !! $!text }
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

    method RESPOND {
        qq:to/END/;
            <div>
                <table>
                     { @!todos.map: *.RESPOND }
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
#use Cro::WebApp::Template;

sub todos-routes() is export {
    route {
        do for <one two> -> $text { Todo.new: :$text }
        Todo.^add-component-routes;

        get -> {
            respond Frame.new: todos => Todo.all;
        }
    }
}