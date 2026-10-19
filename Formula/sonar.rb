class Sonar < Formula
  desc "CLI tool for SonarQube"
  homepage "https://github.com/SonarSource/sonarqube-cli"
  version "1.10.0.16040"
  license "LGPL-3.0-only"

  on_macos do
    on_arm do
      url "https://binaries.sonarsource.com/Distribution/sonarqube-cli/#{version}/macos/sonarqube-cli-#{version}-macos-arm64.bin"
      sha256 "2d9fdd139431b5c304432d7cf6a792136eea679db2ff5395de0dacca0cd6dac4"
    end
  end

  on_linux do
    on_intel do
      url "https://binaries.sonarsource.com/Distribution/sonarqube-cli/#{version}/linux/sonarqube-cli-#{version}-linux-x86-64.bin"
      sha256 "d0f805f29984888504cfc750f30cb4de1ae8172a2ac38f88e79f057a519cbc9e"
    end

    on_arm do
      url "https://binaries.sonarsource.com/Distribution/sonarqube-cli/#{version}/linux/sonarqube-cli-#{version}-linux-arm64.bin"
      sha256 "a04b1900cf24c5560be05c290f06349b7c9e3967a94515db745353a2e5689f03"
    end
  end

  def install
    binary = Dir["sonarqube-cli-*"].first
    bin.install binary => "sonar"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sonar --version")
  end
end
