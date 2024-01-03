cask "megazeux" do
  version "2.92f"
  sha256 "1c4807ff44f27a41b1131a08eb42c4d07e783653380150a980f2f9e3d2a4836e"

  url "https://github.com/AliceLR/megazeux/releases/download/v#{version}/mzx#{version.no_dots}-intel-universal.dmg",
      verified: "github.com/AliceLR/megazeux/"
  name "MegaZeux"
  desc "ASCII-based game creation system"
  homepage "https://www.digitalmzx.com/"

  # Releases often do not have MacOS binaries for some time after release
  livecheck do
    url :url
    regex(/^mzxv?(\d+(?:\.\d+)?+[a-f]?)[._-]intel.*?\.(?:dmg|pkg|zip)$/i)
    strategy :github_releases do |json, regex|
      json.map do |release|
        next if release["draft"] || release["prerelease"]

        release["assets"]&.map do |asset|
          match = asset["name"]&.match(regex)
          next if match.blank?

          "#{match[1][0]}.#{match[1][1..]}"
        end
      end.flatten
    end
  end

  app "MegaZeux.app"
  artifact "Documentation", target: "~/Library/Application Support/MegaZeux/Documentation"

  zap trash: [
    "~/.megazeux-config",
    "~/Library/Application Support/MegaZeux",
  ]
end
