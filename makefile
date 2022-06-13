include installed.env
help:
	@echo "no help for you"
switch:
	@sudo nixos-rebuild --flake ./#$(SYSTEM_NAME) switch
boot:
	@sudo nixos-rebuild --flake ./#$(SYSTEM_NAME) boot
test:
	@sudo nixos-rebuild --flake ./#$(SYSTEM_NAME) test