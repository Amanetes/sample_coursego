setup:
	bin/setup

start:
	bin/rails s -p 3000 -b "0.0.0.0"

console:
	bin/rails console

sandbox:
	bin/rails console --sandbox

lint:
	bundle exec rubocop

fix:
	bundle exec rubocop -A

deploy:
	git push heroku main

heroku-logs:
	heroku logs --tail

test:
	NODE_ENV=test bin/rails test

.PHONY: test