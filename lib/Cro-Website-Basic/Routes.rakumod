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

        use Cro::Website::Basic::Routes::SearchTable;
        include searchtable => searchtable-routes;

        use Cro::Website::Basic::Routes::BaseExamples;
        include baseexamples => baseexamples-routes;

        use Cro::Website::Basic::Routes::PicoTable;
        include picotable => picotable-routes;

        # ! FIXME - currently cant make both the following route sets coexist
#        use Cro::Website::Basic::Routes::Todos;
#        include todos => todos-routes;

        use Cro::Website::Basic::Routes::Click-To-Edit;
        include click_to_edit => click_to_edit-routes;
    }
}
