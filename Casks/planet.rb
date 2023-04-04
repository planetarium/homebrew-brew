cask "planet" do
  arch arm: "arm64", intel: "x64"

  version "0.53.4"
  sha256 arm:   "962bb836c4ca4469137c3d9845a7bf95449e44512fb43125174cc232b0225c9d",
         intel: "91c2009e4efe744c4b792a4a9d5d72059d46d8bd4a58fa43b1da33086271f40e"

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
