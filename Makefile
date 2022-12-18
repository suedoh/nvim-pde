build:
	@docker build -t nvim .

run: build
	docker run -it -d --name nvim-ide nvim sh

exec:
	docker exec -it nvim-ide /bin/zsh

clean:
	docker container stop nvim-ide
	docker rm nvim-ide 
	docker rmi nvim
