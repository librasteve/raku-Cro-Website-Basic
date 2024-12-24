use Cro::WebApp::Template;
use Cro::HTTP::Router;

# this fork from FCO/Cromponent afde916f5781cf3173ced75fc0658121fb6c8b7a   (Dec 8 2024)
# pre macro "improvements" - used here under Artistic 2.0

# major changes have been applied subsequently

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
		:$url-part = $component.^name.lc,
	) {
		%!components.push: $component.^name => %(:&load, :&delete, :$component);

		post -> Str $ where $url-part {
			request-body -> $data {
				my $new = create |$data.pairs.Map;
				redirect "/{$!location}/{$url-part}/{ $new.id }", :see-other
			}
		}

		with &load {
			get -> Str $ where $url-part, $id {
				my $tag = $component.^name;
				my $comp = load $id;
				template-with-components self, "<\&{ $tag }( .comp )>", { :$comp };
			}

			delete -> Str $ where $url-part, $id {
				del $id;
				content 'text/html', ""
			} with &del;

			put -> Str $ where $url-part, $id {
				request-body -> $data {
					my $comp = load $id;
					update $comp, |$data.pairs.Map
				}
			} with &update;

			for $component.^methods -> $meth {
				my $name = $meth.name;

				if $meth.signature.params > 2 {
					put -> Str $ where $url-part, $id, Str $name {
						request-body -> $data {
							load($id)."$name"(|$data.pairs.Map);
							redirect "/{$!location}/{ $url-part }/{ $id }", :see-other
						}
					}
				} else {
					get -> Str $ where $url-part, $id, Str $name {
						load($id)."$name"();
						redirect "/{$!location}/{ $url-part }/{ $id }", :see-other
					}
				}
			}
		}
	}
}

sub template-with-components($component, $template, $data!) is export {

	my $header = $component.components.values.map({
		my $name = .<component>.^name;
		my $t    = .<component>.RENDER;
		"<:sub {$name}(\$_)> $t </:>"
	}).join: "\n";

	template-inline "$header \n\n\n$template", $data;
}

#!iamerejh
sub splooge($component) is export {
	content 'text/html', $component.render;
}



=begin pod

=head1 NAME

Cromponent - blah blah blah

=head1 SYNOPSIS

=begin code :lang<raku>

use Cromponent;

=end code

=head1 DESCRIPTION

Cromponent is ...

=head1 AUTHOR

Fernando Corrêa de Oliveira <fernando.correa@humanstate.com>

=head1 COPYRIGHT AND LICENSE

Copyright 2024 Fernando Corrêa de Oliveira

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

=end pod
