build:
	@docker build -t nvim-pde .

run: build
	docker run -it -d --name nvpde nvim-pde /bin/zsh

exec:
	docker exec -it nvpde /bin/zsh

clean:
	docker container stop nvpde
	docker rm nvpde
	docker rmi nvim-pde
