{
  description = "A Nix-flake-based Elixir development environment";

  inputs.nixpkgs.url = "nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      supportedSystems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forEachSupportedSystem = f: nixpkgs.lib.genAttrs supportedSystems (system: f {
        pkgs = import nixpkgs { inherit system; };
      });
    in
    {
      devShells = forEachSupportedSystem ({ pkgs }: {
        default = pkgs.mkShell {
          packages = (with pkgs; [ beam.packages.erlang_26.elixir_1_16 nodejs_20 corepack ]) ++
            # Linux only
            (pkgs.lib.optionals (pkgs.stdenv.isLinux)
              (with pkgs; [ gigalixir inotify-tools libnotify ])) ++
            # macOS only
            pkgs.lib.optionals (pkgs.stdenv.isDarwin)
              ((with pkgs; [ terminal-notifier ]) ++
                (with pkgs.darwin.apple_sdk.frameworks; [ CoreFoundation CoreServices ]));
        };
      });
    };
}
