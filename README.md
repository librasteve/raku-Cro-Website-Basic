[![License: Artistic-2.0](https://img.shields.io/badge/License-Artistic%202.0-0298c3.svg)](https://opensource.org/licenses/Artistic-2.0)

Dear SmokeMachine

I am impressed with the work you have been doing with Cromponents, there are many areas that I agree we need a library like this to power up Cro.

Here are the things I like:

- easy to write components in crotmp
- nestable components
- dynamical operations are "self defined" - load, create, delete
- contained by parent (ie. @todos variable and $holder variable)
- clean approach to CSS
- potential to have MVC model with LOB (ie data model in Red)
- methods as component actions

I have had some frustrations with the flexibility of the earlier Cromponent implementations - partly I think this is my learning curve and lack of examples. So I hope that this is reduced and I think that stashing the added components in the Cro Routes sounds like a good strategy fo dealing with included routed (though I have not tried it yet).

In my previous feedback, I have mentioned that I would like to be able to build Cro components directly in raku code with the HTML::Functional library. This feedback has been poorly formed because my ideas of what I have wanted have been also in very early stages of formation - so apologies for any lack of clarity.

This repo is my attempt in the last two weeks to elaborate what I think is the set of features of a Component module to support the coding style that I seek - hopefully Cromponent can be adjusted to make this style possible in addition to the crotmp style. I would encourage you to start the server on your machine (see Getting Started info below to get a feel for what I am doing, especially with Pico CSS and SASS)

Here is the tree and some explanations:

lib
├── Component
│   └── BaseLib.rakumod           <== 2. my idea is that the Component module comes with a set of standard libraries
├── Component.rakumod             <== 1. this is a "stand in" for the Cromponent.rakumod module [1]
└── Cro-Website-Basic             <== 3. this is my current website project name ... likely to changes
    ├── Routes
    │   ├── BaseExamples.rakumod  <== 4a. this is an early wip to implement the Pico examples as a lib
    │   ├── SearchTable.rakumod   <== 4b. THIS is the main example of how I would like to use HTML::Functional
    │   └── Todos.rakumod         <== 4c. this is the FCO todos example test mostly unchanged
    ├── Routes.rakumod            <== 4. this is the main Cro routes file which includes Routes/^^
    └── SiteLib.rakumod           <== 5. this is a library of Components that I have build for my site project

Notes:
[1] I forked the Cromponent.rakumod file from FCO/Cromponent afde916f5781cf3173ced75fc0658121fb6c8b7a (Dec 8 2024) [prior to added macro support]
[2] Component libraries should also be pluggable and installable with zef in the usual way
[3] I think it would be nice to build example websites as raku modules and then others can fork and extend them
[4] There are 2 Lib rakumod files here - they all contain Components - the idea is that one comes with the Component module, one is built as the site implementation
[5] There is already potential for a Component library for the Pico CSS examples and the HTMX examples


Here are the areas where my work has drifted away after the fork from Cromponent... ie this is my objective set for HTML::Functional:

- write HTML::Functional code to generate HTML (eg in a render or RENDER method)
- use roles to call in fragments and hooks to call them in the parent render method (see `self.thead` in the example)
- ability to suppress the default Cromponent "refresh all" behaviour and to render fragments from eg contained components (eg. `method search` on ll76)
- a `render` method to be used within the Component (see bottom of Component.rakumod)
- provision of location and holder info from the invoker
- ability to use Components with long FQNs (I have hacked this into Component.rakumod)
- ability to use Red locally for models (which I guess you have in mind all along)
- general strong affinity to HTMX

Examples of these are set out mainly in the SearchTable.rakumod and Component.rakumod files

I hope that this is all clear, as mentioned I have not just stuck this as a PR on Cromponent since it is quite a major set of changes and tbh I do not know if these objectives can be met in your conception of Cromponent. All questions and comments welcome on the cro-irc or PM.

As stated elsewhere, Cromponent and the facility to have a component solution with crotmp is vital to the success of Cro - so these HTML::Functional needs are fairly parallel to the crotmp work. However, I have seen how successful functional HTML composition can be (Elm lang) and I have heard that React hooks (I do not know React btw) are an attempt to provide functional style coding experience to React??

In a perfect world we would have one Cromponent module that offers crotmp and functional styles for both writing and consumption of compatible components. I am optimistic that together we can achieve this and I will help where I can - but I think we need to be smart and not try to force this together if it wont fit naturally...

---

And, also on CSS. This work represents my first stab at Component-CSS integration. I think that the use of standard raku classes & roles is a promising fit between SASS (SCSS) mixin behaviours and raku roles but I have not had time (or need) to attach much CSS to each component I have built. So the following is quite flexible list of ideas that will need to be tried...

Here is my guess objective set for CSS:

- work with SASS libraries such as Pico (as done here) / Tailwind (it's not that I want Tailwind, but I think that many will)
- ability to rebuild on the fly (ie build step to monitor dir / rebuild SASS on source change)
- ability to set/get SASS vars from Components (?)
- ability to embed SASS within Components
- ability to use predefined SASS (likely some kind of class id nomenclature)

~librasteve

---

# Cro::Website::Basic

simple website written in Cro::WebApp

path is 
  1. get to the point where I can build a website on Cro the right way 
  2. build a static site example that could be a new design for raku.org and then offer it to the team, 
  3. add htmx based edit / preview to certain pages for admin (like the current rakudoc site), with raku syntax highlighting with Rainbow and 
  4. do something similar for markdown

# Component libs

https://chatgpt.com/share/67646547-ee48-8009-8354-0e4ced492f96
go for maximally decomposed apps

---

# Branches

#### 01-cro-htmx-pico-sass

Merry Xmas site with pico root overloaded for scale
Dark / light implemented via site reload

#### 02-red-searchtable

searchtable with red data

#### 03-ait-baseexamples

bring pico table back in


# TODOs
- [x] rm xmas & baubles

- do the full pico table example
- push pico/func up the stack (head, nav and so on)
- hamburger menu
- light dark better
- language switcher
- sitemap & robots.txt
- export BaseLib subset on demand None | SOME | ALL
- do all pico examples https://picocss.com/docs/
- do all htmx examples
- todos to library
- `is functional` trait
- docs maker from Red

# Local

## GETTING STARTED

Install raku - eg. from [rakubrew](https://rakubrew.org), then:

### Install Cro & Red
- `zef install --/test cro`
- `zef install Cro::WebApp`
- `zef install Red --exclude="pq:ver<5>"`

### Install this repo
- `git clone https://github.com/librasteve/raku-Cro-Website-Basic.git`
- `cd raku-Cro-Website-Basic` && `zef install .`

### Run and view it
- `export WEBSITE_HOST="0.0.0.0" && export WEBSITE_PORT="3000"`
- `raku -Ilib service.raku`
- Open a browser and go to `http://localhost:20000`

You will note that cro has many other options as documented at [Cro](https://cro.raku.org) if you want to deploy to a production server.


## TIPS & EXTRAS

- In development set CRO_DEV=1 in the [environment](https://cro.services/docs/reference/cro-webapp-template#Template_auto-reload)
- You can use `warn $data.raku; $*ERR.flush;` to say to the cro log window

---

# Server

## Development

### Pico CSS (IntelliJ)
install sass (in the static/css dir)
  - follow this [guide](https://www.jetbrains.com/help/webstorm/transpiling-sass-less-and-scss-to-css.html)
    - install IJ sass & file watcher plugins
    - `cd static/css`
    - `brew install npm`
    - `npm install -g sass`
    - `npm install @picocss/pico`
    - in styles.css, `@use "node_modules/@picocss/pico/scss";`
    - `sass styles.scss styles.css`  [target is then styles.scss/styles]
    - `--load-path=node_modules/@picocss/pico/scss/`
from https://picocss.org
  - some tweaks to root styles (mainly to reduce scale) from [here](https://github.com/picocss/pico/discussions/482)

## Deployment
- `zef install https://github.com/this.git --deps-only --/test`
- `git clone https://github.com/this.git && cd Cro::Website::Basic-Website`
- `zef install . --force-install --/test`
- adjust .cro.yml for your needs (e.g. HTTPS) -or-
- `export WEBSITE_HOST="0.0.0.0" && export WEBSITE_PORT="8888"`
- `raku -Ilib service.raku` -or-
- `nohup raku service.raku >> server.log 2>&1`  <=== detach from terminal [note PID]
- `tail -f server.log` and finally `kill -9 PID`  [ps -ef | grep raku]

## Build
this site runs on a linux server preloaded with git, raku, zef (& docker-compose)
- `sudo apt-get install build-essentials` (for Digest::SHA1::Native)
- viz. https://chatgpt.com/share/6748a185-c690-8009-96ff-80bf8018dd7d
  - `sudo apt-get install nginx`
  - `sudo systemctl start nginx`
  - `sudo systemctl enable nginx`
  - etc
  - `vi simple.raku`   <= port to 8888   
  - `raku simple.raku`
- using librasteve for certbot

---

# COPYRIGHT AND LICENSE

copyright(c) 2024 Contributors

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

---

## TODOS

NB. this will evolve as more work is done (e.g. docker)...

You can also build and run a docker image while in the app root using:

```
docker build -t this .
docker run --rm -p 8888:8888 this
```