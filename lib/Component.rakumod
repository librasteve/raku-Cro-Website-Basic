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
				my $comp = load $id;
				render $comp;
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
sub render($component) is export {
	content 'text/html', $component.render;
}



=begin pod

=head1 NAME

Component - blah blah blah

=head1 SYNOPSIS

=begin code :lang<raku>

use Component;

=end code

=head1 DESCRIPTION

Component is ...

=head1 AUTHORS

librasteve <librasteve@fiurnival.net>
Fernando Corrêa de Oliveira <fernando.correa@humanstate.com>

=head1 COPYRIGHT AND LICENSE

Copyright 2024-2025 The Authors

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

=end pod
