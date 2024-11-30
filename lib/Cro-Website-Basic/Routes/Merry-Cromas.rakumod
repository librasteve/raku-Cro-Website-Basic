use Cro::HTTP::Router;
use Cro::WebApp::Template;

sub merry_cromas-routes() is export {

    route {
        template-location 'templates/merry_cromas';

        get -> {
            template 'index.crotmp';
        }

        get -> 'tree_me' {
            template 'index.crotmp', :fragment<svg>, { };
        }

        get -> 'bauble_up' {
            template 'index.crotmp', :fragment<svg>, { :baubles };
        }

        get -> 'star_bright' {
            template 'index.crotmp', :fragment<svg>, { :stars };
        }

        get -> 'illuminati' {
            template 'index.crotmp', :fragment<svg>, { :baubles, :stars };
        }
    }
}

