cask "planet" do
  arch arm: "arm64", intel: "x64"

  version "2.2.0"
  sha256 arm:   "fd7aa204933cdeeeccd66e355dc05d0735330803bdccee8f5ddca2f7fe798773",
         intel: "374ed62fb7b4ac1cde451cab8a7bc49f0a17ae62d2c7cd0c595ab01a8be99c91"

  url "https://github.com/planetarium/libplanet/releases/download/#{version}/planet-#{version}-osx-#{arch}.tar.xz",
      verified: "github.com/planetarium/libplanet/"
  name "planet"
  desc "Libplanet CLI tools"
  homepage "https://libplanet.io/"

  depends_on formula: "openssl"
  depends_on macos: ">= :mojave"

  binary "planet"

  postflight do
    if OS.send(:mac?) && Hardware::CPU.send(:arm?)
      Dir::Tmpname.create("workaround") do |tmppath|
        FileUtils.cp "#{staged_path}/planet", tmppath
        FileUtils.mv tmppath, "#{staged_path}/planet"
      end
      system "/usr/bin/codesign",
             "--sign",
             "-",
             "--force",
             "--preserve-metadata=entitlements,requirements,flags,runtime",
             "#{staged_path}/planet"
    end
    set_permissions "#{staged_path}/planet", "0755"
    (HOMEBREW_PREFIX/"etc"/"bash_completion.d"/"planet").write(
      system_command("#{staged_path}/planet", args: ["--completion", "bash"]).stdout,
    )
    (HOMEBREW_PREFIX/"share"/"zsh"/"site-functions"/"planet").write(
      system_command("#{staged_path}/planet", args: ["--completion", "zsh"]).stdout,
    )
  end

  uninstall_postflight do
    (HOMEBREW_PREFIX/"etc"/"bash_completion.d"/"planet").unlink
    (HOMEBREW_PREFIX/"share"/"zsh"/"site-functions"/"planet").unlink
  end
end
