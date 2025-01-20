use Component;

class Todo does Component {
    my UInt $next = 1;
    my Todo %holder;

    has UInt $.id = $next++;
    submethod TWEAK  { %holder{$!id} = self }

    method LOAD($id)      { %holder{$id} }
    method CREATE(*%data) { Todo.new: |%data }
    method DELETE         { %holder{$!id}:delete }

    method all { %holder.keys.sort.map: { %holder{$_} } }

    has Bool $.checked is rw = False;
    has Str  $.text is required;

    method toggle is routable {
        $!checked = ! $!checked;
        respond self;
    }

    method HTML {
        use HTML::Functional;

        tr(
          td(
            input(
                :type<checkbox>,
                :$!checked,
                :hx-get("/todos/todo/$!id/toggle"),
                :hx-target<closest tr>,
                :hx-swap<outerHTML>,
            )
          ),
          td(
              $!checked ?? del($!text) !! $!text
          ),
          td(
              button
                :type<submit>,
                :hx-delete("/todos/todo/$!id"),
                :hx-confirm<Are you sure?>,
                :hx-target<closest tr>,
                :hx-swap<delete>,
                    '-'
          ),
        );
    }
}

class Frame {
    has Todo() @.todos;

    method HTML {
        use HTML::Functional;

        div [
            table [@!todos.map: *.HTML];
            form
                :hx-post</todos/todo>,
                :hx-target<table>,
                :hx-swap<beforeend>,
                :hx-on:htmx:after-request<this.reset()>, [
                    input :name<text>;
                    button :type<submit>, '+';
                ]
            ;
        ]
    }
}

use Cro::HTTP::Router;

sub todos-routes() is export {
    route {
        do for <one two> -> $text { Todo.new: :$text }
        Todo.^add-routes;

        get -> {
            respond Frame.new: todos => Todo.all;
        }
    }
}