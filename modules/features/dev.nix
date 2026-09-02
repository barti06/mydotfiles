{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    clang
    clang-tools
    cmake
    cmake-language-server
    cmake-format
    ninja
    gdb
    lldb

    python3
    cargo

    lazygit
    lua-language-server
    pyright
    typescript-language-server
    bash-language-server
    nixd

    vulkan-headers
    vulkan-tools
    vulkan-validation-layers
    renderdoc
    mesa-demos
  ];
}
