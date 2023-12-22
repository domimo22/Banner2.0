## Banner 2.0
Banner 2.0 is a dockerized program made in Python using Flask that serves as a course registration and transcript management service for students, professors and academic advisors. A quick demo presentation can be found here: https://drive.google.com/file/d/1vDjbuMqai9PV2ad3UJRoFSSqupz_DG3g/view?usp=share_link

- Running the program

First, install Docker and clone the Banner 2.0 repository.

In the secrets directory, remove the '.example' from the title of both password files, and enter a password into each file for the webapp user.

In the root directory, run 'docker compose build' in the terminal, and then 'docker compose up' to spin up the docker containers.


