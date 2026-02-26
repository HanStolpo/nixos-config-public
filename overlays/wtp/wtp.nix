{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "wtp";
  version = "2.8.0";

  src = fetchFromGitHub {
    owner = "satococoa";
    repo = "wtp";
    rev = "v${version}";
    hash = "sha256-GAcwn+DJR4e3JMzh9mPZr6Y2G5RqSKQ3vlU1Yy0zQ0Y=";
  };

  vendorHash = "sha256-wX6TeALJojynP4ocOR45WkayVVwvTr2LUbfAxuns9SM=";

  subPackages = [ "cmd/wtp" ];

  # Tests require a git repository which isn't available in the nix sandbox
  doCheck = false;

  meta = with lib; {
    description = "A powerful Git worktree management tool";
    homepage = "https://github.com/satococoa/wtp";
    license = licenses.mit;
    maintainers = [ ];
    mainProgram = "wtp";
  };
}
