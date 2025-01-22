use Component;

role HxTodo {
    method hx-toggle(--> Hash()) {
        :hx-get("$.url/$.id/toggle"),
        :hx-target<closest tr>,
        :hx-swap<outerHTML>,
    }

    method hx-create(--> Hash()) {
        :hx-post("$.url"),
        :hx-target<table>,
        :hx-swap<beforeend>,
        :hx-on:htmx:after-request<this.reset()>,
    }

    method hx-delete(--> Hash()) {
        :hx-delete("$.url/$.id"),
        :hx-confirm<Are you sure?>,
        :hx-target<closest tr>,
        :hx-swap<delete>,
    }
}

class Todo does HxTodo does Component {
    has Str  $.base = 'todos';
    has Str  $.url  = ($!base ?? "$!base/" !! '') ~ self.^name.lc;

    has Bool $.checked is rw = False;
    has Str  $.text is required;

    method toggle is routable {
        $!checked = ! $!checked;
        respond self;
    }

    method HTML {
        use HTML::Functional;

        tr
            td( input :type<checkbox>, :$!checked, |$.hx-toggle ),
            td( $!checked ?? del $!text !! $!text ),
            td( button :type<submit>, :style<width:50px>, |$.hx-delete, '-'),
    }
}

class Frame does HxTodo {
    has Todo() @.todos;
    has $.url = "todos/todo";

    method HTML {
        use HTML::Functional;

        div [
            table [@!todos.map: *.HTML];
            form  |$.hx-create, [
                input  :name<text>;
                button :type<submit>, '+';
            ];
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