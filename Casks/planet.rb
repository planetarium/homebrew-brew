cask "planet" do
  arch arm: "arm64", intel: "x64"

  version "0.46.0"
  sha256 arm:   "3734f8cacffd4be7c78cbba68945f25c884f9f924a82854647bc3697c60bd5e3",
         intel: "20ff0787776750477a339dfa81595bd674dddd31a9a4808ca14ca055ba25c993"

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
