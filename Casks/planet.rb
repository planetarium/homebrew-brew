cask "planet" do
  arch arm: "arm64", intel: "x64"

  version "0.44.1"
  sha256 arm:   "b2a8c5c5f6b973c4babe87b39590d63aeb67e4e81721e1834d0c58d46709942e",
         intel: "d55622cac1238e9bdbf7801ac0b2a9969c5bafda80181b8bb944dd46066edd50"

  url "https://github.com/planetarium/libplanet/releases/download/#{version}/planet-#{version}-osx-#{arch}.tar.xz",
      verified: "github.com/planetarium/libplanet/"
  name "planet"
  desc "Libplanet CLI tools"
  homepage "https://libplanet.io/"

  depends_on formula: "openssl"
  depends_on macos: ">= :mojave"

  binary "planet"

  postflight do
    set_permissions "#{staged_path}/planet", "0755"
    if OS.mac? && Hardware::CPU.arm?
      system "/usr/bin/codesign",
             "--sign",
             "-",
             "--force",
             "--preserve-metadata=entitlements,requirements,flags,runtime",
             "#{staged_path}/planet"
    end
  end
end
