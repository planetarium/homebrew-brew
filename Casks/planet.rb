cask "planet" do
  arch arm: "arm64", intel: "x64"

  version "3.1.2"
  sha256 arm:   "10e7ea78ae4ec00c0b9d45330aaad28b2da2338891e6a79b218e0dc10bf80a13",
         intel: "854a1db4bc770a53562d946a9009595ddce12a4b666a26f14ba17962bd25d64b"

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
