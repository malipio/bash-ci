#!/usr/bin/env bash

source "$STEPS_PATH" # implementation of common steps

curl http://someaddress/plugin.sh > some_plugin.sh && source some_plugin.sh
## or
load_plugin_from http://someaddress

build_gradle_wrapper
staging_heroku_jar infinite-caverns-43687
component_test_rest_json GET https://infinite-caverns-43687.herokuapp.com/  '.tip == "Do It Yourself!"'
production_heroku_jar quiet-shelf-20036