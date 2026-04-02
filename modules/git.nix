{ pkgs, ... }:
{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "solidsnakedev";
        email = "jona.ca.eng@gmail.com";
      };
      core = {
        editor = "nvim";
      };
      url = {
        "git@github.com:" = {
          insteadOf = "https://github.com/";
        };
      };
    };
  };
}

