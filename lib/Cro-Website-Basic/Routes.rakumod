use Cro::HTTP::Router;
use Cro::WebApp::Template;

sub routes() is export {
    route {
        template-location 'templates';

        get -> {
            template 'index.crotmp', { :dark-mode };
        }

        get -> 'css', *@path {
            static 'static/css', @path;
        }

        get -> 'img', *@path {
            static 'static/img', @path;
        }

        get -> 'js', *@path {
            static 'static/js', @path;
        }

        get -> *@path {
            static 'static', @path;
        }

        get -> 'dark-mode' {
            template 'index.crotmp', { :dark-mode };
        }

        get -> 'light-mode' {
            template 'index.crotmp', { :light-mode };
        }

        use Cro::Website::Basic::Routes::Merry-Cromas;
        include merry_cromas => merry_cromas-routes;

        use Cro::Website::Basic::Routes::Happy-TM-Xmas;
        include happy_tm_xmas => happy_tm_xmas-routes;
    }
}
