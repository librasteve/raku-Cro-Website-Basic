#`[
use Component;

my $component = Component.new: :location<todos>;

my UInt $next = 1;

class Todo {
    has UInt $.id = $next++;
    has Bool $.done is rw = False;
    has Str  $.data is required;

    method toggle {
        $!done = !$!done;
        render self;
    }

    method render {
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
#]

#[
use Component;
use Red:api<2>;

model Todo does Component {
    has UInt   $.id   is serial;
    has Bool() $.done is rw is column = False;
    has Str()  $.data is column is required;

    method LOAD(Str() $id)  { Todo.^load: $id }
    method CREATE(*%data)   { Todo.^create: |%data }
    method DELETE           { $.^delete }

    method toggle is accessible {
        $!done = !$!done;
        $.^save
    }

    method RENDER {
        q:to/END/;
			<tr id="todo-<.id>">
				<td>
					<label class="todo-toggle">
						<input
							type="checkbox"
							<?.done> checked </?>
							hx-get="todos/todo/<.id>/toggle"
							hx-target="closest tr"
							hx-swap="outerHTML"
						>
						<span class="custom-checkbox">
						</span>
					</label>
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
						hx-delete="todos/todo/<.id>"
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
#]

sub EXPORT() {
    Todo.^exports
}

#`[
class Frame does Component {
    has Todo() @.todos;

    method RENDER {
        q:to/END/;
            <div>
                <table>
                    <@.todos: $todo>
                        <&HTML($todo)>
                    </@>
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
        Todo.^add-component-routes;

        get -> {
            respond Frame.new: :@todos;
        }

#        $component.add:
#            Todo,
#            :load( -> UInt() $id { @todos.first: { .id == $id } }),
#            :create(-> *%data { @todos.push: my $n = Todo.new: |%data; $n }),
#            :delete( -> UInt() $id { @todos .= grep: { .id != $id } }),
#        ;
    }
}
#]


use Cro::HTTP::Router;
use Cro::HTTP::Server;
use Cro::WebApp::Template;

sub todos-routes() is export {
    route {
#        red-defaults "SQLite";   # FIXME move to Routes.rakumod? (cant mix)
        Todo.^create-table;
        template-location "templates/";

        Todo.^add-component-routes;

        get -> {
            template "todo-base.crotmp", { :todos(Todo.^all.Seq) }
        }
    }
}
