# Amigo Secreto

![image](/public/amigo_secreto.png)

IP Digital Ocean: http://104.131.183.130/

Secret Santa is a well known Christmas game. A person is randomly assigned to each of the participants. Each participant then has to give this person a gift, and in turn, receives a gift from an anonymous member of the group. Often, drawing names for the secret Santa game is not that simple. Some people use folded up bits of paper with the names of the participants written on them, and then hand them out. The problem is that we don’t want a couple, for example, to be paired with each other. Or, if we’re playing with a group of cousins, we might not want siblings to be paired up. So, we’re forced to repeat the process, and it gets messier and messier. In addition, everybody needs to be present for the secret Santa drawing, because the best thing about the game is that no one knows who anyone’s secret Santa is. That's why we made this simple application that solves the problem

## Installation

This app runs on a docker container. The following commands are necessary to set up the environment on your machine.

* Make sure you have docker and docker-compose installed.

* Run ```docker-compose build``` to install all gems.

* Run ```docker-compose up``` to start the application.

* The app should be available on http://localhost:3000

For production don't forget run ```docker-compose run --rm app bundle exec rake assets:precompile```

## Database

To create a database and run all migrations. Run:

```
docker-compose run --rm app rails db:create && docker-compose run --rm app rails db:migrate
```

## Tests

The rspec gem is used for testing. The following command should run them.

```
docker-compose run --rm app rspec
```
