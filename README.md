
# CSC394-Group2
idk what the site is going to be, but we're group 2

# Ruby Basic Set-Up
To get the Ruby on Rails app working:
- Navigate to the Week1MiniProject folder
- Run this command in your terminal: $ rails server
- Go to the port it lists (ex: http://127.0.0.1:3000)

To change HTML code:
- Navigate to Week1MiniProject/app/views/articles/index.html.erb and make the necessary changes


# Database Set-Up
To set up the databases locally:
- Download postgresql: https://www.postgresql.org/download/ (**REMEMBER THE DB SERVER PASSWORD YOU SET DURING THE INSTALLATION**)
- Download a GUI frontend for the DB for future use: https://www.pgadmin.org/download/
- Navigate to CSC394-Group2\Week1MiniProject\config\database.yml and open it in a text editor.
- Where it says "password:" Add your DB server password there. (ex: password: serverpassword)
- Run these two commands "rails db:create" and "rails db:migrate" to create and migrate the DB.


# Docker Set-up
- Download the appropriate version of Docker Desktop: https://www.docker.com/products/docker-desktop/
- (ONLY ON WINDOWS) Launch Docker Desktop once and install WSL (1 or 2, whichever's compatible).
- Create your ".env" file with the contents in the discord channel.
- To launch the containers, open the project directory and run these two commands.
- ```docker-compose build``` and ```docker-compose up```
- To delete a container, open Docker Desktop and delete the containers/images/volumes from there.
- After launching the containers, access the webpage with this link: http://localhost:80

# Confirm The Project Is Running Properly
- To make sure that your page is running as expected, open the "Inspect" tool by right clicking the webpage.
- Once within the "Inpect" tool, navigate to the "Network" tab within the inpsect tool, and refresh the page.
- Navigate to the "localhost" within the "Name" section, then look for "Server" within the "Headers" subtab. 
- "Server" should read as "nginx/1.25.3" as seen in image below.
![image](https://github.com/sebi12391/CSC394-Group2/assets/89634008/34d16fa5-f6dd-4362-90ca-741115cb4efa)

