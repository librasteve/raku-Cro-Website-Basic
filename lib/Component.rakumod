use Cro::WebApp::Template;
use Cro::HTTP::Router;

role Accessible {
	has Bool $.accessible = True;
}

multi trait_mod:<is>(Method $m, :$accessible!) is export {
	$m does Accessible
}

class Component {
	has $.location = '';
	has %.components;

	multi method add(*@components) {
		self.add: $_ for @components
	}

	multi method add(
		$component is copy,
		:&load is copy,
		:delete(&del) is copy,
		:&create is copy,
		:&update is copy,
		:$url-part = $component.^name.split('::').tail.lc,
	) {
		%!components.push: $component.^name => %(:&load, :&delete, :$component);

		post -> $url-part {
			request-body -> $data {
				my $new = create |$data.pairs.Map;
				redirect "/{$!location}/{$url-part}/{$new.id}", :see-other
			}
		}

		with &load {
			get -> $url-part, Int $id {
				my $comp = load $id;
				render-me $comp;
			}

			delete -> $url-part, Int $id {
				del $id;
				content 'text/html', ""
			} with &del;

			put -> $url-part, Int $id {
				request-body -> $data {
					my $comp = load $id;
					update $comp, |$data.pairs.Map
				}
			} with &update;

			#iamerejh ... think through
			#also only works once !!
			for $component.^methods -> $meth {
				my $name = $meth.name;

				if $meth.signature.params > 2 {
					put -> $url-part, Int $id, Str $name {
						request-body -> $data {
							my $comp = load $id;
							$comp."$name"(|$data.pairs.Map);
						}
					}
				} else {
					get -> $url-part, Int $id, Str $name {
						my $comp = load $id;
						$comp."$name"();
					}
				}
			}
		}
	}
}

sub render-me($comp) is export {
	content 'text/html', $comp.render;
}


# this partial code extracted from FCO/Cromponent afde916f5781cf3173ced75fc0658121fb6c8b7a   (Dec 8 2024)
# used here under Artistic 2.0
# author Fernando Corrêa de Oliveira <fernando.correa@humanstate.com>
