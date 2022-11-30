cask "planet" do
  arch arm: "arm64", intel: "x64"

  version "0.44.2"
  sha256 arm:   "5ec9c7e26eea9b5719a7699f08308a53b57e9de8a1f7d8b25ee63b3d7851e28d",
         intel: "e3819585648ed3965f78d30e117f539a58c94683d07496be2a630e011a4e80fe"

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
