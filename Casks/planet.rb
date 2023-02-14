cask "planet" do
  arch arm: "arm64", intel: "x64"

  version "0.48.0"
  sha256 arm:   "37e1eda52edbd1bf30ba1b92934ecd27fa4eefbe428b73e417c94dfd00d1faa8",
         intel: "3c65e0897dc64295f25d302a19f1d238420c7c4fadf8a28cf39a93863cccd39e"

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
