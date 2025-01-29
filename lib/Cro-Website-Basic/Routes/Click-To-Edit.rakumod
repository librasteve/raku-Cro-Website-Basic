use HTML::Functional :CRO;
use Component;

class Contact does Component {
    has Str  $.base = 'click_to_edit';

    has $.data = {
        firstName => "Joe",
        lastName  => "Blow",
        email     => "joe@blow.com",
    };

    has @!names = <firstName lastName email>;  #in order

    class Key {
        has $.name;
        has $.data;

        method label { $!name.match(/ (<lower>+) (<upper><lower>+)* /)>>.tc.trim~": " }  #camelCase2Sentence Case
        method type  { $!name eq 'email' ?? 'email' !! 'text' }
        method value { $!data{$!name} }
    }

    has @!keys  = @!names.map: -> $name { Key.new(:$name, :$!data) };


    method edit is routable {
        respond
            form( :hx-put("$.url/$.id"), :hx-target<this> :hx-swap<outerHTML>, [
                for @!keys {
                    div label .label, input type=>.type, name=>.name, value=>.value
                }
                button('Submit'),
                button(:hx-get("$.url/$.id"), 'Cancel'),
            ]);
    }

    method HTML {
        div(:hx-target<this> :hx-swap<outerHTML>, [
            for @!keys {
                p .label, .value
            }
            button :hx-get("$.url/$.id/edit"), 'Click To Edit',
        ]);
    }
}

use Cro::HTTP::Router;

sub click_to_edit-routes() is export {
    route {
        Contact.^add-routes;
        my $contact = Contact.new: :id(0);

        get -> {
            respond $contact;
        }
    }
}

