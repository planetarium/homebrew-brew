cask "planet" do
  arch arm: "arm64", intel: "x64"

  version "0.45.0"
  sha256 arm:   "36ab88402c7f64c95f7d5cbfaef5803a31c8dddc433d02764e8762d36636d309",
         intel: "1ff074ce4d652dd7c4339bac47a5d39a4e76713f16df19a4f2376f2ea0204771"

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
