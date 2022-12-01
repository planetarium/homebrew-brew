cask "planet" do
  arch arm: "arm64", intel: "x64"

  version "0.44.3"
  sha256 arm:   "c127fb15ab5bac32732a0dad963ee13b91b880cf4979f94f016e1ef94bea5cff",
         intel: "02c804732b728ca9bcbba5b00ba91b9c961f160792914466cd48026fcb0de866"

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
