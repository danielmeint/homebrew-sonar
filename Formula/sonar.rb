class Sonar < Formula
  desc "CLI tool for SonarQube"
  homepage "https://github.com/SonarSource/sonarqube-cli"
  version "1.7.0.4638"
  license "LGPL-3.0-only"

  on_macos do
    on_arm do
      url "https://binaries.sonarsource.com/Distribution/sonarqube-cli/#{version}/macos/sonarqube-cli-#{version}-macos-arm64.bin"
      sha256 "8a4611b2899dafeef2be6c2d820b3d2c004a02acd012bf7b0f1fd08ca9193659"
    end
  end

  on_linux do
    on_intel do
      url "https://binaries.sonarsource.com/Distribution/sonarqube-cli/#{version}/linux/sonarqube-cli-#{version}-linux-x86-64.bin"
      sha256 "42b9dd631120b8776cd63daafd18db8e2d1229fdcde2a3ce6ef258580eb63a8c"
    end

    on_arm do
      url "https://binaries.sonarsource.com/Distribution/sonarqube-cli/#{version}/linux/sonarqube-cli-#{version}-linux-arm64.bin"
      sha256 "f4a69cc7f9c1312567572f674e4343094e6325e1c142d05d3e491482d8979329"
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
