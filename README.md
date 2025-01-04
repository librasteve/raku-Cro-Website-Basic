[![License: Artistic-2.0](https://img.shields.io/badge/License-Artistic%202.0-0298c3.svg)](https://opensource.org/licenses/Artistic-2.0)

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

#### 02-sharc1

add Component (pre macro)
HTML focus - low integration SASS

#### 03-sharc2

add Todos

#### 04-sharrc3

merge latest Component xxx

#### 05-sharrc4 (from 04-sharrc3)

Cromponent => Component

- [x] No Cro templates
- [x] `content 'text/html', "html"`
- [x] `.render` returns HTML as Str

#### 06-sharrc5

- [x] split MyLib => BaseLib & SiteLib
- [x] holder pattern

#### 07-Red

searchtable with red data



bring pico table back in from sharrc2/3


# Name
- !sharrc  (too similar to Sparky)
- Ait or Cay


# TODOs
- [x] $topic var to handle multiple component instances
- [x] add non-fragment HTMX example, xmassify - active search
- [x] add todos & fix load, etc
- [x] export set of HTML::Functional to drop dupes (table, thead, etc...)
- [x] hone searchtable
  - [x] out to SiteLib
  - [x] use roles
  - [x] search as method
  - [x] adjust Todo toggle
  - [x] data model in Red
  - [x] make Red grep case insensitive
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