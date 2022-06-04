return {
    cmd =  {
        "arduino-language-server",
        "-cli", "arduino-cli",
        "-cli-config", "~/.arduino15/arduino-cli.yaml",
        "-fqbn", "arduino:avr:uno",
        "-clangd", "clangd"
    }
}
