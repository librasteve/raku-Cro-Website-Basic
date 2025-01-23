multi trait_mod:<is>(Method $m, Bool :$routable!) is export {
	trait_mod:<is>($m, :routable{})
}

multi trait_mod:<is>(Method $m, :$routable! (:$name = $m.name)) is export {
	my role IsRoutable {
		has Str $.is-routable-name;
		method is-routable { True }
	}

	$m does IsRoutable($name)
}

use Cro::HTTP::Router;

role Component {

	# ID, Holder & URL Setup
	my  UInt $next = 1;
	has UInt $.id;

	my %holder;
	method holder { %holder }

	submethod TWEAK {
		$!id //= $next++;
		%holder{$!id} = self;
	}

	method url { (self.base ?? "{self.base}/" !! '') ~ self.^name.lc }

	# Default Actions
	method LOAD($id)      { $.holder{$id} }
	method CREATE(*%data) { ::?CLASS.new: |%data }
	method DELETE         { $.holder{$!id}:delete }
	method all { $.holder.keys.sort.map: { $.holder{$_} } }

	# Method Routes
	::?CLASS.HOW does my role ExportMethod {
		method add-routes(
			$component is copy,
			:&load is copy,
			:&create is copy,
			:delete(&del) is copy,
			:&update is copy,
			:$url-part = $component.^name.split('::').tail.lc,
		) is export {

			my $route-set := $*CRO-ROUTE-SET
					or die "Components should be added from inside a `route {}` block";

			&load   //= -> $id         { $component.LOAD: $id }      if $component.^can: "LOAD";
			&create //= -> *%pars      { $component.CREATE: |%pars } if $component.^can: "CREATE";
			&del    //= -> $id         { load($id).DELETE }          if $component.^can: "DELETE";
			&update //= -> $id, *%pars { load($id).UPDATE: |%pars }  if $component.^can: "UPDATE";

			with &load {
				with &create {
					note "adding POST $url-part";
					post -> Str $ where $url-part {
						request-body -> $data {
							my $new = create |$data.pairs.Map;
							redirect "$url-part/{ $new.id }", :see-other
						}
					}
				}

				note "adding GET $url-part/<id>";
				get -> Str $ where $url-part, $id {
					my $comp = load $id;
					respond $comp
				}

				with &del {
					note "adding DELETE $url-part/<id>";
					delete -> Str $ where $url-part, $id {
						del $id;
						content 'text/html', ""
					}
				}

				with &update {
					note "adding PUT $url-part/<id>";
					put -> Str $ where $url-part, $id {
						request-body -> $data {
							update $id, |$data.pairs.Map
						}
					}
				}

				for $component.^methods.grep(*.?is-routable) -> $meth {
					my $name = $meth.is-routable-name;

					if $meth.signature.params > 2 {
						note "adding PUT $url-part/<id>/$name";
						put -> Str $ where $url-part, $id, Str $name {
							request-body -> $data {
								load($id)."$name"(|$data.pairs.Map);
								redirect "../{ $id }", :see-other unless $component.^can: "HTML"
							}
						}
					} else {
						note "adding GET $url-part/<id>/$name";
						get -> Str $ where $url-part, $id, Str $name {
							load($id)."$name"();
							redirect "../{ $id }", :see-other unless $component.^can: "HTML"
						}
					}
				}
			}
		}
	}
}

sub respond($comp) is export {
	content 'text/html', $comp.HTML
}


=begin pod

=head1 NAME

Component - A way create web components without cro templates

=head1 SYNOPSIS

=begin code :lang<raku>

use Component;
class AComponent does Component {
	has $.data;

	method RENDER {
		Q:to/END/
		<h1><.data></h1>
		END
	}
}

sub EXPORT { AComponent.^exports }

=end code

=head1 DESCRIPTION

Component is a way create web components with cro templates

You can use Components in 3 distinct (and complementar) ways

=begin item

In a template only way:
If wou just want your Component to be a "fancy substitute for cro-template sub/macro",
You can simpley create your Component, and on yout template, <:use> it, it with export
a sub (or a macro if you used the C<is macro> trait) to your template, that sub (or macro)
will accept any arguments you pass it and will pass it to your Component's conscructor
(new), and use the result of that as the value to be used.

Ex:

=begin code :lang<raku>
use Component;

class H1 does Component is macro {
	has Str $.prefix = "My fancy H1";

	method RENDER {
		Q[<h1><.prefix><:body></h1>]
	}
}

sub EXPORT { H1.^exports }

=end code

On your template:

=begin code :lang<crotmp>

<:use H1>
<|H1(:prefix('Something very important: '))>
	That was it
</|>

=end code

=end item

=head1 AUTHOR

Steve Roe <librasteve@furnival.net>

=head1 COPYRIGHT AND LICENSE

Copyright 2025 Steve Roe

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

=end pod
