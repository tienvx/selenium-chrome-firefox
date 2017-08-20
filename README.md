selenium-chrome-firefox
===============

Docker image containing selenium `3.5.1`, google chrome `60`, firefox `55`, google chrome driver `2.31` and gecko driver `0.18.0`

## Usage

`docker run -d -p 4444:4444 --name docker-selenium tienvx/selenium-chrome-firefox`

It's better to disable marionette on firefox, because selenium does not support fully support firefox (e.g. you can't use mouseMoveTo feature)
