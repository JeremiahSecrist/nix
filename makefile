include installed.env
help:
	@echo "no help for you"
switch:
	@sudo nixos-rebuild --flake ./#$(SYSTEM_NAME) switch
boot:
	@sudo nixos-rebuild --flake ./#$(SYSTEM_NAME) boot
test:
	@sudo nixos-rebuild --flake ./#$(SYSTEM_NAME) test
build:
	@sudo nixos-rebuild --flake ./#$(SYSTEM_NAME) build
dconf-dump:
	@dconf dump / > hm/$(MY_USER)/dconf.settings
dconf2nix: dconf-dump
	@dconf2nix -i hm/$(MY_USER)/dconf.settings -o hm/$(MY_USER)/dconf.nix
clean:
	@sudo nix-collect-garbage -d