{ config, pkgs, stdenv, lib, ... }: {
  home.file = {
    u2fKeys = {
      target = ".config/Yubico/u2f_keys";
      text =
        "sky:TCSOBHxXpt4Y5ObYuAIHBwSwzbFKo28k0uUzlMrmX/pmBQ1HMLRbdUjv5OdmQDdzRznD0bDbJa1KWRiVX4gR9w==,z+nivJZ8lfzmxWDODA5GqHbRz1Si+aXklml/NfNvDgTS80wjbPvgzWomRQN551dqpHcqRmUygLbcXFhwy0J0lQ==,es256,+presence";
    };
  };
}
