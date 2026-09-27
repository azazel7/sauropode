{ config, lib, pkgs, ... }:
{
  config = {
    home.packages = with pkgs; [
      pdftk
      (pkgs.writeShellApplication {
        name = "pdfunit";
        runtimeInputs = [
          pkgs.pdftk  /* pdf tool kit */
        ];
        text = ''
          # Check if there are at least 1 input and 1 output
          if [ "$#" -lt 2 ]; then
              echo "Usage: pdfunit input1.pdf input2.pdf ... output.pdf"
              exit 1
          fi

          # Extract the last argument as the output file
          output_file="''${*: -1}"

          # Extract all arguments except the last one as input files
          # Note: We use ''${...} to explicitly tell Nix this is a Bash variable, not a Nix variable
          input_files=("''${@:1:$#-1}")

          # Execute pdftk safely handling spaces in filenames
          pdftk "''${input_files[@]}" cat output "$output_file"
        '';
      })
    ];
  };
}
