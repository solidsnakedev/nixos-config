{ pkgs, ... }:
{
  programs.git = {
    enable = true;
    userName = "solidsnakedev";
    userEmail = "jona.ca.eng@gmail.com";
  };
}

